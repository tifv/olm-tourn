from itertools import zip_longest
from collections import OrderedDict as ODict

from pathlib import PurePosixPath as PurePath

from jeolm.driver import Driver as OriginalDriver
from jeolm.driver import RecordNotFoundError, fetch_metarecord
from jeolm.utils import pure_join

import logging
logger = logging.getLogger(__name__)

class Driver(OriginalDriver):


    ##########
    # High-level functions

    def __init__(self, metarecords):
        super().__init__(metarecords)
        self.translations = self.metarecords.get_root()['$translations']


    ##########
    # Record-level functions

    tourn_flags = frozenset((
        'problems', 'solutions', 'complete', 'jury', 'blank' ))
    contest_flags=frozenset((
        'problems', 'solutions', 'complete', 'jury' ))
    regatta_flags=frozenset((
        'problems', 'solutions', 'complete', 'jury', 'blank' ))
    @classmethod
    def get_tourn_flags(cls, tourn_key):
        if tourn_key in {'$contest', '$contest$league', '$contest$problem'}:
            return cls.contest_flags
        elif tourn_key in {'$regatta', '$regatta$league',
            '$regatta$subject', '$regatta$round',
            '$regatta$problem'
        }:
            return cls.regatta_flags
        else:
            raise AssertionError(tourn_key)

    # Extension
    def find_delegators(self, metapath, flags, metarecord):

        yield from super().find_delegators(metapath, flags, metarecord)
        if '$tourn$key' not in metarecord:
            return
        tourn_key = metarecord['$tourn$key']

        if tourn_key in {'$contest', '$regatta'}:
            for leaguekey in metarecord[tourn_key]['leagues']:
                yield metapath/leaguekey, flags
        elif tourn_key == '$contest$league':
            pass
        elif tourn_key == '$contest$problem':
            if not flags.intersection(self.contest_flags):
                yield metapath, flags.union(('problems',))
        elif tourn_key == '$regatta$league':
            by_subject = 'by-subject' in flags or 'by-round' not in flags
            flags = flags.difference(('by-subject', 'by-round',))
            league = metarecord['$regatta$league']
            if by_subject:
                for subjectkey in league['subjects']:
                    yield metapath/subjectkey, flags
            else:
                for roundnum in range(1, 1 + league['rounds']):
                    yield metapath/str(roundnum), flags
        elif tourn_key in {'$regatta$subject', '$regatta$round', '$regatta$problem'}:
            if not flags.intersection(self.regatta_flags):
                yield metapath, flags.union(('problems',))
        else:
            raise AssertionError(tourn_key)

    def generate_manner(self, metapath, flags, metarecord):
        ignore_manner = (
            '$contest$key' in metarecord and
                flags.intersection(self.contest_flags) or
            '$regatta$key' in metarecord and
                flags.intersection(self.regatta_flags) )
        if ignore_manner:
            flags = flags.union(('matter',))
        return super().generate_manner(metapath, flags, metarecord)

    @fetch_metarecord
    def generate_matter_metabody(self, metapath, flags, metarecord,
        *, date_set=None
    ):

        if '$tourn$key' not in metarecord or 'every-header' in flags:
            if date_set is None:
                date_set = set()
            yield from super().generate_matter_metabody(
                metapath, flags, metarecord, date_set=date_set )
            return

        tourn_key = metarecord['$tourn$key']
        no_league = tourn_key in {'$contest', '$regatta'}
        is_regatta = tourn_key in {'$regatta', '$regatta$league',
            '$regatta$subject', '$regatta$round', '$regatta$problem',}
        is_regatta_blank = is_regatta and 'blank' in flags
        single_problem = tourn_key in {'$contest$problem', '$regatta$problem'}
        if 'no-header' not in flags and not is_regatta_blank:
            assert 'blank' not in flags
            if no_league:
                yield {'verbatim' : self.constitute_leaguedef(None)}
            else:
                league = self.find_league(metarecord)
                yield {'verbatim' : self.constitute_leaguedef(
                    self.find_name(league, metarecord['$lang']) )}
                if not single_problem:
                    flags = flags.union(('league-contained',))
            if single_problem:
                yield {'verbatim' : self.substitute_jeolmtournheader_nospace()}
            else:
                yield {'verbatim' : self.substitute_jeolmtournheader()}
        if 'no-header' not in flags:
            flags = flags.union(('no-header',))

        matter = self.generate_tourn_matter(metapath, flags, metarecord)
        pseudorecord = metarecord.copy()
        self.clear_flagged_keys(pseudorecord, '$matter')
        pseudorecord['$matter'] = matter
        yield from super().generate_matter_metabody(
            metapath, flags, pseudorecord, date_set=set() )

    def generate_tourn_matter(self, metapath, flags, metarecord):
        tourn_key = metarecord['$tourn$key']
        tourn_flags = flags.intersection(self.get_tourn_flags(tourn_key))
        if len(tourn_flags) > 1:
            raise ValueError(sorted(tourn_flags))

        args = [metapath, flags, metarecord]
        kwargs = dict()
        if tourn_key.startswith('$contest'):
            kwargs.update(contest=self.find_contest(metarecord))
        elif tourn_key.startswith('$regatta'):
            kwargs.update(regatta=self.find_regatta(metarecord))
        else:
            raise AssertionError(tourn_key)
        if tourn_key not in {'$contest', '$regatta'}:
            kwargs.update(league=self.find_league(metarecord))

        if tourn_key == '$contest':
            method = self.generate_contest_matter
        elif tourn_key == '$regatta':
            method = self.generate_regatta_matter
        elif tourn_key == '$contest$league':
            method = self.generate_contest_league_matter
        elif tourn_key == '$regatta$league':
            method = self.generate_regatta_league_matter
        elif tourn_key == '$regatta$subject':
            method = self.generate_regatta_subject_matter
        elif tourn_key == '$regatta$round':
            method = self.generate_regatta_round_matter
        elif tourn_key == '$contest$problem':
            method = self.generate_contest_problem_matter
        elif tourn_key == '$regatta$problem':
            method = self.generate_regatta_problem_matter
        else:
            raise AssertionError(tourn_key)

        yield from method(*args, **kwargs)

    def generate_contest_matter(self, metapath, flags, metarecord,
        *, contest
    ):
        if not flags.intersection(self.contest_flags):
            yield from self.generate_contest_matter(
                metapath, flags.union(('problems',)), metarecord,
                contest=contest, )
            return
        yield {'verbatim' : self.constitute_section(
            self.find_name(contest, metarecord['$lang']),
            flags=flags )}
        if 'contained' not in flags:
            flags = flags.union(('contained',))
        flags = flags.union(self.increase_containment(flags))

        for leaguekey in contest['leagues']:
            yield {'matter' : leaguekey, 'flags' : flags}

    def generate_regatta_matter(self, metapath, flags, metarecord,
        *, regatta
    ):
        if not flags.intersection(self.regatta_flags):
            yield from self.generate_regatta_matter(
                metapath, flags.union(('problems',)), metarecord,
                regatta=regatta, )
            return
        if 'blank' not in flags:
            yield {'verbatim' : self.constitute_section(
                self.find_name(regatta, metarecord['$lang']),
                flags=flags )}
            if 'contained' not in flags:
                flags = flags.union(('contained',))
            flags = flags.union(self.increase_containment(flags))

        for leaguekey in regatta['leagues']:
            yield {'matter' : leaguekey, 'flags' : flags}

    def generate_contest_league_matter(self, metapath, flags, metarecord,
        *, contest, league
    ):
        if not flags.intersection(self.contest_flags):
            yield from self.generate_contest_league_matter(
                metapath, flags.union(('problems',)), metarecord,
                contest=contest, league=league )
            yield {'verbatim' : self.substitute_postword()}
            return
        add_flags = set()
        if 'league-contained' in flags:
            yield {'verbatim' : self.constitute_section(
                self.find_name(contest, metarecord['$lang']),
                #league_name,
                flags=flags )}
        else:
            league_name = self.find_name(league, metarecord['$lang'])
            yield {'verbatim' : self.constitute_section(
                self.find_name(contest, metarecord['$lang']),
                league_name,
                flags=flags )}

        yield {'verbatim' : self.constitute_begin_tourn_problems(
            flags.intersection(self.contest_flags) )}
        add_flags.add('itemized')
        for i in range(1, 1 + league['problems']):
            yield {'matter' : str(i), 'add flags' : add_flags }
        yield {'verbatim' : self.substitute_end_tourn_problems()}

    def generate_regatta_league_matter(self, metapath, flags, metarecord,
        *, regatta, league
    ):
        if not flags.intersection(self.regatta_flags):
            yield from self.generate_regatta_league_matter(
                metapath, flags.union(('problems',)), metarecord,
                regatta=regatta, league=league )
            return
        add_flags = set()
        if 'blank' not in flags:
            if 'league-contained' in flags:
                yield {'verbatim' : self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    #league_name,
                    flags=flags )}
            else:
                league_name = self.find_name(league, metarecord['$lang'])
                yield {'verbatim' : self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    league_name,
                    flags=flags )}
                add_flags.add('league-contained')
            if 'contained' not in flags:
                add_flags.add('contained')
            add_flags.update(self.increase_containment(flags))
        by_round = 'by-round' in flags or not 'by-subject' in flags

        if by_round:
            for roundnum in range(1, 1 + league['rounds']):
                yield {'matter' : str(roundnum), 'add flags' : add_flags}
        else:
            for subjectkey in league['subjects']:
                yield {'matter' : subjectkey, 'add flags' : add_flags}

    def generate_regatta_subject_matter(self, metapath, flags, metarecord,
        *, regatta, league
    ):
        if not flags.intersection(self.regatta_flags):
            yield from self.generate_regatta_subject_matter(
                metapath, flags.union(('problems',)), metarecord,
                regatta=regatta, league=league )
            return

        subject = self.find_regatta_subject(metarecord)
        if 'blank' not in flags:
            if 'league-contained' in flags:
                yield {'verbatim' : self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    #league_name,
                    self.find_name(subject, metarecord['$lang']),
                    flags=flags )}
            else:
                league_name = self.find_name(league, metarecord['$lang'])
                yield {'verbatim' : self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    league_name,
                    self.find_name(subject, metarecord['$lang']),
                    flags=flags )}

        if 'blank' not in flags:
            yield {'verbatim' : self.constitute_begin_tourn_problems(
                flags.intersection(self.regatta_flags) )}
            flags = flags.union(('itemized',))
        for roundnum in range(1, 1 + league['rounds']):
            yield {'matter' : str(roundnum), 'flags' : flags}
        if 'blank' not in flags:
            yield {'verbatim' : self.substitute_end_tourn_problems()}

    def generate_regatta_round_matter(self, metapath, flags, metarecord,
        *, regatta, league
    ):
        if not flags.intersection(self.regatta_flags):
            yield from self.generate_regatta_round_matter(
                metapath, flags.union(('problems',)), metarecord,
                regatta=regatta, league=league )
            return

        round = self.find_regatta_round(metarecord)
        if 'blank' not in flags:
            if 'league-contained' in flags:
                yield {'verbatim' : self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    #league_name,
                    self.find_name(round, metarecord['$lang']),
                    flags=flags )}
            else:
                league_name = self.find_name(league, metarecord['$lang'])
                yield {'verbatim' : self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    league_name,
                    self.find_name(round, metarecord['$lang']),
                    flags=flags )}

        if 'blank' not in flags:
            yield {'verbatim' : self.constitute_begin_tourn_problems(
                flags.intersection(self.regatta_flags) )}
            flags = flags.union(('itemized',))
        for subjectkey in league['subjects']:
            yield { 'matter' : '../{}/{}'.format(subjectkey, metapath.name),
                'flags' : flags }
        if 'blank' not in flags:
            yield {'verbatim' : self.substitute_end_tourn_problems()}

    def generate_contest_problem_matter(self, metapath, flags, metarecord,
        *, contest, league
    ):
        if not flags.intersection(self.contest_flags):
            assert 'problems' not in flags, flags.as_set()
            yield from self.generate_contest_problem_matter(
                metapath, flags.union(('problems',)), metarecord,
                contest=contest, league=league )
            return
        if 'itemized' not in flags:
            yield {'verbatim' : self.constitute_begin_tourn_problems(
                flags.intersection(self.contest_flags) )}
        yield {
            'inpath' : metapath.with_suffix('.tex'),
            'number' : metapath.name }
        if 'itemized' not in flags:
            yield {'verbatim' : self.substitute_end_tourn_problems()}

    def generate_regatta_problem_matter(self, metapath, flags, metarecord,
        *, regatta, league
    ):
        if not flags.intersection(self.regatta_flags):
            yield from self.generate_regatta_problem_matter(
                metapath, flags.union(('problems',)), metarecord,
                regatta=regatta, league=league )
            return
        subject = self.find_regatta_subject(metarecord)
        round = self.find_regatta_round(metarecord)
        if 'blank' in flags:
            assert 'itemized' not in flags, (metapath, flags.as_set())
            assert 'league-contained' not in flags
            yield {'verbatim' : self.constitute_leaguedef(
                self.find_name(league, metarecord['$lang']) )}
            yield {'verbatim' : self.substitute_jeolmtournheader_nospace()}
            yield {'verbatim' : self.substitute_regatta_blank_caption(
                caption=self.find_name(regatta, metarecord.get('$lang')),
                mark=round['mark'] )}
        if 'itemized' not in flags:
            yield {'verbatim' : self.constitute_begin_tourn_problems(
                flags.intersection(self.regatta_flags) )}
        yield {
            'inpath' : metapath.with_suffix('.tex'),
            'number' : self.substitute_regatta_number(
                subject_index=subject['index'],
                round_index=round['index'] )
            }
        if 'itemized' not in flags:
            yield {'verbatim' : self.substitute_end_tourn_problems()}
        if 'blank' in flags:
            yield {'verbatim' : self.substitute_hrule()}
            yield {'verbatim' : self.substitute_clearpage()}

    def find_contest(self, metarecord):
        contest_key = metarecord['$contest$key']
        if contest_key == '$contest':
            return metarecord[contest_key]
        elif contest_key in {'$contest$league', '$contest$problem'}:
            return self.find_contest(self.metarecords[
                metarecord['$path'].parent() ])
        else:
            raise AssertionError(contest_key, metarecord)

    def find_regatta(self, metarecord):
        regatta_key = metarecord['$regatta$key']
        if regatta_key == '$regatta':
            return metarecord[regatta_key]
        elif regatta_key in { '$regatta$league',
            '$regatta$subject', '$regatta$round', '$regatta$problem'
        }:
            return self.find_regatta(self.metarecords[
                metarecord['$path'].parent() ])
        else:
            raise AssertionError(regatta_key, metarecord)

    def find_league(self, metarecord):
        tourn_key = metarecord['$tourn$key']
        if tourn_key in {'$contest$league', '$regatta$league'}:
            return metarecord[tourn_key]
        elif tourn_key in { '$contest$problem',
            '$regatta$subject', '$regatta$round', '$regatta$problem'
        }:
            return self.find_league(self.metarecords[
                metarecord['$path'].parent() ])
        else:
            raise AssertionError(tourn_key, metarecord)

    def find_regatta_subject(self, metarecord):
        regatta_key = metarecord['$regatta$key']
        if regatta_key == '$regatta$subject':
            return metarecord['$regatta$subject']
        elif regatta_key == '$regatta$problem':
            return self.find_regatta_subject(self.metarecords[
                metarecord['$path'].parent() ])
        else:
            raise AssertionError(regatta_key, metarecord)

    def find_regatta_round(self, metarecord):
        regatta_key = metarecord['$regatta$key']
        if regatta_key == '$regatta$round':
            return metarecord['$regatta$round']
        elif regatta_key == '$regatta$problem':
            metapath = metarecord['$path']
            return self.find_regatta_round(self.metarecords[
                metapath.parent(2)/metapath.name ])
        else:
            raise AssertionError(regatta_key, metarecord)

    def find_name(self, entity, lang):
        name = entity['name']
        if isinstance(name, str):
            return name
        elif isinstance(name, dict):
            (key, value), = name.items()
            if key == 'translate-metaname':
                key, value = 'translate', entity['metaname']
            if key == 'translate':
                return self.translations[value][lang]
            else:
                raise ValueError(name)
        else:
            raise TypeError(name)

    ##########
    # Record accessor

    class Metarecords(OriginalDriver.Metarecords):
        contest_keys = frozenset((
            '$contest', '$contest$league', '$contest$problem' ))
        regatta_keys = frozenset((
            '$regatta', '$regatta$league',
            '$regatta$subject', '$regatta$round',
            '$regatta$problem' ))

        def derive_attributes(self, parent_record, child_record, name):
            super().derive_attributes(parent_record, child_record, name)
            path = child_record['$path']
            child_record.setdefault('$lang', parent_record.get('$lang'))
            if '$contest$league' in parent_record:
                child_record['$contest$problem'] = {}
            if '$regatta$subject' in parent_record:
                child_record['$regatta$problem'] = {}

            contest_keys = self.contest_keys.intersection(child_record.keys())
            if contest_keys:
                contest_key, = contest_keys
                child_record['$contest$key'] = contest_key
            else:
                contest_key = None

            regatta_keys = self.regatta_keys.intersection(child_record.keys())
            if regatta_keys:
                regatta_key, = regatta_keys
                child_record['$regatta$key'] = regatta_key
            else:
                regatta_key = None

            if contest_key and regatta_key:
                raise ValueError(child_record.keys())

            tourn_key = contest_key or regatta_key
            if not tourn_key:
                return
            child_record['$tourn$key'] = tourn_key
            tourn_entity = child_record[tourn_key] = \
                child_record[tourn_key].copy()
            tourn_entity['metaname'] = path.name

    ##########
    # LaTeX-level functions

    # Extension
    @classmethod
    def constitute_body_input(cls, inpath,
        *,alias, figname_map, number=None, **kwargs
    ):
        if number is None:
            return super().constitute_body_input(
                inpath, alias=alias, figname_map=figname_map, **kwargs )
        else:
            assert not kwargs, kwargs

        body = cls.substitute_tourn_problem_input(
            number=number, filename=alias, inpath=inpath )
        if figname_map:
            body = cls.constitute_figname_map(figname_map) + '\n' + body
        return body

    tourn_problem_input_template = (
        r'\tournproblem{$number}' '\n'
        r'\input{$filename}% $inpath' )

    @classmethod
    def constitute_section(cls, *names, flags):
        try:
            select, = flags.intersection(
                ('problems', 'solutions', 'complete', 'jury',) )
        except ValueError as exc:
            exc.args += (flags,)
            raise
        caption = names[-1]
        if 'subsubcontained' in flags:
            substitute_section = cls.substitute_subsubsection
        elif 'subcontained' in flags:
            substitute_section = cls.substitute_subsection
        else:
            substitute_section = cls.substitute_section
        if 'contained' not in flags:
            caption = '. '.join(names) + cls.caption_select_appendage[select]
        return substitute_section(caption=caption)

    section_template = r'\section*{$caption}'
    subsection_template = r'\subsection*{$caption}'
    subsubsection_template = r'\subsubsection*{$caption}'
    caption_select_appendage = {
        'problems' : '',
        'solutions' : ' (решения)',
        'complete' : ' (с решениями)',
        'jury' : ' (версия для жюри)',
    }

    @classmethod
    def constitute_begin_tourn_problems(cls, tourn_flags):
        select, = tourn_flags
        return cls.substitute_begin_tourn_problems(select=select)

    @classmethod
    def constitute_leaguedef(cls, league_name):
        if league_name is None:
            return cls.substitute_leagueundef()
        return cls.substitute_leaguedef(league=league_name)

    leagueundef_template = r'\let\jeolmleague\relax'
    leaguedef_template = r'\def\jeolmleague{$league}'

    begin_tourn_problems_template = r'\begin{tourn-problems}{$select}'
    end_tourn_problems_template = r'\end{tourn-problems}'
    postword_template = r'\postword'

    jeolmtournheader_template = r'\jeolmtournheader'
    jeolmtournheader_nospace_template = r'\jeolmtournheader*'
    regatta_blank_caption_template = r'\regattablankcaption{$caption}{$mark}'
    hrule_template = r'\medskip\hrule'

    regatta_number_template = r'$round_index$subject_index'

    ##########
    # Supplementary finctions

    @classmethod
    def digest_metabody_item(cls, item):
        assert isinstance(item, dict), item
        if item.keys() == {'inpath', 'number'}:
            return item.copy()
        else:
            return super().digest_metabody_item(item)

    @staticmethod
    def increase_containment(flags):
        if 'subcontained' not in flags:
            yield 'subcontained'
        elif 'subsubcontained' not in flags:
            yield 'subsubcontained'
        else:
            raise ValueError(flags)


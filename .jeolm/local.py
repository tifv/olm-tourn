from itertools import zip_longest
from collections import OrderedDict as ODict
from functools import wraps

from pathlib import PurePosixPath as PurePath

from jeolm.driver import Driver as OriginalDriver
from jeolm.driver import RecordNotFoundError, fetch_metarecord
from jeolm.utils import pure_join
from jeolm.flags import FlagSet

import logging
logger = logging.getLogger(__name__)

def default_tourn_flags(add_flags):
    def wrapper(method):
        @wraps(method)
        def wrapped(self, metapath, flags, metarecord, **kwargs):
            if not flags.intersection(self.get_tourn_flags(metarecord)):
                flags = flags.union(add_flags)
            return method(self, metapath, flags, metarecord, **kwargs)
        return wrapped
    return wrapper

class Driver(OriginalDriver):


    ##########
    # High-level functions

    def __init__(self, metarecords):
        super().__init__(metarecords)
        self.translations = self.metarecords.get_root()['$translations']


    ##########
    # Record-level functions

#    tourn_flags = frozenset((
#        'problems', 'solutions', 'complete', 'jury', 'blank' ))
    contest_flags=frozenset((
        'problems', 'solutions', 'complete', 'jury' ))
    regatta_flags=frozenset((
        'problems', 'solutions', 'complete', 'jury', 'blank' ))
    @classmethod
    def get_tourn_flags(cls, tourn_key):
        if isinstance(tourn_key, dict):
            tourn_key = tourn_key['$tourn$key']
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
        elif tourn_key in {'$regatta$subject', '$regatta$round',
            '$regatta$problem'
        }:
            if not flags.intersection(self.regatta_flags):
                yield metapath, flags.union(('problems',))
        else:
            raise AssertionError(tourn_key)

    @fetch_metarecord
    def generate_matter_metabody(self, metapath, flags, metarecord,
        *, date_set=None, seen_targets=frozenset(), matter=None
    ):

        if '$tourn$key' not in metarecord or matter is not None:
            if date_set is None:
                date_set = set()
            yield from super().generate_matter_metabody(
                metapath, flags, metarecord, date_set=date_set,
                seen_targets=seen_targets, matter=matter )
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
        flags = flags.union(('no-header',), overadd=False)

        matter = self.generate_tourn_matter(metapath, flags, metarecord)
        yield from self.generate_matter_metabody(
            metapath, flags, metarecord, matter=matter,
            date_set=set(), seen_targets=seen_targets, )

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

    @default_tourn_flags({'problems'})
    def generate_contest_matter(self, metapath, flags, metarecord,
        *, contest
    ):
        assert flags.intersection(self.get_tourn_flags(metarecord)), flags.as_set()
        yield {'verbatim' : self.constitute_section(
            self.find_name(contest, metarecord['$lang']),
            flags=flags )}
        flags = flags.union(('contained',), overadd=False)
        flags = flags.union(self.increase_containment(flags))

        for leaguekey in contest['leagues']:
            yield {'matter' : leaguekey, 'flags' : flags}

    @default_tourn_flags({'problems'})
    def generate_regatta_matter(self, metapath, flags, metarecord,
        *, regatta
    ):
        if 'blank' not in flags:
            yield {'verbatim' : self.constitute_section(
                self.find_name(regatta, metarecord['$lang']),
                flags=flags )}
            flags = flags.union(('contained',), overadd=False)
            flags = flags.union(self.increase_containment(flags))

        for leaguekey in regatta['leagues']:
            yield {'matter' : leaguekey, 'flags' : flags}

    def generate_contest_league_matter(self, metapath, flags, metarecord,
        *, contest, league
    ):
        if not flags.intersection(self.contest_flags):
            yield from self.generate_contest_league_matter(
                metapath, flags.union(('problems', 'no-problem-sources')),
                metarecord,
                contest=contest, league=league )
            yield {'verbatim' : self.substitute_postword()}
            return
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
        flags = flags.union(('itemized',))
        for i in range(1, 1 + league['problems']):
            yield {'matter' : str(i), 'flags' : flags }
        yield {'verbatim' : self.substitute_end_tourn_problems()}

    @default_tourn_flags({'problems'})
    def generate_regatta_league_matter(self, metapath, flags, metarecord,
        *, regatta, league
    ):
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
                flags = flags.union(('league-contained',))
            flags = flags.union(('contained',), overadd=False)
            flags = flags.union(self.increase_containment(flags))
        by_round = 'by-round' in flags or not 'by-subject' in flags

        if by_round:
            for roundnum in range(1, 1 + league['rounds']):
                yield {'matter' : str(roundnum), 'flags' : flags}
        else:
            for subjectkey in league['subjects']:
                yield {'matter' : subjectkey, 'flags' : flags}

    @default_tourn_flags({'problems'})
    def generate_regatta_subject_matter(self, metapath, flags, metarecord,
        *, regatta, league
    ):
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

    @default_tourn_flags({'problems'})
    def generate_regatta_round_matter(self, metapath, flags, metarecord,
        *, regatta, league
    ):
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

    @default_tourn_flags({'problems'})
    def generate_contest_problem_matter(self, metapath, flags, metarecord,
        *, contest, league
    ):
        yield from self.generate_tourn_problem_matter(
            metapath, flags, metarecord,
            number=metapath.name )

    @default_tourn_flags({'problems'})
    def generate_regatta_problem_matter(self, metapath, flags, metarecord,
        *, regatta, league
    ):
        subject = self.find_regatta_subject(metarecord)
        round = self.find_regatta_round(metarecord)
        if 'blank' in flags:
            assert 'itemized' not in flags, (metapath, flags.as_set())
            flags = flags.union(('no-problem-sources',), overadd=False)
            assert 'league-contained' not in flags
            yield {'verbatim' : self.constitute_leaguedef(
                self.find_name(league, metarecord['$lang']) )}
            yield {'verbatim' : self.substitute_jeolmtournheader_nospace()}
            yield {'verbatim' : self.substitute_regatta_blank_caption(
                caption=self.find_name(regatta, metarecord['$lang']),
                mark=round['mark'] )}
        yield from self.generate_tourn_problem_matter(
            metapath, flags, metarecord,
            number=self.substitute_regatta_number(
                subject_index=subject['index'],
                round_index=round['index'] )
        )
        if 'blank' in flags:
            yield {'verbatim' : self.substitute_hrule()}
            yield {'verbatim' : self.substitute_clearpage()}

    def generate_tourn_problem_matter(self, metapath, flags, metarecord,
        *, number
    ):
        if 'itemized' not in flags:
            yield {'verbatim' : self.constitute_begin_tourn_problems(
                flags.intersection(self.contest_flags) )}
        yield {
            'inpath' : metapath.with_suffix('.tex'),
            'number' : number }
        if 'jury' in flags and '$criteria' in metarecord:
            yield {'verbatim' : self.substitute_criteria(
                criteria=metarecord['$criteria'] )}
        if 'no-problem-sources' not in flags:
            problem_source = metarecord.get('$problem-source')
            if problem_source is not None:
                yield {'verbatim' : self.substitute_problem_source(
                    source=problem_source )}
        if 'itemized' not in flags:
            yield {'verbatim' : self.substitute_end_tourn_problems()}

    def find_contest(self, metarecord):
        contest_key = metarecord['$contest$key']
        if contest_key == '$contest':
            return metarecord[contest_key]
        elif contest_key in {'$contest$league', '$contest$problem'}:
            return self.find_contest(self.metarecords[
                metarecord['$path'].parent ])
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
                metarecord['$path'].parent ])
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
                metarecord['$path'].parent ])
        else:
            raise AssertionError(tourn_key, metarecord)

    def find_regatta_subject(self, metarecord):
        regatta_key = metarecord['$regatta$key']
        if regatta_key == '$regatta$subject':
            return metarecord['$regatta$subject']
        elif regatta_key == '$regatta$problem':
            return self.find_regatta_subject(self.metarecords[
                metarecord['$path'].parent ])
        else:
            raise AssertionError(regatta_key, metarecord)

    def find_regatta_round(self, metarecord):
        regatta_key = metarecord['$regatta$key']
        if regatta_key == '$regatta$round':
            return metarecord['$regatta$round']
        elif regatta_key == '$regatta$problem':
            metapath = metarecord['$path']
            return self.find_regatta_round(self.metarecords[
                metapath.parent.parent/metapath.name ])
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
            assert isinstance(flags, FlagSet), type(flags)
            exc.args += (flags.as_set(),)
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

    criteria_template = r'\emph{Критерии: $criteria}'
    problem_source_template = ( r''
        r'\nopagebreak'
        r'\vspace{-1ex}\begingroup'
            r'\hfill\itshape\small($source)'
        r'\endgroup'
    )

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


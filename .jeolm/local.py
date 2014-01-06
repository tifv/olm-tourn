from itertools import zip_longest
from collections import OrderedDict
from functools import wraps

from pathlib import PurePosixPath

from jeolm.driver.generic import (
    Driver as GenericDriver, DriverError,
    RecordPath, RecordNotFoundError )

import logging
logger = logging.getLogger(__name__)

class Driver(GenericDriver):


    ##########
    # Interface functions

    def __init__(self, metarecords):
        super().__init__(metarecords)
        self.translations = self.metarecords.get_root()['$translations']


    ##########
    # Record-level functions

    @classmethod
    def get_tourn_flags(cls, tourn_key):
        setlist = [cls.tourn_problem_flags]
        if tourn_key not in \
                {'$contest', '$contest$problem', '$regatta$problem'}:
            setlist.append(('contest', 'jury',))
        else:
            if tourn_key == '$regatta$problem':
                setlist.append(('blank',))
        return frozenset().union(*setlist)

    tourn_problem_flags = frozenset(('problems', 'solutions', 'complete',))

    all_tourn_flags = frozenset((
        'problems', 'solutions', 'complete',
        'contest', 'jury', 'blank' ))

    # Extension
    def generate_delegators(self, target, metarecord):

        try:
            yield from super().generate_delegators(target, metarecord)
        except self.NoDelegators:
            if '$tourn$key' not in metarecord:
                raise
            else:
                pass
        else:
            return
        tourn_key = metarecord['$tourn$key']
        tourn_flags = self.get_tourn_flags(tourn_key)

        if tourn_key in {'$contest', '$regatta'}:
            for leaguekey in metarecord[tourn_key]['leagues']:
                yield target.path_derive(leaguekey)
        elif tourn_key in self.undelegating_keys:
            if not target.flags.intersection(tourn_flags):
                yield target.flags_union({'complete'})
            else:
                raise self.NoDelegators
        elif tourn_key == '$regatta$league':
            by_subject = ( 'by-subject' in target.flags or
                'by-round' not in target.flags )
            target = target.flags_difference(('by-subject', 'by-round',))
            league = metarecord['$regatta$league']
            if by_subject:
                for subjectkey in league['subjects']:
                    yield target.path_derive(subjectkey)
            else:
                for roundnum in range(1, 1 + league['rounds']):
                    yield target.path_derive(str(roundnum))
        else:
            raise RuntimeError(tourn_key)

    undelegating_keys = frozenset((
        '$contest$league', '$contest$problem',
        '$regatta$subject', '$regatta$round', '$regatta$problem' ))

    @processing_target(aspect='matter [tourn]', wrap_generator=True)
    @classify_items(aspect='matter', default='verbatim')
    def generate_matter(self, target, metarecord,
        *, pre_matter=None, recursed=False
    ):

        if '$tourn$key' not in metarecord or pre_matter is not None:
            yield from super().generate_matter(
                target, metarecord, pre_matter=pre_matter )
            return
        assert not recursed

        tourn_key = metarecord['$tourn$key']
        no_league = tourn_key in {'$contest', '$regatta'}
        is_regatta = tourn_key in self.regatta_keys
        is_contest = tourn_key in self.contest_keys
        assert is_regatta or is_contest
        single_problem = tourn_key in {'$contest$problem', '$regatta$problem'}
        is_regatta_blank = is_regatta and (
            not single_problem and 'contest' in target.flags
            or
            single_problem and 'blank' in target.flags )
        if 'no-header' not in target.flags and not is_regatta_blank:
            if no_league:
                yield self.constitute_leaguedef(None)
            else:
                league = self.find_league(metarecord)
                yield self.constitute_leaguedef(
                    self.find_name(league, metarecord['$lang']) )
                if not single_problem:
                    target = target.flags_union({'league-contained'})
            if single_problem:
                yield self.substitute_jeolmtournheader_nospace()
            else:
                # Create a negative offset in anticipation of \section
                yield self.substitute_jeolmtournheader()
            target = target.flags_union({'no-header'}, overadd=False)

        yield from self.generate_tourn_matter(target, metarecord)

    @processing_target(aspect='tourn matter', wrap_generator=True)
    @classify_items(aspect='matter', default=None)
    def generate_tourn_matter(self, target, metarecord):
        tourn_key = metarecord['$tourn$key']
        tourn_flags = target.flags.intersection(
            self.get_tourn_flags(tourn_key) )
        if len(tourn_flags) > 1:
            raise ValueError(sorted(tourn_flags))

        args = [target, metarecord]
        kwargs = dict()
        if tourn_key in self.contest_keys:
            kwargs.update(contest=self.find_contest(metarecord))
        elif tourn_key in self.regatta_keys:
            kwargs.update(regatta=self.find_regatta(metarecord))
        else:
            raise RuntimeError(tourn_key)
        if tourn_key in self.subleague_keys:
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
            raise RuntimeError(tourn_key)

        yield from method(*args, **kwargs)

    subleague_keys = frozenset((
        '$contest$league', '$regatta$league',
        '$regatta$subject', '$regatta$round',
        '$contest$problem', '$regatta$problem', ))

    def default_tourn_flags(add_flags):
        """Decorator factory."""
        add_flags = frozenset(add_flags)
        def wrapper(method):
            @wraps(method)
            def wrapped(self, target, metarecord, **kwargs):
                tourn_flags = self.get_tourn_flags(metarecord['$tourn$key'])
                all_tourn_flags = self.all_tourn_flags
                misused_flags = target.flags.intersection(
                    all_tourn_flags - tourn_flags )
                if misused_flags:
                    raise DriverError(misused_flags)
                if not target.flags.intersection(tourn_flags):
                    target = target.flags_union(add_flags)
                return method(self, target, metarecord, **kwargs)
            return wrapped
        return wrapper
    default_tourn_flags.is_inclass_decorator = True

    @classify_items(aspect='matter', default='verbatim')
    @default_tourn_flags({'complete'})
    def generate_contest_matter(self, target, metarecord,
        *, contest
    ):
        yield self.constitute_section(
            self.find_name(contest, metarecord['$lang']),
            flags=target.flags )
        target = target.flags_union({'contained'}, overadd=False)
        target = target.flags_union(self.increase_containment(target.flags))

        for leaguekey in contest['leagues']:
            yield target.path_derive(leaguekey)

    @classify_items(aspect='matter', default='verbatim')
    @default_tourn_flags({'complete'})
    def generate_regatta_matter(self, target, metarecord,
        *, regatta
    ):
        if 'contest' not in target.flags:
            yield self.constitute_section(
                self.find_name(regatta, metarecord['$lang']),
                flags=target.flags )
            target = target.flags_union({'contained'}, overadd=False)
            target = target.flags_union(self.increase_containment(target.flags))

        for leaguekey in regatta['leagues']:
            yield target.path_derive(leaguekey)

    @classify_items(aspect='matter', default='verbatim')
    @default_tourn_flags({'complete'})
    def generate_contest_league_matter(self, target, metarecord,
        *, contest, league
    ):
        if 'contest' in target.flags:
            target = target.flags_difference({'contest'}) \
                .flags_union({'problems', 'without-problem-sources'})
            has_postword = True
        else:
            has_postword = False
        if 'league-contained' in target.flags:
            yield self.constitute_section(
                self.find_name(contest, metarecord['$lang']),
                #league_name,
                flags=target.flags )
        else:
            league_name = self.find_name(league, metarecord['$lang'])
            yield self.constitute_section(
                self.find_name(contest, metarecord['$lang']),
                league_name,
                flags=target.flags )

        if 'jury' in target.flags:
            target = target.flags_difference({'jury'}) \
                .flags_union({'complete', 'with-criteria'})
        yield self.constitute_begin_tourn_problems(
            target.flags.intersection(self.tourn_problem_flags) )
        target = target.flags_union({'itemized'})
        for i in range(1, 1 + league['problems']):
            yield target.path_derive(str(i))
        yield self.substitute_end_tourn_problems()
        if has_postword:
            yield self.substitute_postword()

    @classify_items(aspect='matter', default='verbatim')
    @default_tourn_flags({'complete'})
    def generate_regatta_league_matter(self, target, metarecord,
        *, regatta, league
    ):
        if 'contest' not in target.flags:
            if 'league-contained' in target.flags:
                yield self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    #league_name,
                    flags=target.flags )
            else:
                league_name = self.find_name(league, metarecord['$lang'])
                yield self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    league_name,
                    flags=target.flags )
                target = target.flags_union(('league-contained',))
            target = target.flags_union(('contained',), overadd=False)
            target = target.flags_union(self.increase_containment(target.flags))
        by_round = ( 'by-round' in target.flags or
            'by-subject' not in target.flags )

        if by_round:
            for roundnum in range(1, 1 + league['rounds']):
                yield target.path_derive(str(roundnum))
        else:
            for subjectkey in league['subjects']:
                yield target.path_derive(subjectkey)

    @classify_items(aspect='matter', default='verbatim')
    @default_tourn_flags({'complete'})
    def generate_regatta_subject_matter(self, target, metarecord,
        *, regatta, league
    ):
        subject = self.find_regatta_subject(metarecord)
        if 'contest' not in target.flags:
            if 'league-contained' in target.flags:
                yield self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    #league_name,
                    self.find_name(subject, metarecord['$lang']),
                    flags=target.flags )
            else:
                league_name = self.find_name(league, metarecord['$lang'])
                yield self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    league_name,
                    self.find_name(subject, metarecord['$lang']),
                    flags=target.flags )
        else:
            target = target.flags_difference({'contest'}) \
                .flags_union({'blank', 'without-problem-sources'})
        if 'jury' in target.flags:
            target = target.flags_difference({'jury'}) \
                .flags_union({'complete', 'with-criteria'})

        if 'blank' not in target.flags:
            yield self.constitute_begin_tourn_problems(
                target.flags.intersection(self.tourn_problem_flags) )
            target = target.flags_union(('itemized',))
        for roundnum in range(1, 1 + league['rounds']):
            yield target.path_derive(str(roundnum))
        if 'blank' not in target.flags:
            yield self.substitute_end_tourn_problems()

    @classify_items(aspect='matter', default='verbatim')
    @default_tourn_flags({'complete'})
    def generate_regatta_round_matter(self, target, metarecord,
        *, regatta, league
    ):
        regatta_round = self.find_regatta_round(metarecord)
        if 'contest' not in target.flags:
            if 'league-contained' in target.flags:
                yield self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    #league_name,
                    self.find_name(regatta_round, metarecord['$lang']),
                    flags=target.flags )
            else:
                league_name = self.find_name(league, metarecord['$lang'])
                yield self.constitute_section(
                    self.find_name(regatta, metarecord['$lang']),
                    league_name,
                    self.find_name(regatta_round, metarecord['$lang']),
                    flags=target.flags )
        else:
            target = target.flags_difference({'contest'}) \
                .flags_union({'blank', 'without-problem-sources'})
        if 'jury' in target.flags:
            target = target.flags_difference({'jury'}) \
                .flags_union({'complete', 'with-criteria'})

        if 'blank' not in target.flags:
            yield self.constitute_begin_tourn_problems(
                target.flags.intersection(self.tourn_problem_flags) )
            target = target.flags_union(('itemized',))
        for subjectkey in league['subjects']:
            yield target.path_derive('..', subjectkey, target.path.name)
        if 'blank' not in target.flags:
            yield self.substitute_end_tourn_problems()

    @classify_items(aspect='matter', default='verbatim')
    @default_tourn_flags({'complete'})
    def generate_contest_problem_matter(self, target, metarecord,
        *, contest, league
    ):
        yield from self.generate_tourn_problem_matter(
            target, metarecord,
            number=target.path.name )

    @classify_items(aspect='matter', default='verbatim')
    @default_tourn_flags({'complete'})
    def generate_regatta_problem_matter(self, target, metarecord,
        *, regatta, league
    ):
        subject = self.find_regatta_subject(metarecord)
        regatta_round = self.find_regatta_round(metarecord)
        if 'blank' in target.flags:
            assert 'itemized' not in target.flags, target
            assert 'league-contained' not in target.flags, target
            yield self.constitute_leaguedef(
                self.find_name(league, metarecord['$lang']) )
            yield self.substitute_jeolmtournheader_nospace()
            yield self.substitute_regatta_blank_caption(
                caption=self.find_name(regatta, metarecord['$lang']),
                mark=regatta_round['mark'] )
        yield from self.generate_tourn_problem_matter(
            target, metarecord,
            number=self.substitute_regatta_number(
                subject_index=subject['index'],
                round_index=regatta_round['index'] )
        )
        if 'blank' in target.flags:
            yield self.substitute_hrule()
            yield self.substitute_clearpage()

    class ProblemBodyItem(GenericDriver.InpathBodyItem):
        __slots__ = ['number']

        def __init__(self, problem, number):
            super().__init__(inpath=problem)
            self.number = number

    @classmethod
    def classify_metabody_item(cls, item, *, default):
        if isinstance(item, dict) and 'problem' in item:
            if not item.keys() == {'problem', 'number'}:
                raise DriverError(item)
            return cls.ProblemBodyItem(**item)
        return super().classify_metabody_item(item, default=default)

    @classify_items(aspect='matter', default='verbatim')
    def generate_tourn_problem_matter(self, target, metarecord,
        *, number
    ):
        has_criteria = ( 'with-criteria' in target.flags and
            '$criteria' in metarecord )
        has_problem_source = (
            'without-problem-sources' not in target.flags and
            '$problem-source' in metarecord )
        if 'itemized' not in target.flags:
            yield self.constitute_begin_tourn_problems(
                target.flags.intersection(self.tourn_problem_flags) )
        yield {
            'problem' : target.path.as_inpath(suffix='.tex'),
            'number' : number }
        if has_criteria:
            yield self.substitute_criteria(criteria=metarecord['$criteria'])
        if has_problem_source:
            yield self.substitute_problem_source(
                source=metarecord['$problem-source'] )
        if 'itemized' not in target.flags:
            yield self.substitute_end_tourn_problems()

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

    class Metarecords(GenericDriver.Metarecords):
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

    contest_keys = Metarecords.contest_keys
    regatta_keys = Metarecords.regatta_keys

    ##########
    # LaTeX-level functions

    @classmethod
    def constitute_body_item(cls, item):
        if isinstance(item, cls.ProblemBodyItem):
            return cls.constitute_body_problem(
                inpath=item.inpath, number=item.number,
                alias=item.alias, figname_map=item.figname_map )
        return super().constitute_body_item(item)

    # Extension
    @classmethod
    def constitute_body_problem(cls, inpath,
        *, number, alias, figname_map
    ):
        assert number is not None
        body = cls.substitute_tourn_problem(
            number=number, filename=alias, inpath=inpath )
        if figname_map:
            body = cls.constitute_figname_map(figname_map) + '\n' + body
        return body

    tourn_problem_template = (
        r'\tournproblem{$number}%' '\n'
        r'\input{$filename}% $inpath' )

    @classmethod
    def constitute_section(cls, *names, flags):
        try:
            select, = flags.intersection(
                ('problems', 'solutions', 'complete', 'jury',) )
        except ValueError as exc:
            assert isinstance(flags, FlagContainer), type(flags)
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
        assert select in {'problems', 'solutions', 'complete'}
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

    criteria_template = r'\emph{Критерии: $criteria}\par'
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


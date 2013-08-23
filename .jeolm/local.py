from itertools import zip_longest
from collections import OrderedDict as ODict

from pathlib import PurePosixPath as PurePath

from jeolm.driver import Driver as OriginalDriver, RecordNotFoundError
from jeolm.utils import pure_join

import logging
logger = logging.getLogger(__name__)

class Driver(OriginalDriver):

    # contest DELEGATE
    #     contest/league for each league
    # contest/problems FLUID
    #     contest/league/problems for each league
    # contest/solutions FLUID
    #     contest/league/solutions for each league
    # contest/complete FLUID
    #     contest/league/complete for each league
    # contest/jury DELEGATE
    #     contest/league/jury for each league
    # contest/jury FLUID
    #     contest/league/jury for each league

    # contest/league RIGID
    # contest/league/problems FLUID
    # contest/league/solutions FLUID
    # contest/league/complete FLUID
    # contest/league/jury FLUID

    # contest/league/<problem> FLUID

    # regatta DELEGATE
    #     regatta/league for each league
    # regatta/problems FLUID
    #     regatta/league/problems for each league
    # regatta/solutions FLUID
    #     regatta/league/solutions for each league
    # regatta/complete FLUID
    #     regatta/league/complete for each league
    # regatta/jury DELEGATE
    #     regatta/league/jury for each league
    # regatta/jury FLUID
    #     regatta/league/jury for each league

    # regatta/league DELEGATE
    #     regatta/league/subject for each subject
    # regatta/league/problems FLUID
    #     regatta/league/round/problems for each round
    # regatta/league/solutions FLUID
    #     regatta/league/round/solutions for each round
    # regatta/league/complete FLUID
    #     regatta/league/round/complete for each round
    # regatta/league/jury DELEGATE
    #     regatta/league/subject/jury for each subject
    # regatta/league/jury FLUID
    #     regatta/league/round/jury for each subject

    # regatta/league/subject RIGID
    # regatta/league/subject/problems FLUID
    # regatta/league/subject/solutions FLUID
    # regatta/league/subject/complete FLUID
    # regatta/league/subject/jury FLUID

    # regatta/league/round DELEGATE
    #     regatta/league/round/complete
    # regatta/league/round/problems FLUID
    # regatta/league/round/solutions FLUID
    # regatta/league/round/complete FLUID
    # regatta/league/round/jury FLUID

    # regatta/league/subject/<problem> FLUID

    ##########
    # High-level functions

    def __init__(self, inrecords, outrecords):
        super().__init__(inrecords, outrecords)
        self.translations = outrecords.get('$translations')

    def list_targets(self):
        yield from super().list_targets()
        for mimic_target, mimic_key in self.outrecords.list_mimic_targets():
            if mimic_key == '$contest':
                for key in self.contest_fluid_targets:
                    yield mimic_target/key
            elif mimic_key == '$contest$league':
                for key in self.contest_league_fluid_targets:
                    yield mimic_target/key
            elif mimic_key == '$regatta':
                for key in self.regatta_fluid_targets:
                    yield mimic_target/key
            elif mimic_key == '$regatta$league':
                for key in self.regatta_league_fluid_targets:
                    yield mimic_target/key
            elif mimic_key == '$regatta$subject':
                for key in self.regatta_subject_fluid_targets:
                    yield mimic_target/key
            elif mimic_key == '$regatta$round':
                for key in self.regatta_round_fluid_targets:
                    yield mimic_target/key

    contest_fluid_targets = \
    contest_league_fluid_targets = \
    regatta_fluid_targets = \
    regatta_league_fluid_targets = \
    regatta_subject_fluid_targets = \
    regatta_round_fluid_targets = \
        frozenset(('problems', 'solutions', 'complete', 'jury'))

    ##########
    # Record-level functions

    # Extension
    def _trace_delegators(self, target, resolved_path, record,
        *, seen_targets
    ):
        if not '$mimic$key' in record:
            yield from super()._trace_delegators(target, resolved_path, record,
                seen_targets=seen_targets )
            return;

        mimickey = record['$mimic$key']
        mimicroot = record['$mimic$root']
        mimicpath = record['$mimic$path']

        if mimickey == '$contest':
            if path_prefixed(mimicpath, {'problems', 'solutions', 'complete'}):
                yield target
            else:
                for leaguekey in record['$contest']['leagues']:
                    if leaguekey not in record:
                        raise ValueError(mimicroot/leaguekey)
                    yield from self.trace_delegators(
                        mimicroot/leaguekey/mimicpath,
                        seen_targets=seen_targets )
        elif mimickey == '$contest$league':
            yield target
        elif mimickey == '$regatta':
            if path_prefixed(mimicpath, {'problems', 'solutions', 'complete'}):
                yield target
            else:
                for leaguekey in record['$regatta']['leagues']:
                    if leaguekey not in record:
                        raise ValueError(mimicroot/leaguekey)
                    yield from self.trace_delegators(
                        mimicroot/leaguekey/mimicpath,
                        seen_targets=seen_targets )
        elif mimickey == '$regatta$league':
            if path_prefixed(mimicpath, {'problems', 'solutions', 'complete'}):
                yield target
            else:
                for subjectkey in record['$regatta$league']['subjects']:
                    if subjectkey not in record:
                        raise ValueError(mimicroot/subjectkey)
                    yield from self.trace_delegators(
                        mimicroot/subjectkey/mimicpath,
                        seen_targets=seen_targets )
        elif mimickey == '$regatta$subject':
            yield target
        elif mimickey == '$regatta$round':
            if mimicpath == PurePath(''):
                yield from self.trace_delegators(
                    mimicroot/'problems',
                    seen_targets=seen_targets )
            else:
                yield target
        else:
            raise AssertionError(mimickey, target)

    # Extension
    def produce_rigid_protorecord(self, target, record,
        *, inpath_set, date_set
    ):
        kwargs = dict(inpath_set=inpath_set, date_set=date_set)
        if record is None or '$mimic$key' not in record:
            return super().produce_rigid_protorecord(target, record, **kwargs)

        mimickey = record['$mimic$key']
        subroot = kwargs['subroot'] = record['$mimic$root']
        subtarget = kwargs['subtarget'] = record['$mimic$path']

        if mimickey == '$contest':
            raise RecordNotFoundError(target);
        elif mimickey == '$contest$league':
            if subtarget == PurePath(''):
                return self.produce_rigid_contest_league_protorecord(
                    target, record, rigid=record['$rigid'],
                    contest=self.find_contest(record),
                    league=self.find_contest_league(record),
                    **kwargs );
            raise RecordNotFoundError(target);
        elif mimickey == '$regatta':
            raise RecordNotFoundError(target);
        elif mimickey == '$regatta$league':
            raise RecordNotFoundError(target);
        elif mimickey == '$regatta$subject':
            if subtarget == PurePath(''):
                return self.produce_rigid_regatta_subject_protorecord(
                    target, record,
                    regatta=self.find_regatta(record),
                    league=self.find_regatta_league(record),
                    subject=self.find_regatta_subject(record),
                    **kwargs );
            raise RecordNotFoundError(target);
        elif mimickey == '$regatta$round':
            raise RecordNotFoundError(target);
        else:
            raise AssertionError(mimickey, target)

    # Extension
    def produce_fluid_protorecord(self, target, record,
        *, inpath_set, date_set
    ):
        kwargs = dict(inpath_set=inpath_set, date_set=date_set)
        if record is None or '$mimic$key' not in record:
            return super().produce_fluid_protorecord(target, record, **kwargs)

        mimickey = record['$mimic$key']
        subroot = kwargs['subroot'] = record['$mimic$root']
        subtarget = kwargs['subtarget'] = record['$mimic$path']

        if mimickey == '$contest':
            # contest/{problems,solutions,complete,jury}
            if path_prefixed(subtarget, self.contest_fluid_targets):
                return self.produce_fluid_contest_protorecord(target, record,
                    contest=self.find_contest(record), **kwargs )
            raise RecordNotFoundError(target)
        elif mimickey == '$contest$league':
            # contest/league/{problems,solutions,complete,jury}
            if path_prefixed(subtarget, self.contest_league_fluid_targets):
                return self.produce_fluid_contest_league_protorecord(
                    target, record,
                    contest=self.find_contest(record),
                    league=self.find_contest_league(record), **kwargs )
            # contest/league/<problem number>
            elif str(subtarget).isnumeric():
                return self.produce_fluid_contest_problem_protorecord(
                    target, record,
                    contest=self.find_contest(record),
                    league=self.find_contest_league(record),
                    problem=int(str(subtarget)), **kwargs )
            raise RecordNotFoundError(target)
        elif mimickey == '$regatta':
            # regatta/{problems,solutions,complete,jury}
            if path_prefixed(subtarget, self.regatta_fluid_targets):
                return self.produce_fluid_regatta_protorecord(target, record,
                    regatta=self.find_regatta(record), **kwargs )
            raise RecordNotFoundError(target)
        elif mimickey == '$regatta$league':
            # regatta/league/{problems,solutions,complete,jury}
            if path_prefixed(subtarget, self.regatta_league_fluid_targets):
                return self.produce_fluid_regatta_league_protorecord(
                    target, record,
                    regatta=self.find_regatta(record),
                    league=self.find_regatta_league(record), **kwargs )
            raise RecordNotFoundError(target)
        elif mimickey == '$regatta$subject':
            # regatta/league/subject/{problems,solutions,complete,jury}
            if path_prefixed(subtarget, self.regatta_subject_fluid_targets):
                return self.produce_fluid_regatta_subject_protorecord(
                    target, record,
                    regatta=self.find_regatta(record),
                    league=self.find_regatta_league(record),
                    subject=self.find_regatta_subject(record), **kwargs )
            # regatta/league/subject/<round number>
            elif str(subtarget).isnumeric():
                return self.produce_fluid_regatta_problem_protorecord(
                    target, record,
                    regatta=self.find_regatta(record),
                    league=self.find_regatta_league(record),
                    subject=self.find_regatta_subject(record),
                    roundnum=int(str(subtarget)), **kwargs )
            raise RecordNotFoundError(target)
        elif mimickey == '$regatta$round':
            # regatta/league/round/{problems,solutions,complete,jury}
            if path_prefixed(subtarget, self.regatta_round_fluid_targets):
                return self.produce_fluid_regatta_round_protorecord(
                    target, record,
                    regatta=self.find_regatta(record),
                    league=self.find_regatta_league(record),
                    round=self.find_regatta_round(record), **kwargs )
            raise RecordNotFoundError(target)

    def produce_rigid_contest_league_protorecord(self,
        target, record,
        subroot, subtarget, rigid,
        contest, league,
        *, inpath_set, date_set
    ):
        assert subtarget == PurePath('')
        body = []; append = body.append
        contest_record = self.outrecords[subroot.parent()]
        for page in rigid:
            append(self.substitute_clearpage())
            if not page: # empty page
                append(self.substitute_phantom())
                continue;
            for item in page:
                if isinstance(item, dict):
                    append(self.constitute_special(item))
                    continue;
                if item != '.':
                    raise ValueError(item, target)

                append(self.substitute_jeolmheader())
                append(self.constitute_section(
                    self.find_name(contest, record.get('$lang')) ))
                append(self.substitute_begin_problems())
                for i in range(1, 1 + league['problems']):
                    inpath = subroot/(str(i)+'.tex')
                    if inpath not in self.inrecords:
                        raise RecordNotFoundError(inpath, target)
                    inpath_set.add(inpath)
                    append({ 'inpath' : inpath,
                        'select' : 'problems', 'number' : str(i) })
                append(self.substitute_end_problems())
                append(self.substitute_postword())
        protorecord = {'body' : body}
        protorecord.update(contest_record.get('$rigid$opt', ()))
        protorecord.update(record.get('$rigid$opt', ()))
        protorecord['preamble'] = preamble = list(
            protorecord.get('preamble', ()) )
        preamble.append({
            'league' : self.find_name(league, record.get('$lang')) })
        return protorecord

    def produce_rigid_regatta_subject_protorecord(self,
        target, record,
        subroot, subtarget,
        regatta, league, subject,
        *, inpath_set, date_set
    ):
        assert subtarget == PurePath('')
        body = []; append = body.append
        league_record = self.outrecords[subroot.parent()]
        regatta_record = self.outrecords[subroot.parent(2)]
        roundrecords = self.find_regatta_round_records(league_record)
        for roundnum, roundrecord in enumerate(roundrecords, 1):
            round = roundrecord['$regatta$round']
            append(self.substitute_clearpage())
            append(self.substitute_jeolmheader_nospace())
            append(self.substitute_rigid_regatta_caption(
                caption=self.find_name(regatta, record.get('$lang')),
                mark=round['mark'] ))
            inpath = subroot/(str(roundnum)+'.tex')
            if inpath not in self.inrecords:
                raise RecordNotFoundError(inpath, target)
            inpath_set.add(inpath)
            append(self.substitute_begin_problems())
            append({ 'inpath' : inpath,
                'select' : 'problems',
                'number' : self.substitute_regatta_number(
                    subject_index=subject['index'],
                    round_index=round['index'] )
            })
            append(self.substitute_end_problems())
            append(self.substitute_hrule())
        protorecord = {'body' : body}
        protorecord.update(regatta_record.get('$rigid$opt', ()))
        protorecord.update(league_record.get('$rigid$opt', ()))
        protorecord.update(record.get('$rigid$opt', ()))
        preamble = protorecord.setdefault('preamble', [])
        preamble.append({
            'league' : self.find_name(league, record.get('$lang')) })
        return protorecord

    def produce_fluid_contest_protorecord(self,
        target, record,
        subroot, subtarget, contest,
        *, inpath_set, date_set
    ):
        body = []
        select, target_options = self.split_subtarget(subtarget)
        if 'contained' in target_options:
            body.append(self.constitute_section(
                self.find_name(contest, record.get('$lang')) ))
            target_options.discard('contained')
        else:
            body.append(self.constitute_section(
                self.find_name(contest, record.get('$lang')),
                select=select ))
        league_records = self.find_contest_league_records(record)
        subtarget = PurePath(select, *target_options)
        for leaguekey, leaguerecord in league_records.items():
            subprotorecord = self.produce_fluid_contest_league_protorecord(
                subroot/leaguekey/subtarget, leaguerecord,
                subroot/leaguekey, subtarget,
                contest, leaguerecord['$contest$league'],
                contained=1,
                inpath_set=inpath_set, date_set=date_set
            )
            body.extend(subprotorecord['body'])

        protorecord = {'body' : body}
        return protorecord

    def produce_fluid_contest_league_protorecord(self,
        target, record,
        subroot, subtarget,
        contest, league,
        *, contained=False, inpath_set, date_set
    ):
        body = []; append = body.append
        select, target_options = self.split_subtarget(subtarget)
        if contained or 'contained' in target_options:
            append(self.constitute_section(
                self.find_name(league, record.get('$lang')),
                level=contained ))
            target_options.discard('contained')
        else:
            append(self.constitute_section(
                '{}. {}'.format(
                    self.find_name(contest, record.get('$lang')),
                    self.find_name(league, record.get('$lang')) ),
                select=select ))
        append(self.substitute_begin_problems())
        for i in range(1, 1 + league['problems']):
            inpath = subroot/(str(i)+'.tex')
            if inpath not in self.inrecords:
                raise RecordNotFoundError(inpath, subroot)
            inpath_set.add(inpath)
            append({ 'inpath' : inpath,
                'select' : select, 'number' : str(i) })
        append(self.substitute_end_problems())

        if target_options:
            raise ValueError(target_options)
        protorecord = {'body' : body}
        return protorecord

    def produce_fluid_contest_problem_protorecord(self,
        target, record,
        subroot, subtarget,
        contest, league, problem,
        *, inpath_set, date_set
    ):
        body = []; append = body.append
        if not 1 <= problem <= league['problems']:
            return super().produce_fluid_protorecord(target, record,
                inpath_set=inpath_set, date_set=date_set )
        inpath = subroot/(str(problem)+'.tex')
        if inpath not in self.inrecords:
            raise RecordNotFoundError(inpath, subroot)
        inpath_set.add(inpath)
        append(self.substitute_begin_problems())
        append({ 'inpath' : inpath,
            'select' : 'complete', 'number' : str(problem) })
        append(self.substitute_end_problems())
        protorecord = {'body' : body}
        return protorecord

    def produce_fluid_regatta_protorecord(self,
        target, record,
        subroot, subtarget, regatta,
        *, inpath_set, date_set
    ):
        body = []
        select, target_options = self.split_subtarget(subtarget)
        if 'contained' in target_options:
            body.append(self.constitute_section(
                self.find_name(regatta, record.get('$lang')) ))
            target_options.discard('contained')
        else:
            body.append(self.constitute_section(
                self.find_name(regatta, record.get('$lang')),
                select=select ))
        league_records = self.find_regatta_league_records(record)
        subtarget = PurePath(select, *target_options)
        for leaguekey, leaguerecord in league_records.items():
            subprotorecord = self.produce_fluid_regatta_league_protorecord(
                subroot/leaguekey/subtarget, leaguerecord,
                subroot/leaguekey, subtarget,
                regatta, leaguerecord['$regatta$league'],
                contained=1,
                inpath_set=inpath_set, date_set=date_set
            )
            body.extend(subprotorecord['body'])

        protorecord = {'body' : body}
        return protorecord

    def produce_fluid_regatta_league_protorecord(self,
        target, record,
        subroot, subtarget,
        regatta, league,
        *, contained=False, inpath_set, date_set
    ):
        body = []; append = body.append
        select, target_options = self.split_subtarget(subtarget)
        if contained or 'contained' in target_options:
            append(self.constitute_section(
                self.find_name(league, record.get('$lang')),
                level=contained ))
            target_options.discard('contained')
        else:
            append(self.constitute_section(
                '{}. {}'.format(
                    self.find_name(regatta, record.get('$lang')),
                    self.find_name(league, record.get('$lang')) ),
                select=select ))

        if select in {'jury'}:
            group_by = 'subject'
        else:
            group_by = 'round'
        if 'by-subject' in target_options:
            group_by = 'subject'
            target_options.discard('by-subject')
        elif 'by-round' in target_options:
            group_by = 'round'
            target_options.discard('by-round')

        subtarget = PurePath(select, *target_options)
        if group_by == 'round':
            round_records = self.find_regatta_round_records(record)
            for roundnum, roundrecord in enumerate(round_records, 1):
                subprotorecord = self.produce_fluid_regatta_round_protorecord(
                    subroot/str(roundnum)/subtarget, roundrecord,
                    subroot/str(roundnum), subtarget,
                    regatta, league, roundrecord['$regatta$round'],
                    contained=contained+1,
                    inpath_set=inpath_set, date_set=date_set
                )
                body.extend(subprotorecord['body'])
        elif group_by == 'subject':
            subject_records = self.find_regatta_subject_records(record)
            for subjectkey, subjectrecord in subject_records.items():
                subprotorecord = \
                self.produce_fluid_regatta_subject_protorecord(
                    subroot/subjectkey/subtarget, subjectrecord,
                    subroot/subjectkey, subtarget,
                    regatta, league, subjectrecord['$regatta$subject'],
                    contained=contained+1,
                    inpath_set=inpath_set, date_set=date_set
                )
                body.extend(subprotorecord['body'])

        protorecord = {'body' : body}
        return protorecord

    def produce_fluid_regatta_subject_protorecord(self,
        target, record,
        subroot, subtarget,
        regatta, league, subject,
        *, contained=False, inpath_set, date_set
    ):
        body = []; append = body.append
        select, target_options = self.split_subtarget(subtarget)
        if contained or 'contained' in target_options:
            append(self.constitute_section(
            self.find_name(subject, record.get('$lang')),
            level=contained ))
            target_options.discard('contained')
        else:
            append(self.constitute_section(
                '{}. {}. {}'.format(
                    self.find_name(regatta, record.get('$lang')),
                    self.find_name(league, record.get('$lang')),
                    self.find_name(subject, record.get('$lang')) ),
                select=select ))
        round_records = self.find_regatta_round_records(record)
        append(self.substitute_begin_problems())
        for roundnum, roundrecord in enumerate(round_records, 1):
            inpath = subroot/(str(roundnum)+'.tex')
            if inpath not in self.inrecords:
                raise RecordNotFoundError(inpath, subroot)
            inpath_set.add(inpath)
            append({ 'inpath' : inpath,
                'select' : select,
                'number' : self.substitute_regatta_number(
                    subject_index=subject['index'],
                    round_index=roundrecord['$regatta$round']['index'] )
            })
        append(self.substitute_end_problems())

        if target_options:
            raise ValueError(target_options)
        protorecord = {'body' : body}
        return protorecord

    def produce_fluid_regatta_round_protorecord(self,
        target, record,
        subroot, subtarget,
        regatta, league, round,
        *, contained=False, inpath_set, date_set
    ):
        body = []; append = body.append
        select, target_options = self.split_subtarget(subtarget)
        if contained or 'contained' in target_options:
            append(self.constitute_section(
            self.find_name(round, record.get('$lang')),
            level=contained ))
            target_options.discard('contained')
        else:
            append(self.constitute_section(
                '{}. {}. {}'.format(
                    self.find_name(regatta, record.get('$lang')),
                    self.find_name(league, record.get('$lang')),
                    self.find_name(round, record.get('$lang')) ),
                select=select ))
        subject_records = self.find_regatta_subject_records(record)
        leagueroot = subroot.parent()
        roundnum = int(subroot.name)
        append(self.substitute_begin_problems())
        for subjectkey, subjectrecord in subject_records.items():
            inpath = leagueroot/subjectkey/(str(roundnum)+'.tex')
            if inpath not in self.inrecords:
                raise RecordNotFoundError(inpath, subroot)
            inpath_set.add(inpath)
            append({ 'inpath' : inpath,
                'select' : select,
                'number' : self.substitute_regatta_number(
                    subject_index=subjectrecord['$regatta$subject']['index'],
                    round_index=round['index'] )
            })
        append(self.substitute_end_problems())

        if target_options:
            raise ValueError(target_options)
        protorecord = {'body' : body}
        return protorecord

    def produce_fluid_regatta_problem_protorecord(self,
        target, record,
        subroot, subtarget,
        regatta, league, subject, roundnum,
        *, inpath_set, date_set
    ):
        body = []; append = body.append
        if not 1 <= roundnum <= league['rounds']:
            return super().produce_fluid_protorecord(target, record,
                inpath_set=inpath_set, date_set=date_set )
        roundrecord = self.find_regatta_round_records(record)[roundnum-1]
        round = roundrecord['$regatta$round']
        inpath = subroot/(str(roundnum)+'.tex')
        if inpath not in self.inrecords:
            raise RecordNotFoundError(inpath, subroot)
        inpath_set.add(inpath)
        append(self.substitute_begin_problems())
        append({ 'inpath' : inpath,
            'select' : 'complete',
            'number' : self.substitute_regatta_number(
                subject_index=subject['index'],
                round_index=round['index'] )
        })
        append(self.substitute_end_problems())
        protorecord = {'body' : body}
        return protorecord

    def find_contest(self, record):
        mimickey = record['$mimic$key']
        if mimickey == '$contest':
            return record['$contest']
        elif mimickey == '$contest$league':
            league = record['$contest$league']
            return self.find_contest(self.outrecords[
                record['$mimic$root'].parent() ])
        else:
            raise AssertionError(mimickey, record)

    def find_contest_league(self, record):
        mimickey = record['$mimic$key']
        if mimickey == '$contest$league':
            return record['$contest$league']
        else:
            raise AssertionError(mimickey, record)

    def find_contest_league_records(self, record):
        mimickey = record['$mimic$key']
        if mimickey == '$contest':
            return ODict(
                (leaguekey, self.outrecords[record['$mimic$root']/leaguekey])
                for leaguekey in record['$contest']['leagues'] )
        else:
            raise AssertionError(mimickey, record)

    def find_regatta(self, record):
        mimickey = record['$mimic$key']
        if mimickey == '$regatta':
            return record['$regatta']
        elif mimickey == '$regatta$league':
            league = record['$regatta$league']
            return self.find_regatta(self.outrecords[
                record['$mimic$root'].parent() ])
        elif mimickey == '$regatta$subject':
            subject = record['$regatta$subject']
            return self.find_regatta(self.outrecords[
                record['$mimic$root'].parent(2) ])
        elif mimickey == '$regatta$round':
            round = record['$regatta$round']
            return self.find_regatta(self.outrecords[
                record['$mimic$root'].parent(2) ])
        else:
            raise AssertionError(mimickey, record)

    def find_regatta_league(self, record):
        mimickey = record['$mimic$key']
        if mimickey == '$regatta$league':
            return record['$regatta$league']
        elif mimickey == '$regatta$subject':
            subject = record['$regatta$subject']
            return self.find_regatta_league(self.outrecords[
                record['$mimic$root'].parent() ])
        elif mimickey == '$regatta$round':
            round = record['$regatta$round']
            return self.find_regatta_league(self.outrecords[
                record['$mimic$root'].parent() ])
        else:
            raise AssertionError(mimickey, record)

    def find_regatta_league_records(self, record):
        mimickey = record['$mimic$key']
        if mimickey == '$regatta':
            return ODict(
                (leaguekey, self.outrecords[record['$mimic$root']/leaguekey])
                for leaguekey in record['$regatta']['leagues'] )
        else:
            raise AssertionError(mimickey, record)

    def find_regatta_subject(self, record):
        mimickey = record['$mimic$key']
        if mimickey == '$regatta$subject':
            return record['$regatta$subject']
        else:
            raise AssertionError(mimickey, record)

    def find_regatta_subject_records(self, record):
        mimickey = record['$mimic$key']
        if mimickey == '$regatta$league':
            return ODict(
                (subjectkey, self.outrecords[record['$mimic$root']/subjectkey])
                for subjectkey in record['$regatta$league']['subjects'] )
        elif mimickey == '$regatta$round':
            return self.find_regatta_subject_records(self.outrecords[
                record['$mimic$root'].parent() ])
        else:
            raise AssertionError(mimickey, record)

    def find_regatta_round(self, record):
        mimickey = record['$mimic$key']
        if mimickey == '$regatta$round':
            return record['$regatta$round']
        else:
            raise AssertionError(mimickey, record)

    def find_regatta_round_records(self, record):
        assert '$mimic$key' in record, record
        mimickey = record['$mimic$key']
        if mimickey == '$regatta$league':
            return [
                self.outrecords[record['$mimic$root']/str(roundnum)]
                for roundnum
                in range(1, 1 + record['$regatta$league']['rounds'])
            ]
        elif mimickey == '$regatta$subject':
            return self.find_regatta_round_records(self.outrecords[
                record['$mimic$root'].parent() ])
        else:
            raise AssertionError(mimickey, record)

    def find_name(self, entity, lang):
        name = entity['name']
        if isinstance(name, str):
            return name
        elif isinstance(name, dict):
            (key, value), = name.items()
            if key != 'translate':
                raise ValueError(name)
            return self.translations[value][lang]
        else:
            raise TypeError(name)

    ##########
    # Record accessors

    # Extension
    class OutrecordAccessor(OriginalDriver.OutrecordAccessor):
        mimic_keys = frozenset((
            '$contest', '$contest$league',
            '$regatta', '$regatta$league',
            '$regatta$subject', '$regatta$round', ))

        # Extension
        def get_child(self, parent_path, parent_record, name, **kwargs):
            path, record = super().get_child(
                parent_path, parent_record, name, **kwargs )
            mimic_keys = self.mimic_keys & record.keys()
            if mimic_keys:
                mimic_key, = mimic_keys
                record = record.copy()
                record.update({
                    '$mimic$key' : mimic_key,
                    '$mimic$root' : path,
                    '$mimic$path' : PurePath() })
                return path, record;
            if not record.get('$fake') or '$mimic$key' not in parent_record:
                return path, record

            mimic_key = parent_record['$mimic$key']
            record.update({
                mimic_key : parent_record[mimic_key],
                '$mimic$key' : mimic_key,
                '$mimic$root' : parent_record['$mimic$root'],
                '$mimic$path' : parent_record['$mimic$path']/name,
            })
            return path, record;

        @classmethod
        def derive_attributes(cls, parent_record, record, path):
            if '$lang' not in record:
                record['$lang'] = parent_record.get('$lang')
            super().derive_attributes(parent_record, record, path)

        def list_mimic_targets(self, outpath=PurePath(), outrecord=None):
            if outrecord is None:
                outrecord = self.records
            else:
                mimic_keys = self.mimic_keys & outrecord.keys()
                if mimic_keys:
                    mimic_key, = mimic_keys
                    yield outpath, mimic_key
            for subname, subrecord in outrecord.items():
                if '$' in subname:
                    continue;
                yield from self.list_mimic_targets(outpath/subname, subrecord)

#    mimic_keys = OutrecordAccessor.mimic_keys

    ##########
    # LaTeX-level functions

    # Extension
    def constitute_input(self, inpath, alias, inrecord, figname_map, *,
        select=None, number=None
    ):
        if select is None:
            return super().constitute_input(
                inpath, alias, inrecord, figname_map );

        assert number is not None, (inpath, number)
        numeration = self.substitute_rigid_numeration(number=number)

        if select in {'problems'}:
            body = self.substitute_input_problem(
                filename=alias, numeration=numeration )
        elif select in {'solutions'}:
            body = self.substitute_input_solution(
                filename=alias, numeration=numeration )
        elif select in {'complete', 'jury'}:
            body = self.substitute_input_both(
                filename=alias, numeration=numeration )
        else:
            raise AssertionError(inpath, select)

        if figname_map:
            body = self.constitute_figname_map(figname_map) + '\n' + body
        return body

    rigid_numeration_template = r'\itemy{$number}'

    input_template = r'\input{$filename}'
    input_problem_template = r'\probleminput{$numeration}{$filename}'
    input_solution_template = r'\solutioninput{$numeration}{$filename}'
    input_both_template = r'\problemsolutioninput{$numeration}{$filename}'

    @classmethod
    def constitute_section(cls, caption, *, level=0, select='problems'):
        if level == 0:
            substitute_section = cls.substitute_section
        elif level == 1:
            substitute_section = cls.substitute_subsection
        elif level == 2:
            substitute_section = cls.substitute_subsubsection
        else:
            raise AssertionError(level)
        caption += cls.caption_select_appendage[select]
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
    def constitute_preamble_line(cls, metaline):
        if 'league' in metaline:
            return cls.substitute_leaguedef(league=metaline['league'])
#        elif 'postword' in metaline:
#            return cls.substitute_postworddef(postword=metaline['postword'])
        else:
            return super().constitute_preamble_line(metaline)

    leaguedef_template = r'\def\jeolmheaderleague{$league}'
#    postworddef_template = r'\def\postword{\jeolmpostword$postword}'

    begin_problems_template = r'\begin{problems}'
    end_problems_template = r'\end{problems}'
    postword_template = r'\postword'

    jeolmheader_nospace_template = r'\jeolmheader*'
    rigid_regatta_caption_template = r'\regattacaption{$caption}{$mark}'
    hrule_template = r'\medskip\hrule'

    regatta_number_template = r'$round_index$subject_index'

    ##########
    # Supplementary finctions

    @staticmethod
    def split_subtarget(subtarget):
        select, *target_options_list = subtarget.parts
        target_options = set(target_options_list)
        if len(target_options) != len(target_options_list):
            raise ValueError
        assert select in {'problems', 'solutions', 'complete', 'jury'}
        return select, target_options

def path_prefixed(path, other, recursed=False):
    if not isinstance(other, (str, PurePath)):
        assert not recursed
        return any(path_prefixed(path, o, recursed=True) for o in other)
    parts = list(path.parts)
    other_parts = list(PurePath(other).parts)

    for part, other_part in zip_longest(parts, other_parts):
        if other_part is None:
            return True
        if part != other_part:
            return False
    return True


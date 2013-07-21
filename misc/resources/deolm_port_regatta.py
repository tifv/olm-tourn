from pathlib import Path

def iterfiles():
    import sys
    for arg in sys.argv[1:]:
        path = Path(arg)
        if path.match('**/*.tex'):
            yield path
        else:
            yield from Path(arg).glob('**/*.tex')

for path in iterfiles():
    sourcedir, regatta, league, subject, problem = path.parts
    assert sourcedir == 'source'
    assert problem.endswith('.tex')
    problem = int(problem[:-4])
    problempath, solutionpath = (
        Path(
            'misc/deolm/latex',
            '{regatta}-{league}-{subject}-{problem}-{select}.in.tex'.format(
                regatta=regatta, league=league, subject=subject,
                problem=problem, select=select ),
        ) for select in ('task', 'solution') )
    with path.open('w') as f:
        print(str(path), '<', str(problempath), str(solutionpath))
        with problempath.open('r') as g:
            f.write(g.read())
        f.write(r'\solution' '\n')
        with solutionpath.open('r') as h:
            f.write(h.read())


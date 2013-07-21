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
    sourcedir, contest, league, problem = path.parts
    assert sourcedir == 'source'
    assert problem.endswith('.tex')
    problem = int(problem[:-4])
    with path.open('w') as f:
        problempath, solutionpath = (
            Path(
                'misc/deolm/latex',
                '{contest}-{league}-{problem}-{select}.in.tex'.format(
                    contest=contest, league=league, problem=problem,
                    select=select ),
            ) for select in ('task', 'solution') )
        print(str(path), '<', str(problempath), str(solutionpath))
        with problempath.open('r') as g:
            f.write(g.read())
        f.write(r'\solution' '\n')
        with solutionpath.open('r') as h:
            f.write(h.read())


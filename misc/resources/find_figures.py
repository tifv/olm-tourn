from pathlib import Path, PurePath

for path in Path('source').glob('**/*.asy'):
    linkpath = Path('misc/figures', path.parts[1:].as_posix().replace('/', '-'))
    if not linkpath.exists():
        linkpath.symlink_to(PurePath('../..', path))

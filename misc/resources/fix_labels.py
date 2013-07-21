"""
Run

$ python3.3 fixlabels.py whenever/whatever.tex

to replace
\label{asdf:qwerty:LABEL}
with
\label{asdf:qwerty:whenever/whatever}
"""

import re

import pathlib

label_pattern = re.compile(
    r'\\(?P<command>label|ref){(?P<labelspace>.*?):'
    r'LABEL'
    r'}'
)

def fix_labels(path):
    with path.open('r') as f:
        s = f.read()
    label, dot, ext = path.as_posix().rpartition('.')
    if dot != '.' or ext != 'tex':
        raise ValueError(path)

    print(label)

    def repl(match):
#        command, labelspace = match.group('command', 'labelspace')
        return r'\{command}{{{labelspace}:{label}}}'.format(
            label=label, **match.groupdict() )

    s = label_pattern.sub(repl, s)
    with path.open('w') as f:
        f.write(s)

if __name__ == '__main__':
    import sys
    for filename in sys.argv[1:]:
        fix_labels(pathlib.Path(filename))


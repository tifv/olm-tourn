import re

def find_next_split(s, prev_split):
    endproblem = s.find(r'\endproblem', prev_split)
    if endproblem == -1:
        return len(s)
    par = s.find('\n\n', endproblem)
    if par == -1:
        return len(s)
    return par

def main(filename):
    with open(filename, 'r') as f:
        s = f.read()
    prev_split = 0
    index = 0
    while prev_split < len(s):
        next_split = find_next_split(s, prev_split)
        with open("{:02}".format(index), 'x') as g:
            g.write(s[prev_split:next_split])
        index += 1
        prev_split = next_split
    print(index)

if __name__ == '__main__':
    import sys
    filename = sys.argv[1]
    main(filename)


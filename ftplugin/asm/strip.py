import sys
import re
import subprocess

fpath = sys.argv[1]
#fpath = r'D:\Source\C++\t.s'
for line in open(fpath):
    oline = line[:-1]
    line = line.strip()
    if line.startswith('.cfi'):
        continue
    #parts = line.split()
    m = re.search(r'.*(\W|[~_]|^)(?P<funcname>__(\w|_)+).*', line)
    if m:
        funcname = m.group('funcname')
        funcname = subprocess.check_output(['c++filt', funcname]).strip()
        funcname = '  # ' + funcname
        if len(oline) + len(funcname) > 80:
            funcname = '\n' + funcname
        print oline + funcname
    else:
        print oline
    #if parts:
    #    if parts[0] == 'call':
    #        funcname = parts[1]
    #    elif parts[0].endswith(':'):
    #        funcname = parts[0][:-1]
    #    else:
    #        funcname = None
    #    if funcname is not None:
    #        funcname = subprocess.check_output(['c++filt', funcname]).strip()
    #        funcname = '  # ' + funcname
    #        if len(oline) + len(funcname) > 80:
    #            funcname = '\n' + funcname
    #        print oline + funcname

set tabstop=4
set shiftwidth=4
set expandtab

let s:py2exepath = 'D:/Programming/Lang/Python2.7.8/python.exe'
let s:py3exepath = 'D:/Programming/Lang/Python3.4.1/python.exe'

python mapRun('write', '!python %')
python defineCommand('2', 'python switchTo2()')
python defineCommand('3', 'python switchTo3()')

python mapPairChar('()')
python mapPairChar('[]')

imap <m-h> _
imap <m-j> =
imap <m-k> (
imap <m-l> )

inoremap ;$ <esc>A
inoremap ;j <esc>o

inoremap se; self
inoremap sf; self.
inoremap re; return

" define class
inoremap ;ds <esc>:python defineClass()<cr>
" TODO
" define function (or method)

python << endpython
import vim
import re

#class Line(object):
#
#    def __init__(self, line):
#        self.line = line
#    
#    @cached
#    @property
#    def indentLevel():
#        if not has

def switchTo3():
    mapRun('write', '!{} %'.format(var('s:py2exepath')))

def switchTo2():
    mapRun('write', '!{} %'.format(var('s:py3exepath')))

def isInClass():
    indentationLevel(line)

def defineFunction():
    if isInClass():
        pass
    else:
        pass

def defineClass():
    line = curline()
    xs = line.split()
    if len(xs) == 2:
        className, parentName = xs
    else:
        className, parentName = xs[0], 'object'
    indent = re.match('^(\s*).*', line).group(1)
    line = '{}class {}({}):'.format(indent, className, parentName)
    curline(line)
    emulate('A\<cr>\<cr>')

endpython

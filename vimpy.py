import datetime

import vim
from win32api import GetMonitorInfo, MonitorFromWindow
from win32con import MONITOR_DEFAULTTOPRIMARY

from vimimport import vimimport

__all__ = ['command',
           'gui',
           ]

# TODO: design the command related api
class Command:

    def __init__(self, seq, name):
        self.seq = seq
        self.name = name

    def set(self, *cmds):
        self.cmds = cmds
        # nnoremap ;r :write \| !python %<cr>
        command('nnoremap {} :{}<cr>'.format(self.seq, '\\|'.join(cmds)))
 
class CommandManager:
    """
    command('set list')
    """

    def __init__(self):
        self.commands = {}

    def __call__(self, cmd):
        vim.command(cmd)

    def add(self, seq, name=None):
        self.commands[name] = Command(seq, name)

    def __getitem__(self, name):
        return self.commands[name]

command = CommandManager()

class Gui(object):

    def __init__(self):
        self.maximized = False

    def maximize(self):
        command('simalt ~x')
        self.maximized = True

    def restore(self):
        command('simalt ~r')
        self.maximized = False

    def toggleMaximized(self):
        if self.maximized:
            self.restore()
        else:
            self.maximize()

    def put(self, where):
        """
        where == combination of 'left', 'right', 'top', 'bottom'
        e.g. 'top left'
        NOTE:
            currently the where argument is not used,
            always put to bottom right
        """
        monitor = MonitorFromWindow(0, MONITOR_DEFAULTTOPRIMARY)
        rcWork = GetMonitorInfo(monitor)['Work']
        right, bottom = rcWork[2:]
        right -= 646
        bottom -= 424
        command('winpos {} {}'.format(right, bottom))

gui = Gui()

# utils ############################################################
# TODO: rewrite using new api
# TODO: new line (above) based on line content
def insertDatetime():
    dt = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    col = vim.current.window.cursor[1]
    line = vim.current.line
    vim.current.line = line[:col + 1] + dt + line[col + 1:]

#vim api ###########################################################
#def getline(row=None):
#    if not row:
#        row = currow()
#    return vim.current.buffer[row-1]
#
#def cursor(row=None, col=None, save=False):
#    if row or col:
#        if save:
#            saveCursor()
#        vim.current.window.cursor = (row or currow(), col or curcol())
#    return vim.current.window.cursor
#
#def currow(row=None):
#    if row:
#        cursor(row=row)
#    return cursor()[0]
#
#def curcol(col=None):
#    if col:
#        cursor(col=col)
#    return cursor()[1]
#
#def curline(line=None):
#    if line:
#        vim.current.line = line
#    return vim.current.line
#
#def curchar():
#    return curline()[curcol()]
#
#def nextchar():
#    try:
#        return curline()[curcol() + 1]
#    except IndexError:
#        return None
#
#def var(name, value=None):
#    if value is not None:
#        command('let {} = {}'.format(name, value))
#    return vim.eval(name)
#
#def register(name):
#    return vim.eval('@{}'.format(name))
#
#def normal(seq):
#    command('normal {}'.format(seq))
#
#def emulate(keys):
#    vim.eval('feedkeys("{}", "n")'.format(keys.replace('"', '\\"')))

#utils #########################################################
#def mapRun(*cmds):
#    if len(cmds) == 1:
#        cmd = cmds[0]
#    else:
#        cmd = joinCommands(*cmds)
#    mapcmd = 'nnoremap {} :{}'.format(var('hotkey_run'), cmd)
#    vim.command(mapcmd)
#
#def mapChar(char, func, *ars, **kws):
#    call = makeCallString(func, *ars, **kws)
#    command('inoremap {} <esc>:python {}<cr>'.format(char, call))
#
#def mapPairChar(charPair):
#    left, right = charPair
#    mapChar(left, util.insertPairCharLeft, left, right)
#    mapChar(right, util.insertPairCharRight, right, left)
#
#def defineCommand(name, cmd):
#    command('command! Uf6{} {}'.format(name, cmd))
#
#def do(func, *ars, **kws):
#    return lambda: func(*ars, **kws)
#
#def joinCommands(*cmds):
#    return '\\|'.join(cmds) + '<cr>'
#
#def makeCallString(func, *ars, **kws):
#    ars = [repr(ar) for ar in ars]
#    kws = ['{}={}'.format(repr(k), repr(v)) for k, v in kws.items()]
#    return '{}({})'.format(func.__name__, ', '.join(ars + kws))
#
#def executeUserCommand(name, *args):
#    name = 'Uf6' + name
#    vim.command('{} {}'.format(name, ' '.join(args)))
#
#def stringPositionsInLine(line):
#    inquote = False
#    i = beg = end = 0
#    while i < len(line):
#        ch = line[i]
#        if ch == '\\':
#            i += 1
#        elif not inquote and ch in '\'"':
#            inquote = True
#            beg = i
#            quote = ch
#        elif inquote and ch == quote:
#            inquote = False
#            end = i
#            yield beg, end
#        i += 1
#
#def isInString(row=None, col=None):
#    if not row:
#        row, col = cursor()
#    for beg, end in stringPositionsInLine(getline(row)):
#        if col < beg:
#            return False
#        elif beg <= col < end:
#            return True
#    return False
#
#def insertPairCharLeft(left=None, right=None):
#    if isInString():
#        emulate('a{}'.format(left))
#    else:
#        if curline():
#            modeKey = 'a'
#        else:
#            modeKey = 'cc'
#        emulate('{}{}{}\<esc>i'.format(modeKey, left, right))
#
#def insertPairCharRight(right=None, left=None):
#    if isInString():
#        emulate('a{}'.format(right))
#    else:
#        if nextchar() == right:
#            emulate('la')
#        else:
#            emulate('a{}'.format(right))
#
#def encloseWith(left, right):
#    emulate('\<esc>`<i{}\<esc>`>la{}\<esc>'.format(left, right))

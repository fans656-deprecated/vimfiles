python << endpython
import re
import datetime
from win32api import GetMonitorInfo, MonitorFromWindow
from win32con import MONITOR_DEFAULTTOPRIMARY

import vim

# vim api ###########################################################
def getline(row=None):
    if not row:
        row = currow()
    return vim.current.buffer[row-1]

def cursor(row=None, col=None, save=False):
    if row or col:
        if save:
            saveCursor()
        vim.current.window.cursor = (row or currow(), col or curcol())
    return vim.current.window.cursor

def currow(row=None):
    if row:
        cursor(row=row)
    return cursor()[0]

def curcol(col=None):
    if col:
        cursor(col=col)
    return cursor()[1]

def curline(line=None):
    if line:
        vim.current.line = line
    return vim.current.line

def curchar():
    return curline()[curcol()]

def nextchar():
    try:
        return curline()[curcol() + 1]
    except IndexError:
        return None

def var(name, value=None):
    if value is not None:
        command('let {} = {}'.format(name, value))
    return vim.eval(name)

def register(name):
    return vim.eval('@{}'.format(name))

def command(cmd):
    vim.command(cmd)

def normal(seq):
    command('normal {}'.format(seq))

def emulate(keys):
    vim.eval('feedkeys("{}", "n")'.format(keys.replace('"', '\\"')))

def insert(*args):
    if len(args) == 1:
        text = args
    normal('a{}'.format(text))

def saveCursor():
    normal('m`')

# api utils #########################################################
def mapRun(*cmds):
    if len(cmds) == 1:
        cmd = cmds[0]
    else:
        cmd = joinCommands(*cmds)
    mapcmd = 'nnoremap {} :{}'.format(var('hotkey_run'), cmd)
    vim.command(mapcmd)

def mapChar(char, func, *ars, **kws):
    call = makeCallString(func, *ars, **kws)
    command('inoremap {} <esc>:python {}<cr>'.format(char, call))

def mapPairChar(charPair):
    left, right = charPair
    mapChar(left, insertPairCharLeft, left, right)
    mapChar(right, insertPairCharRight, right, left)

def defineCommand(name, cmd):
    command('command! Uf6{} {}'.format(name, cmd))

def do(func, *ars, **kws):
    return lambda: func(*ars, **kws)

def joinCommands(*cmds):
    return '\\|'.join(cmds) + '<cr>'

def makeCallString(func, *ars, **kws):
    ars = [repr(ar) for ar in ars]
    kws = ['{}={}'.format(repr(k), repr(v)) for k, v in kws.items()]
    return '{}({})'.format(func.__name__, ', '.join(ars + kws))

def executeUserCommand(name, *args):
    name = 'Uf6' + name
    vim.command('{} {}'.format(name, ' '.join(args)))

def saveView():
    var('w:py_view', vim.eval('winsaveview()'))

def restoreView():
    view = var('w:py_view')
    saveView()
    vim.eval('winrestview({})'.format(view))

def stringPositionsInLine(line):
    inquote = False
    i = beg = end = 0
    while i < len(line):
        ch = line[i]
        if ch == '\\':
            i += 1
        elif not inquote and ch in '\'"':
            inquote = True
            beg = i
            quote = ch
        elif inquote and ch == quote:
            inquote = False
            end = i
            yield beg, end
        i += 1

def isInString(row=None, col=None):
    if not row:
        row, col = cursor()
    for beg, end in stringPositionsInLine(getline(row)):
        if col < beg:
            return False
        elif beg <= col < end:
            return True
    return False

# user utils ########################################################
def insertDatetime():
    dt = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    col = vim.current.window.cursor[1]
    line = vim.current.line
    vim.current.line = line[:col + 1] + dt + line[col + 1:]

def toggleGuiWindowMaximized():
    if 'gui_window_maximized' not in vim.vars:
        vim.vars['gui_window_maximized'] = False
    maximized = vim.vars['gui_window_maximized']
    if maximized:
        restoreGuiWindow()
    else:
        maximizeGuiWindow()

def restoreGuiWindow():
    vim.command('simalt ~r')
    vim.vars['gui_window_maximized'] = False

def maximizeGuiWindow():
    vim.command('simalt ~x')
    vim.vars['gui_window_maximized'] = True

def positionGuiWindow():
    monitor = MonitorFromWindow(0, MONITOR_DEFAULTTOPRIMARY)
    rcWork = GetMonitorInfo(monitor)['Work']
    right, bottom = rcWork[2:]
    right -= 646
    bottom -= 424
    vim.command('winpos {} {}'.format(right, bottom))

def insertPairCharLeft(left=None, right=None):
    if isInString():
        emulate('a{}'.format(left))
    else:
        if curline():
            modeKey = 'a'
        else:
            modeKey = 'cc'
        emulate('{}{}{}\<esc>i'.format(modeKey, left, right))

def insertPairCharRight(right=None, left=None):
    if isInString():
        emulate('a{}'.format(right))
    else:
        if nextchar() == right:
            emulate('la')
        else:
            emulate('a{}'.format(right))

def encloseWith(left, right):
    emulate('\<esc>`<i{}\<esc>`>la{}\<esc>'.format(left, right))
endpython

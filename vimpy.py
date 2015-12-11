import datetime
import re

import vim
try:
    from win32api import GetMonitorInfo, MonitorFromWindow
    from win32con import MONITOR_DEFAULTTOPRIMARY
except ImportError:
    pass

def cursor():
    row, col = vim.current.window.cursor
    return (row - 1, col)

def currow():
    return cursor()[0]

def curcol():
    return cursor()[1]

def curline():
    return vim.current.line

def curchar():
    return curline()[curcol()]

def buffer():
    return vim.current.buffer

def prevLines(row=None):
    if not row:
        row = currow()
    return buffer()[0:row]

def feed(keys, mapped=False):
    keys.replace('"', '\"')
    vim.command('call feedkeys("{}", "{}")'.format(keys,
        'm' if mapped else 'n'))

class Cursor(object):

    def __init__(self, row=None, col=None):
        """
          Cursor() # current row & col
          Cursor('<')
          Cursor(row=1) # current col
          Cursor(col=1) # current row
          Cursor(row=1, col=1)
        """
        if isinstance(row, basestring):
            name = row
            row, col = vim.current.buffer.mark(name)
            row -= 1 # vim line number begin at 1
        else:
            if row is None:
                row = currow()
            if col is None:
                col = curcol()
        self.row = row
        self.col = col

    @property
    def clone(self):
        return Cursor(self.row, self.col)

    @property
    def left(self):
        return Cursor(self.row, self.col - 1)

    @property
    def right(self):
        return Cursor(self.row, self.col + 1)

    @property
    def above(self):
        return Cursor(self.row - 1, self.col)

    @property
    def below(self):
        return Cursor(self.row + 1, self.col)

    @property
    def char(self):
        return vim.current.buffer[self.row][self.col]

    def set(self):
        vim.current.window.cursor = (self.row + 1, self.col)

    def prepend(self, text):
        i = self.col
        Line(self)[i:i] = text

    def append(self, text):
        i = self.col + 1
        Line(self)[i:i] = text

    # TODO: move across row boundary
    def forward(self, n=1):
        self.col += n
        return self

    def forwarded(self, n=1):
        return self.clone.forward(n)

    # TODO: move across row boundary
    def backward(self, n=1):
        self.col -= n
        return self

    def backwarded(self, n=1):
        return self.clone.backward(n)

class Line(object):

    def __init__(self, cursor=None):
        """
          Line() # current line
          Line(row)
          Line(cursor)
        """
        if cursor is None:
            cursor = Cursor()
        elif isinstance(cursor, int):
            row = cursor
            cursor = Cursor(row=row)
        self.cursor = cursor

    def __str__(self):
        return self.text

    def __getitem__(self, key):
        return self.text[key]

    def __setitem__(self, slic, text):
        if not isinstance(slic, slice):
            index = slic
            slic = slice(index, index + 1)
        l = list(self.text)
        l[slic] = list(text)
        text = ''.join(l)
        row = self.row
        vim.current.buffer[row:row+1] = [text]
        # when in non-first window the insertion
        # will move up cursor one row (have no idea why)
        self.cursor.set()

    @property
    def row(self):
        return self.cursor.row

    @property
    def col(self):
        return self.cursor.col

    @property
    def end(self):
        return len(self.text) - 1

    @property
    def text(self):
        return vim.current.buffer[self.row]

    @text.setter
    def text(self, text):
        """
          # replace by line
          line.text = 'hello'
          # replace by lines
          line.text = ['foo', 'bar']
        """
        row = self.row
        if isinstance(text, basestring):
            text = [text]
        self[:] = text

    @property
    def blank(self):
        return not self.text.strip()

    def splitByCol(self, col=None, exclusive=False):
        if col is None:
            col = self.col
        col += exclusive
        text = self.text
        return text[:col], text[col:]

class Visual(object):

    def __init__(self, beg=None, end=None):
        self.beg = Cursor('<') if beg is None else beg
        self.end = Cursor('>') if end is None else end

    def enclose(self, left, right=None):
        """
          enclose('[', ']')
          enclose('"')
        """
        if right is None:
            right = left
        self.beg.prepend(left)
        # compensate cursor offset due to insertion
        self.end.forwarded(len(left)).append(right)

class Buffer(object):

    @property
    def visual(self):
        return Visual()

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
        # execute vim command
        command('set list')

        # set named normal command
        command.add(';r', name='run') # in vimrc
        command['run'].set('write', '!python %') # in python.vim
        command['run'].set('write', 'source %') # in vim.vim
    """

    def __init__(self):
        self.commands = {}

    def __call__(self, cmd):
        try:
            vim.command(cmd)
        except vim.error:
            pass

    def add(self, seq, name=None):
        cmd = Command(seq, name)
        self.commands[name] = cmd
        return cmd

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
            self.put('bottom right')
        else:
            self.maximize()

    def toggleNumLines(self):
        vim.options['lines'] = 40 if vim.options['lines'] <= 25 else 25
        vim.options['columns'] = 100 if vim.options['columns'] <= 80 else 80

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
        right -= 446
        bottom -= 424
        command('winpos {} {}'.format(right, bottom))

gui = Gui()

class UserCommand(object):

    def __init__(self, name, signature):
        self.name = name
        self.signature = signature
        self.funcname = signature.split('(')[0]

    def run(self, *args):
        args = ', '.join(map(repr, args))
        stmt = '{name}({args})'.format(
                name=self.funcname,
                args=args)
        command('python exec {}'.format(stmt))

class UserCommandManager(object):

    def __init__(self):
        self.cmds = {}

    def __getitem__(self, key):
        return self.cmds[key]

    def __setitem__(self, key, value):
        cmd = UserCommand(key, value)
        self.cmds[cmd.name] = cmd

    def run(self, name, *args):
        self[name].run(*args)

usercmd = UserCommandManager()

class LineMatcher(object):

    class Checker(object):

        def __init__(self, target, extractor=None, groupindex=None):
            if isinstance(target, tuple):
                target, extractor, groupindex = target
            self.target = target
            self.extractor = extractor
            self.groupindex = groupindex

        def check(self, text):
            if self.extractor:
                try:
                    text = re.match(self.extractor, text).group(self.groupindex)
                except AttributeError:
                    return False
                return text == self.target
            else:
                return re.match(self.target, text)

    def __init__(self, left, right, action=None):
        if not action:
            right, action = '', right
        self.checkers = map(LineMatcher.Checker, (left, right))
        self.action = action

    def match(self, line):
        return all(c.check(t) for c, t in zip(self.checkers, line.splitByCol()))

    @property
    def matched(self):
        return self.match(Line())

class Completer(object):

    def __init__(self):
        self.hotkey_ = None
        self.autos = []
        self.manus = []
        self.added = False

    @property
    def auto(self):
        return self.auto_

    @auto.setter
    def auto(self, on):
        self.auto_ = on
        if on:
            command('autocmd CursorMovedI * call FeedPythonPrints("vimpy.completer.complete(auto=True)")')

    @property
    def hotkey(self):
        return self.hotkey_

    @hotkey.setter
    def hotkey(self, key):
        if self.hotkey:
            command('silent! iunmap {}'.format(self.hotkey))
        self.hotkey_ = key
        command('inoremap {} <c-r>=InsertPythonPrints("vimpy.completer.complete()")<cr>'.format(self.hotkey))

    def add(self, patternBefore, patternAfter, action=None, auto=False):
        if self.added:
            return
        m = LineMatcher(patternBefore, patternAfter, action)
        if auto:
            self.autos.append(m)
        else:
            self.manus.append(m)

    def complete(self, auto=False):
        matchers = self.autos if auto else self.manus
        for m in matchers:
            if m.matched:
                print m.action

completer = Completer()

# utils ############################################################
# TODO: rewrite using new api
# TODO: new line (above) based on line content
def insertDatetime():
    dt = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    col = vim.current.window.cursor[1]
    line = vim.current.line
    vim.current.line = line[:col + 1] + dt + line[col + 1:]

def changeDirectory(path):
    pass

# TODO: open path
def openDirectory(path=None):
    # NOTE: currently can only open current directory
    path = vim.eval('expand("%:p:h")')
    cmd = 'silent! !explorer {}'.format(path)
    command(cmd)

def tabeMultipleFiles(pattern):
    command('args {} | tab all'.format(pattern))

def openCmd(path=None):
    # NOTE: currently can only open current directory
    path = vim.eval('expand("%:p:h")')
    cmd = 'silent! !start cmd /K "cd /d {}"'.format(path)
    command(cmd)

def removeTrailingWhitespaces():
    command('let g:py_view = winsaveview()')
    command('%s/\s\+$//e')
    command('call winrestview(g:py_view)')

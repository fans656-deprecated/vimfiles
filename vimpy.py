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
        try:
            vim.command(cmd)
        except vim.error:
            pass

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

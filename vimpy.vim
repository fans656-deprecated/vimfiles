python << endpython
import datetime
from win32api import GetMonitorInfo, MonitorFromWindow
from win32con import MONITOR_DEFAULTTOPRIMARY

import vim

def executeUserCommand(name, *args):
    name = 'Uf6' + name
    vim.command('{} {}'.format(name, ' '.join(args)))

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
endpython

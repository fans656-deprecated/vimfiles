import vim
import vimpy
import socket
import config
import os

class Debugger:

    def __init__(self):
        self.running = False
        self.breakpoints = set()

    def toggle(self):
        if self.running:
            self.stop()
        else:
            self.start()

    def start(self):
        if self.running:
            self.stop()
        self.running = True
        if not self.server_exists():
            path = os.path.dirname(os.path.abspath(__file__))
            fpath = os.path.join(path, 'vimpdb.py')
            vim.command('silent !start /b python {}'.format(fpath))

    def stop(self):
        if not self.running:
            return
        self.running = False

    def server_exists(self):
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.sendto('', config.addr)

    def do_break(self):
        pass

    def toggle_breakpoint(self):
        fpath = vim.eval('expand("%:p")')
        row = vimpy.vimrow()
        if (fpath, row) in self.breakpoints:
            self.breakpoints.remove((fpath, row))
        else:
            self.breakpoints.add((fpath, row))
        line_patterns = (r'\%{}l'.format(row)
                         for path, row in self.breakpoints if path == fpath)
        lines_pattern = r'\|'.join(line_patterns)
        cmd = 'match breakpoint /{}/'.format(lines_pattern)
        vimpy.command(cmd)
        print 'Toggling breakpoint at {}:{}'.format(fpath, row)

debugger = Debugger()

import config

import re
import pdb
import sys
import cStringIO as StringIO
import socket
from multiprocessing import Process, Queue

BUF_SIZE = 65536

class VimPdb(object):

    def __init__(self, fpath):
        self.fpath = fpath
        self.process = None

    def start(self):
        self.process = Process(target=self.run_pdb, args=(self.fpath,))
        self.process.daemon = True
        self.in_queue = Queue()
        self.out_queue = Queue()
        self.process.start()

    def stop(self):
        if self.process:
            self.process.terminate()

    def locals(self):
        out = self.execute('locals().keys()').strip()
        out = out.split('\n')[-1]
        return eval(out)

    def value(self, name):
        out = self.execute('print repr({})'.format(name))
        print out

    def run_pdb(self, fpath):
        p = pdb.Pdb()
        p.cmdloop = Cmd(
            p, StringIO.StringIO, self.in_queue, self.out_queue).cmdloop
        p.stdout = StringIO.StringIO()
        p._runscript(fpath)

    def execute(self, cmd):
        self.in_queue.put(cmd)
        return self.out_queue.get()

class Cmd(object):

    def __init__(self, p, new_stdout, in_queue, out_queue):
        self.p = p
        self.new_stdout = new_stdout
        self.in_queue = in_queue
        self.out_queue = out_queue

    def cmdloop(self, *args, **kwargs):
        stop = None
        #print 'init output:'
        self.retrive_output()
        while not stop:
            line = self.in_queue.get()
            #print 'get cmd:', line
            line = self.p.precmd(line)
            stop = self.p.onecmd(line)
            stop = self.p.postcmd(stop, line)
            s = self.retrive_output()
            self.out_queue.put(s)
            self.p.stdout = self.new_stdout()

    def retrive_output(self):
        s = self.p.stdout.getvalue()
        self.p.stdout = self.new_stdout()
        return s

if __name__ == '__main__':
    vimpdb = None
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.bind(('localhost', config.port))
    print 'Listening at', sock.getsockname()
    while True:
        data, addr = sock.recvfrom(BUF_SIZE)
        stop = not data
        if stop:
            print 'bye'
            break
        r = re.match(r'(\w+) ?(.*)', data)
        if r:
            cmd, data = r.groups()
        else:
            cmd = ''
        print 'Receive cmd: "{}" from {}'.format(cmd, addr)
        if cmd == 'debug':
            fpath = data
            print 'fpath == {}'.format(fpath)
            if vimpdb:
                vimpdb.stop()
                vimpdb = None
            vimpdb = VimPdb(fpath)
            vimpdb.start()
            r = 'ok'
        elif cmd == 'pdb':
            pdb_cmd = data
            print 'execute pdb command: {}'.format(pdb_cmd)
            if not vimpdb:
                r = 'pdb not running'
            else:
                r = vimpdb.execute(pdb_cmd)
        else:
            r = ''
        sock.sendto(r, addr)

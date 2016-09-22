autocmd BufWinEnter *.txt python checkEnos()
autocmd BufWritePost sentences.txt silent !start /b python "D:\Private\enos\english\send.py"
nnoremap ;t :py commitEnos()<cr>

python << endpython
import os
import subprocess
import datetime
import base64
from multiprocessing import Process

vimpy.command('nmap ;n Go<esc>o<esc>;do')

def uploadEng():
    def f():
        os.system(r'python D:\Private\enos\english\send.py')
    Process(target=f).start()

def checkEnos():
    path = vim.eval('expand("%:p")')
    fname = os.path.basename(path)
    path = os.path.dirname(path)
    if 'enos' in path:
        vimpy.usercmd['upload'] = 'uploadEnos()'
        vimpy.usercmd['commit'] = 'commitEnos()'
    if r'\blog\content' in path:
        vim.command(r'nnoremap ;r :w\|!python "D:\Source\Python\blog_generator\main.py"<cr><cr>')
        
def uploadEnos(path=None):
    commitEnos(path)
    subprocess.call(r'git push')

def commitEnos(path=None):
    if not path:
        path = 'D:/Private/enos'
    des = os.path.join(path, 'diary.rar')
    winrar = 'D:/System/WinRAR4.11/WinRAR.exe'
    if os.path.exists(des):
        subprocess.call(r'del {}'.format(des), shell=True)
    subprocess.call('cd /d {}'.format(path), shell=True)
    password = open('D:/Private/enosp.txt').readlines()[0].strip()
    password = base64.b64decode(password)
    subprocess.call('{winrar} a diary.rar diary.txt -p{password}'.format(
        winrar=winrar,
        password=password))
    subprocess.call('git add --all .', shell=True)
    dt = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    subprocess.call('git commit -m "{}"'.format(dt), shell=True)
    subprocess.Popen(('git', 'push'))
endpython

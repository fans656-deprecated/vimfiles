autocmd BufWinEnter *.txt python checkEnos()
nnoremap ;t :py commitEnos()<cr>

python << endpython
import os
import subprocess
import datetime
import base64

def checkEnos():
    path = vim.eval('expand("%:p")')
    fname = os.path.basename(path)
    path = os.path.dirname(path)
    if 'enos' in path:
        vimpy.usercmd['upload'] = 'uploadEnos()'
        vimpy.usercmd['commit'] = 'commitEnos()'
    if fname == 'diary.txt':
        vimpy.command('nmap ;n Go<esc>o<esc>;do')
        
def uploadEnos(path=None):
    commitEnos(path)
    subprocess.call(r'git push')

def commitEnos(path=None):
    if not path:
        path = r'E:\Private\enos'
    des = os.path.join(path, 'diary.rar')
    winrar = r'D:\System\WinRAR\WinRAR.exe'
    if os.path.exists(des):
        subprocess.call(r'del {}'.format(des), shell=True)
    subprocess.call(r'cd /d {}'.format(path), shell=True)
    password = open('E:/Private/enosp.txt').readlines()[0].strip()
    password = base64.b64decode(password)
    subprocess.call(r'{winrar} a diary.rar diary.txt -p{password}'.format(
        winrar=winrar,
        password=password))
    subprocess.call(r'git add --all .', shell=True)
    dt = datetime.datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    subprocess.call(r'git commit -m "{}"'.format(dt), shell=True)
endpython

set cindent
set cinoptions=g-1

nnoremap ;r :w \| !g++ % -o t.exe & t.exe<cr>
nnoremap ;c :w \| !g++ % -o t.exe<cr>

command! Uf6df python createClassImplementation()

python << endpython
import vim

def createClassImplementation():
    p = Parser(vim.current.buffer)
    p.parse()
    vim.command('normal G')
    for method in p.classes.values()[0].methods.values():
        vim.command('normal o')
        vim.command('normal o{}'.format(method))
        vim.command('normal o{')
        vim.command('normal o}')

endpython

if has('gui_running')
    "nnoremap ;r :write \| !nasm -o t.bin % && ndisasm t.bin > t.txt<cr><cr>
    nnoremap ;r :w \| !gcc % && a.exe<cr><cr>
endif
let g:current_file = expand("%:p")

python << endpython
import vim
import os
vimrc_path = vim.eval('$MYVIMRC')
home_path = os.path.dirname(vimrc_path)
file_type = vim.eval('&filetype')
fpath = os.path.join(home_path, 'ftplugin', file_type, 'strip.py')
target_fpath = vim.eval('g:current_file')
strip_commands = (
    'exec \'normal ,da\'',
    'exec \'read !python "{}" {}\''.format(fpath, target_fpath),
    'exec \'normal ggdd\''
)
vim.command(('nnoremap ;s :' + 
    ' \\| '.join(strip_commands) + 
    '<cr><cr>').format(fpath))
vim.command(' | '.join(strip_commands))
endpython

set tabstop=4
set shiftwidth=4
set expandtab

let s:py2exepath = 'D:/Programming/Lang/Python2.7.8/python.exe'
let s:py3exepath = 'D:/Programming/Lang/Python3.4.1/python.exe'

imap <m-h> _
imap <m-j> =
imap <m-k> (
imap <m-l> )

" TMP: copy program running results to clipboard
nnoremap ;t :write \| let @+ = system('python '.expand('%'))<cr>

inoremap ;$ <esc>A
inoremap ;j <esc>o

inoremap sf self
abbreviate sf. self.
inoremap re; return

" define class
" inoremap ;ds <esc>:python defineClass()<cr>
" TODO
" define function (or method)

python << endpython

# nnoremap ;r :write \| !python %<cr>
command['run'].set('write', '!python %')

# TODO: pair char
#vimpy.mapPairChar('()')
#vimpy.mapPairChar('[]')

endpython

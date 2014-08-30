execute pathogen#infect()
source ~/vimfiles/vimpy.vim

let $LANG = 'en_US'
set guioptions-=T	" remove toolbar
set guioptions-=m	" remove menubar
set noswapfile
set number
set ruler
set incsearch
set ignorecase
set encoding=utf-8
set fileencoding=utf-8

set foldmethod=syntax
set nofoldenable
nnoremap ,f :set foldenable<cr>
nnoremap ,F :set nofoldenable<cr>

filetype plugin indent on
syntax enable
set guifont=Inconsolata:h11:cANSI
set background=dark
colorscheme solarized

set backspace=indent,eol,start
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab

inoremap <m-,> _

" Insert -> Normal
noremap! jk <esc>
noremap! jj j
noremap! kj <esc>
noremap! kk k

" scroll down
nnoremap <c-j> <c-e>
" scroll up
nnoremap <c-k> <c-y>

" clipboard cut copy paste
" normal mode copy one line
noremap <m-y> "+yy
" visual mode copy
vnoremap <m-y> "+y
" normal mode cut one line
noremap <m-d> "+dd
" visual mode cut
vnoremap <m-d> "+d
" paste
noremap <m-p> "+p
" paste above
noremap <m-s-p> "+P

" write
nnoremap ;w :w<cr>
" write & quit
nnoremap ;q :wq<cr>
" quit
nnoremap ;Q :q!<cr>

nnoremap ;d :python insertDatetime()<cr>

" write & source vimrc & reset filetype
nnoremap ,so :w\|source $MYVIMRC\|exe "set filetype=".&filetype<cr>
" maximize/restore gui window
nnoremap ,m :python toggleGuiWindowMaximized()<cr>

" goto previous tab
nnoremap <m-[> :tabprevious<cr>
" goto next tab
nnoremap <m-]> :tabnext<cr>
" goto tab 1-9
for i in range(1, 9)
    execute('nnoremap <a-'.i.'> :tabnext '.i.'<cr>')
endfor
" goto last tab
nnoremap <m-0> :tablast<cr>
" move tab to previous
nnoremap <m-s-[> :tabmove -1<cr>
" move tab to next
nnoremap <m-s-]> :tabmove +1<cr>
" move tab to first
nnoremap <m-s-1> :tabmove 0<cr>
" move tab to last
nnoremap <m-s-0> :tabmove<cr>

" real user defined command
" vim doesn't allow user defined command begin with lowercase letter
" so we define a wrapping command 'U' which
" takes the RUC(real user-defined command) name and its args
" then the RUC can use an arbitrary name
" RUC should use be defined like this:
"   command! Uf6test ..
" and used like this:
"   test ..
" executeUserCommand() will add the 'Uf6' prefix
command! -nargs=+ U python executeUserCommand(<f-args>)
" press ;; takes you Normal -> (RUC) Command
nnoremap ;; :U<space>

if !exists('g:first_run')
    let g:first_run = 1
    python positionGuiWindow()
endif

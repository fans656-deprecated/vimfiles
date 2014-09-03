" TODO
"   <m-o> get out
"   <m-x> delete pair
"   {} in python string
"   ' out of string
"   python toClass
"       Class(object)
"       Child(Parent)
"   python module
"   don't open new tab to edit vimrc if current file is none
"   don't auto complete quotes in comment
"   BufRead cd
set nocompatible

let g:hotkey_run = ';r'

let $LANG = 'en_US'
set guioptions-=T	" remove toolbar
set guioptions-=m	" remove menubar
set noswapfile
set number
set relativenumber
autocmd InsertEnter * set norelativenumber
autocmd InsertLeave * set relativenumber
set ruler
set incsearch
set ignorecase
set encoding=utf-8
set fileencoding=utf-8

set backspace=indent,eol,start
set autoindent
set tabstop=4
set shiftwidth=4
set expandtab

execute pathogen#infect()

filetype plugin indent on
syntax enable
set guifont=Inconsolata:h11:cANSI
set background=dark
colorscheme solarized

" Insert -> Normal
noremap! <c-l> <esc>
vnoremap <c-l> <esc>
" relative line number
noremap <m-r> :set relativenumber!<cr>
" scroll down
nnoremap <c-j> <c-e>
" scroll up
nnoremap <c-k> <c-y>
" goto head of line
noremap H ^
" goto end of line
noremap L $
" goto top screen line
noremap 0 H
" goto bottom screen line
noremap $ L
" goto middle screen line
noremap % M
" goto matched paren
noremap M %
" do recorded action (using register q)
nnoremap <m-.> @q

" clipboard cut copy paste
" normal mode copy one line
noremap <m-y> "+yy
" visual mode copy
vnoremap <m-y> "+y
" normal mode copy all
" mz  - save cursor pos
" H   - goto top screen line
" mx  - mark top screen line
" gg  - goto top buffer line
" VG  - select till end buffer (i.e. all)
" "+y - copy to clipboard
" 'x  - back to marked top screen line
" zt  - put at top screen
" `z  - back to marked cursor pos
noremap <m-s-y> mzHmxggVG"+y'xzt`z
" normal mode cut one line
noremap <m-d> "+dd
" visual mode cut
vnoremap <m-d> "+d
" paste
noremap <m-p> "+p
" paste above
noremap <m-s-p> "+P

" find next char in the line
noremap \ ;
" save
nnoremap ;w :w<cr>
" quit with save
nnoremap ;q :wq<cr>
" quit without save
nnoremap ;Q :q!<cr>

" write & source vimrc & reset filetype
nnoremap <silent> ,so :write \| source $MYVIMRC \| exe "set filetype=".&filetype<cr><esc>
" edit vimrc
nnoremap ,erc :tabedit $MYVIMRC<cr>
" source and run (develop)
nmap ,sr ,so;r

" goto previous tab
nnoremap <m-[> :tabprevious<cr>
" goto next tab
nnoremap <m-]> :tabnext<cr>
" goto tab 1-9
for i in range(1, 9) | execute('nnoremap <a-'.i.'> :tabnext '.i.'<cr>') | endfor
" goto last tab
nnoremap <m-0> :tablast<cr>
" move tab to previous
nnoremap <m-{> :tabmove -1<cr>
" move tab to next
nnoremap <m-}> :tabmove +1<cr>
" move tab to first
nnoremap <m-s-1> :tabmove 0<cr>
" move tab to last
nnoremap <m-s-0> :tabmove<cr>

" finetune colorscheme
highlight CursorLineNr gui=bold guifg='#49646c'
highlight MatchParen gui=bold guifg='#839496' guibg='#00556b'

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" below uses python

source <sfile>:p:h/vimimport.vim

" insert date and time (2014-08-16 15:23:02)
nnoremap <silent> ;d :python vimpy.insertDatetime()<cr>
" maximize/restore gui window
nnoremap ,m :python gui.toggleMaximized()<cr>

python << endpython

command.add(';r', name='run')

if not gui.maximized:
    gui.put('bottom right')

endpython

"" real user defined command
"" vim doesn't allow user defined command begin with lowercase letter
"" so we define a wrapping command 'U' which
"" takes the RUC(real user-defined command) name and its args
"" then the RUC can use an arbitrary name
"" RUC should use be defined like this:
""   command! Uf6test ..
"" and used like this:
""   test ..
"" executeUserCommand() will add the 'Uf6' prefix
"command! -nargs=+ U python executeUserCommand(<f-args>)
"" press ;; takes you Normal -> (RUC) Command
"nnoremap ;; :U<space>

"" experimental
"vnoremap ' :<c-u>python encloseWith("'", "'")<cr>
"vnoremap " :<c-u>python encloseWith('"', '"')<cr>
"vnoremap ( :<c-u>python encloseWith('(', ')')<cr>

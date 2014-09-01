" TODO
"   <m-o> get out
"   <m-x> delete pair
"   {} in python string
"   ' out of string
"   python toClass
"       Class(object)
"       Child(Parent)
"   python module

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

source ~/vimfiles/vimpy.vim

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

" move around commands
function! Ranged(pycmd, seq) range
    execute 'python '.a:pycmd.'()'
    if v:count1 > 1
        execute 'normal! '.v:count1.a:seq
    else
        execute 'normal! '.a:seq
    endif
endfunction
autocmd BufWinEnter * python saveView()
nnoremap <silent> gg :python saveView()<cr>gg
vnoremap <silent> gg :python saveView()<cr>gg
nnoremap <silent> G :<c-u>call Ranged('saveView', 'G')<cr>
nnoremap <silent> '' :python restoreView()<cr>

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

" find next char in the line
noremap \ ;
" save
nnoremap ;w :w<cr>
" quit with save
nnoremap ;q :wq<cr>
" quit without save
nnoremap ;Q :q!<cr>

nnoremap <silent> ;d :python insertDatetime()<cr>

" write & source vimrc & reset filetype
nnoremap <silent> ,so :write \| source $MYVIMRC \| exe "set filetype=".&filetype<cr><esc>
" edit vimrc
nnoremap ,erc :tabedit $MYVIMRC<cr>
" source and run (develop)
nmap ,sr ,so;r
" maximize/restore gui window
nnoremap ,m :python toggleGuiWindowMaximized()<cr>

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

python defineCommand('reposition', 'python positionGuiWindow')
python defineCommand('syntax', 'syntax off | syntax on')

if !exists('g:first_run')
    let g:first_run = 1
    python positionGuiWindow()
endif

" finetune colorscheme
highlight CursorLineNr gui=bold guifg='#49646c'
highlight MatchParen gui=bold guifg='#839496' guibg='#00556b'

" experimental
vnoremap ' :<c-u>python encloseWith("'", "'")<cr>
vnoremap " :<c-u>python encloseWith('"', '"')<cr>
vnoremap ( :<c-u>python encloseWith('(', ')')<cr>

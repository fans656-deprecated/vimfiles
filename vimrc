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
autocmd BufRead * cd %:p:h
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

set timeoutlen=500

" Insert -> Normal
noremap! <c-k> <esc>
vnoremap <c-k> <esc>
" relative line number
noremap <m-r> :set relativenumber!<cr>
" scroll down
nnoremap <c-j> <c-e>
" scroll up
nnoremap <c-k> <c-y>
" visual line down
noremap j gj
" visual line up
noremap k gk
" goto head of line
noremap H g^
" goto end of line
noremap L g$
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

" clear & insert
nnoremap ,cl ggcG
" delete all
nnoremap ,da ggdG

" clipboard cut copy paste
" normal mode copy one line
noremap <m-y> "+yy
" normal mode copy all
noremap <m-Y> mzHmxggVG"+yy'xzt`z
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
" quit all with save
nnoremap ,q :wall \| qall<cr>
" quit all without save
nnoremap ,Q :qall!<cr>

" write & source vimrc & reset filetype
nnoremap <silent> ,so :write \| source $MYVIMRC \| exe "set filetype=".&filetype<cr><esc>
" edit vimrc
nnoremap ,er :tabedit $MYVIMRC<cr>
" source and run (develop)
nmap ,sr ,so;r

" tab
nnoremap ,t<space> :tab<space>
nnoremap ,te :tabe<space>
" goto previous tab
nnoremap <m-[> :tabprevious\|cd %:p:h<cr>
" goto next tab
nnoremap <m-]> :tabnext\|cd %:p:h<cr>
" goto tab 1-9
for i in range(1, 9)
    execute('nnoremap <a-'.i.'> :tabnext '.i.'\|cd %:p:h<cr>')
endfor
" goto last tab
nnoremap <m-0> :tablast\|cd %:p:h<cr>
" move tab to previous
nnoremap <m-{> :tabmove -1<cr>
" move tab to next
nnoremap <m-}> :tabmove +1<cr>
" move tab to first
nnoremap <m-s-1> :tabmove 0<cr>
" move tab to last
nnoremap <m-s-0> :tabmove<cr>

" new line without affect trailing characters
inoremap <c-j> <end><cr>
" one char left
inoremap <m-h> <left>
" one char right
inoremap <c-l> <right>
" delete char after the cursor
inoremap <c-e> <del>
" end of line
inoremap <m-a> <end>

" _
inoremap <c-i> _
" tab
inoremap <m-i> <tab>

" finetune colorscheme
highlight CursorLineNr gui=bold guifg='#49646c'
highlight MatchParen gui=bold guifg='#839496' guibg='#00556b'
nnoremap <F10> :execute 'highlight '.synIDattr(synID(line('.'), col('.'), 1), 'name')<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" below uses python
source <sfile>:p:h/vimimport.vim

" insert date and time (2014-08-16 15:23:02)
nnoremap <silent> ;d :python vimpy.insertDatetime()<cr>
nnoremap <silent> ;1d o<esc>:python vimpy.insertDatetime()<cr>
nnoremap <silent> ;2d o<esc>o<esc>:python vimpy.insertDatetime()<cr>
nmap <silent> ;D ;1d
" maximize/restore gui window
nnoremap ,m :python vimpy.gui.toggleMaximized()<cr>

python << endpython
vimpy.command.add(';r', name='run')

if not vimpy.gui.maximized:
    vimpy.gui.put('bottom right')
endpython

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
command! -nargs=+ U python vimpy.usercmd.run(<f-args>)
" press ;; takes you Normal -> (RUC) Command
nnoremap ;; :U<space>

python vimpy.usercmd['od'] = 'vimpy.openDirectory(path)'
python vimpy.usercmd['ta'] = 'vimpy.tabeMultipleFiles(path)'

inoremap <m-v> <esc>lv
vnoremap ( :<c-u>python vimpy.Visual().enclose('(', ')')<cr>
vnoremap [ :<c-u>python vimpy.Visual().enclose('[', ']')<cr>

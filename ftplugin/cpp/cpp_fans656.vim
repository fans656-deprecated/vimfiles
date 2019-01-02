set cindent
set cinoptions=g-1

set foldmethod=syntax
set nofoldenable

highlight Folded guifg=#0B4250 guibg=#002b36

nnoremap ,f :set foldenable!<cr>

if has('gui_running')
    nnoremap ;r :execute('write \| !start cmd /C "g++ -std=c++11 "' . expand('%') . '" -o t.exe" && t.exe & pause')<cr><cr>
else
    nnoremap ;r :write \| !clear && g++ -std=c++11 % -o a.out && ./a.out<cr>
endif
nnoremap ;s :w \| !start cmd /C "g++ -std=c++11 -S -masm=intel -O0 % -o t.s && start gvim t.s & exit"<cr><cr>
nnoremap ;S :w \| !start cmd /C "g++ -std=c++11 -S -masm=intel -O3 % -o t.s && start gvim t.s & exit"<cr><cr>

nnoremap <m-o> jO<esc>ko
nnoremap <m-O> ko<esc>jO

python exec vimimport('cpp')

"inoremap #i #include <><left>
inoremap ;cls class `` {<cr>public:<cr><cr>private:<cr>};<esc>?``<cr>2s
inoremap ;main int main() {<cr>}<esc>O
inoremap ;sco std::cout
inoremap ;sel std::endl
"inoremap { {<cr>}<esc>O
"inoremap ( ()<left>
inoremap ;swi switch (``) {<cr>default:<cr>break;<cr>}<esc>?``<cr>2s
inoremap ;tem template<typename T>
imap ;tcl ;tem<cr>;cls
"inoremap << <space><<<space>
"inoremap >> <space>>><space>
"inoremap s: std::

inoremap <m-j> <esc>o
inoremap <m-h> <left>
inoremap <m-l> <right>
inoremap <m-a> <esc>A
inoremap <c-i> _

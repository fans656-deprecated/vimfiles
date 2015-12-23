set cindent
set cinoptions=g-1

set foldmethod=syntax
set nofoldenable

highlight Folded guifg=#0B4250 guibg=#002b36

nnoremap ,f :set foldenable!<cr>

if has('gui_running')
    nnoremap ;r :write \| !start cmd /C "g++ *.cpp -o t.exe" & t.exe & pause<cr><cr>
else
    nnoremap ;r :write \| !clear && g++ *.cpp -o a.out && ./a.out<cr>
endif
nnoremap ;c :w \| !g++ % -o t.exe<cr>

nnoremap <m-o> jO<esc>ko
nnoremap <m-O> ko<esc>jO

python exec vimimport('cpp')

inoremap #i #include <><left>
inoremap ;cls class `` {<cr>public:<cr><cr>private:<cr>};<esc>?``<cr>2s
inoremap ;main int main() {<cr>return 0;<cr>}<esc>kO
inoremap ;sco std::cout
inoremap ;sel std::endl
inoremap { {<cr>}<esc>O
"inoremap ( ()<left>
inoremap ;swi switch (``) {<cr>default:<cr>break;<cr>}<esc>?``<cr>2s
inoremap ;tem template<typename T>
imap ;tcl ;tem<cr>;cls
"inoremap << <space><<<space>
"inoremap >> <space>>><space>
inoremap s: std::

inoremap <m-j> <esc>o
inoremap <m-h> <left>
inoremap <m-l> <right>
inoremap <m-a> <esc>A
inoremap <c-i> _

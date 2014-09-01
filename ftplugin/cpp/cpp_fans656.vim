set cindent
set cinoptions=g-1

set foldmethod=syntax
set nofoldenable
nnoremap ,f :set foldenable<cr>
nnoremap ,F :set nofoldenable<cr>

nnoremap ;r :w \| !g++ % -o t.exe & t.exe<cr>
nnoremap ;c :w \| !g++ % -o t.exe<cr>

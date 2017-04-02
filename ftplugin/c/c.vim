if has('gui_running')
    nnoremap ;r :write \| !cls && gcc % && a.exe<cr><cr>
    "nnoremap ;d :write \| !cls && gcc -c -o t.o % && 
    "            \ gcc -shared -o t.dll t.o<cr><cr>
else
    nnoremap ;r :write\|!clear&&gcc %&&./a.out<cr>
endif

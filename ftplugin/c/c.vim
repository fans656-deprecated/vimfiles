if has('gui_running')
    echo 'not implemented'
else
    nnoremap ;r :write\|!clear&&gcc %&&./a.out<cr>
endif

set fileformat=unix
if has('gui_running')
    nnoremap ;r :write \| !\%BASHEXE\% %<cr><cr>
endif

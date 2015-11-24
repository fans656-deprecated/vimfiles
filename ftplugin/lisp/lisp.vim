let g:slimv_lisp = 'D:/Prog/Lang/ccl/wx86cl.exe'
let g:lisp_rainbow=1

nnoremap ;r :write \| !start cmd /C "D:/Prog/Lang/ccl/wx86cl.exe -b --quiet --load "%"" & pause<cr><cr>

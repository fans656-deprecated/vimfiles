nnoremap ;r :write \| !start cmd /C "runghc "%"" & pause<cr><cr>
nnoremap ;c :write \| !start cmd /C "ghc %" & pause<cr><cr>
nnoremap ;t ggO<esc>:r quickcheckHead.txt<cr>
            \ ggddGo<esc>:r quickcheckTail.txt<cr>

" comment / uncomment
" vnoremap - 
" nnoremap - 

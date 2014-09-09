python << endpython
import sys

import vim

# permanently add ~/vimfiles to sys.path
# so that any python module can do
#   from vimimport import vimimport
# then use vimimport() to access any module
sys.path.insert(0, vim.eval('expand("<sfile>:p:h")'))
from vimimport import vimimport
exec vimimport('vimpy')
endpython

function! s:GetPythonPrints(stmt)
    let t = @a
    redir @a
    execute 'python '.a:stmt
    redir END
    let r = @a
    let @a = t
    " remove the first char: ^J (have no idea why)
    return r[1:]
endfunction

function! s:InterpolateVimKeys(str)
    " escape double quote
    let str = substitute(a:str, '"', '\\"', 'g')
    return eval('"'.str.'"')
endfunction

function! InsertPythonPrints(stmt)
    return s:InterpolateVimKeys(s:GetPythonPrints(a:stmt))
endfunction

function! FeedPythonPrints(stmt)
    call feedkeys(s:InterpolateVimKeys(s:GetPythonPrints(a:stmt)))
endfunction

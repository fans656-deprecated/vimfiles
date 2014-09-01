python << endpython
import sys

import vim

# permanently add ~/vimfiles to sys.path
# so that any python module can do
#   from vimimport import vimimport
# then use vimimport() to access any module
sys.path.insert(0, vim.eval('expand("<sfile>:p:h")'))
from vimimport import vimimport
exec vimimport('vimpy', '*')
endpython

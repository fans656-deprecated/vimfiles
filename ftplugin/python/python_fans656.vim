set tabstop=4
set shiftwidth=4
set expandtab

nnoremap ;r :w \| !python %<cr>
nnoremap ;; :se ft=python<cr>
nnoremap ;2 :python switchTo2()<cr>
nnoremap ;3 :python switchTo3()<cr>

" alt-h
imap è _
" alt-j
imap ê =
" alt-k
imap ë (
" alt-l
imap ì )

inoremap ;$ <esc>A
inoremap ;sf self.
inoremap ;j <esc>o
inoremap ;l <esc>f)a
inoremap ;re return

inoremap ;df <esc>:python toFunc()<cr>
inoremap ;ds <esc>:python toSelfFunc()<cr>
inoremap ;du <esc>:python toUnderlineFunc()<cr>
inoremap ;im <esc>:python toImport()<cr>
inoremap ( <esc>:python insertPairChar('(')<cr>
inoremap ) <esc>:python skipChar(')')<cr>
inoremap [ <esc>:python insertPairChar('[')<cr>
inoremap ] <esc>:python skipChar(']')<cr>
inoremap { <esc>:python insertPairChar('{')<cr>
inoremap } <esc>:python skipChar('}')<cr>

nnoremap ;n :python newLine()<cr>

python << endpython
import vim
import re

charPairs = {
  '(': ')',
  '[': ']',
  '{': '}',
  }

def normal(cmd):
  vim.command('normal {}'.format(cmd))

def feed(s):
  vim.command('call feedkeys("{}")'.format(s))

def switchTo3():
  vim.command("nnoremap ;r :w \| !D:\\Programming\\Lang\\Python3.4.1\\python.exe %<cr>")

def switchTo2():
  vim.command("nnoremap ;r :w \| !python %<cr>")

# row is 1-based
# col is 0-based
def charAt(row, col):
  lines = vim.current.buffer
  if not checkRowCol(row, col):
    return None
  return lines[row - 1][col]

def nextChar():
  row, col = curCursor()
  return charAt(row, col + 1)

def prevChar():
  row, col = curCursor()
  return charAt(row, col - 1)

def lineAt(row):
  return vim.current.buffer[row - 1] if checkRow(row) else None

def checkRow(row):
  return 1 <= row <= len(vim.current.buffer)

def checkRowCol(row, col):
  return checkRow(row) and 0 <= col < len(vim.current.buffer[row - 1])

def curCursor():
  return vim.current.window.cursor

def curRow():
  return curCursor()[0]

def curCol():
  return curCursor()[1]

def lineInsert(index, s, line=None):
  if not line:
    line = vim.current.line 
  return line[:index] + s + line[index:]

def newLine():
  row = curRow()
  if lineAt(row) and lineAt(row + 1):
    vim.command('normal 3ok')
  elif lineAt(row) and not lineAt(row + 1):
    vim.command('normal 2o')
  elif not lineAt(row) and lineAt(row + 1):
    vim.command('normal 2O')
  feed('i')

def getFuncInfo():
  line = lineAt(curRow())
  xs = line.split()
  name, args = xs[0], xs[1:]
  spaces = re.match('^(\s*).*', line).group(1)
  return [spaces, name, args]

def replaceByFuncHeader(spaces, name, args):
  line = '{}def {}({}):'.format(spaces, name, ', '.join(args))
  vim.current.line = line
  feed('$o')

def toFunc():
  replaceByFuncHeader(*getFuncInfo())

def toSelfFunc():
  info = getFuncInfo()
  info[2].insert(0, 'self')
  replaceByFuncHeader(*info)

def toUnderlineFunc():
  info = getFuncInfo()
  info[1] = '__{}__'.format(info[1])
  info[2].insert(0, 'self')
  replaceByFuncHeader(*info)

def toImport():
  xs = lineAt(curRow()).split()
  package, modules = xs[0], xs[1:]
  if modules:
    line = 'from {} import {}'.format(package, ', '.join(modules))
  else:
    line = 'import {}'.format(package)
  vim.command('normal "zcc{}'.format(line))

def insertPairChar(cBeg):

  def valid(c):
    return not c or c in ' []{}'

  cEnd = charPairs[cBeg]
  s = '{}{}'.format(cBeg, cEnd if valid(nextChar()) else '')
  col = curCol() + 1
  vim.current.line = lineInsert(col, s)
  feed('la')

def skipChar(c):
  if nextChar() != c:
    vim.current.line = lineInsert(curCol() + 1, c)
  vim.command('call feedkeys("la")')
endpython

set tabstop=4
set shiftwidth=4
set expandtab

" pair
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap ' ''<left>
inoremap " ""<left>

" read run result into clipboard
nnoremap ;t :let @+ = system('python '.expand('%'))<cr>
" interactive run
nnoremap ;i :write\|!start cmd /C "python -i "%""<cr><cr>

python exec vimimport('py')

python << endpython
vimpy.command['run'].set('write', '!start cmd /C "python \"%\"" & pause<cr>')

if not vimpy.completer.added:
    # completion
    word = lambda text: (text, '((.*\W)|^)(\w+)$', 3)
    keyword = lambda text: (text, '\s*({0})$'.format(text), 1)
    # keywoards
    vimpy.completer.auto = True

    vimpy.completer.add(keyword('if'), ' :\<left>', auto=True)
    vimpy.completer.add(keyword('else'), ':\<cr>', auto=True)
    vimpy.completer.add(keyword('elif'), ' :\<left>', auto=True)
    vimpy.completer.add(keyword('try'), ':\<cr>', auto=True)
    vimpy.completer.add(keyword('for'), '  in :' + '\<left>'*5, auto=True)
    vimpy.completer.add(keyword('while'), ' :\<left>', auto=True)
    vimpy.completer.add(('from', '^from$', 0), '  import ' + '\<c-left>\<left>', auto=True)

    vimpy.completer.add(word('sf'), '\<bs>'*2 + 'self', auto=True)
    vimpy.completer.add(word('none'), '\<bs>'*4 + 'None', auto=True)
    vimpy.completer.add(word('true'), '\<bs>'*4 + 'True', auto=True)
    vimpy.completer.add(word('false'), '\<bs>'*5 + 'False', auto=True)

    vimpy.completer.hotkey = '<c-f>'
    vimpy.completer.add(word('f'), '\<bs>format()\<left>')
    vimpy.completer.add(word('i'), '\<bs>import ')
    vimpy.completer.add(word('p'), '\<bs>print ')
    vimpy.completer.add(word('e'), '\<bs>except :\<left>')
    vimpy.completer.add(word('r'), '\<bs>return ')
    vimpy.completer.add(word('ri'), '\<bs>raise ')
    vimpy.completer.add(word('ps'), '\<bs>\<bs>pass')
    vimpy.completer.add(word('en'), '\<bs>\<bs>enumerate')

    # exceptions
    vimpy.completer.add(word('ae'), '\<bs>\<bs>AttributeError')
    vimpy.completer.add(word('ex'), '\<bs>\<bs>Exception')
    vimpy.completer.add(word('ie'), '\<bs>\<bs>IndexError')
    vimpy.completer.add(word('ke'), '\<bs>\<bs>KeyError')
    vimpy.completer.add(word('si'), '\<bs>\<bs>StopIteration')
    vimpy.completer.add(word('ve'), '\<bs>\<bs>ValueError')

    vimpy.completer.add(word('eie'), '\<bs>\<bs>\<bs>except IndexError:\<cr>')
    vimpy.completer.add(word('eke'), '\<bs>\<bs>\<bs>except KeyError:\<cr>')
    vimpy.completer.add(word('eve'), '\<bs>\<bs>\<bs>except ValueError:\<cr>')
    vimpy.completer.add(word('esi'), '\<bs>\<bs>\<bs>except StopIteration:\<cr>')
    vimpy.completer.add(word('eex'), '\<bs>\<bs>\<bs>except Exception:\<cr>')
    
    # modules
    vimpy.completer.add(word('co'), '\<bs>\<bs>collections')
    vimpy.completer.add(word('dt'), '\<bs>\<bs>datetime')
    vimpy.completer.add(word('it'), '\<bs>\<bs>itertools')
    vimpy.completer.add(word('th'), '\<bs>\<bs>threading')
    vimpy.completer.add(word('qu'), '\<bs>\<bs>Queue')
    
    # functions
    vimpy.completer.add(word('td'), '\<c-w>timedelta')

    # others
    vimpy.completer.add(word('ii'), '\<bs>'*2 + 'isinstance(, )' + '\<left>'*3)
    vimpy.completer.add(word('pro'), '\<bs>'*3 + 'property')
    vimpy.completer.add(word('set'), '\<bs>'*3 + 'setter')
    vimpy.completer.add(word('main'), '\<bs>'*4 + r"if __name__ == '__main__':\<cr>")
    vimpy.completer.add(word('doc'), '\<bs>'*3 + '"""\<cr>"""\<esc>O\<space>\<space>')

    del word
    vimpy.completer.added = True
endpython
autocmd BufWritePre *.py python vimpy.removeTrailingWhitespaces()

" define class
inoremap ;cl <esc>:python py.defineClass()<cr>
" define class (pass)
inoremap ;cpl <esc>:python py.defineClass(withbody=True)<cr>
" define function
inoremap ;df <esc>:python py.defineFunction()<cr>
" define function (pass)
inoremap ;dpf <esc>:python py.defineFunction(withbody=True)<cr>
" define __function__
inoremap ;du <esc>:python py.defineFunction(underscore=True)<cr>
" define __function__ (pass)
inoremap ;dpu <esc>:python py.defineFunction(withbody=True, underscore=True)<cr>
" self.foo = foo
inoremap ;is <esc>:python py.assignToSelf()<cr>
" from __future__ import ...
inoremap ;fu from __future__ import absolute_import, print_function, division<esc>
" PySide
inoremap ;qi from PySide.QtCore import *<cr>from PySide.QtGui import *<esc>
" PySide
inoremap ;qp class Widget(QDialog):<cr>
            \<cr>
            \def __init__(self, parent=None):<cr>
            \super(Widget, self).__init__(parent)<cr>
            \<cr><c-u>
            \app = QApplication([])<cr>
            \w = Widget()<cr>
            \w.show()<cr>
            \app.exec_()<esc>5k

highlight ColorColumn ctermbg=235 guibg=#004050
let &colorcolumn="".join(range(80,999),",")

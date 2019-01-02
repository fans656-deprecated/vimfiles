set tabstop=4
set shiftwidth=4
set expandtab

" pair
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap ' ''<left>
inoremap " ""<left>

" run test
nnoremap ;t :write\|!pytest<cr><cr>
" interactive run
nnoremap ;i :write\|!start cmd /C "python -i "%""<cr><cr>

let g:py_executable="python"
" nnoremap ;2 :python switch_to_python2()<cr>
" nnoremap ;3 :python switch_to_python3()<cr>
nnoremap ;r :execute('write \| !start cmd /C "' . expand(g:py_executable) . ' "' . expand('%') . '" & pause"')<cr><cr>

" debugger
"python exec vimimport('debugger')
"nnoremap ;b :python debugger.debugger.toggle_breakpoint()<cr>
"nnoremap ;d :python debugger.debugger.toggle()<cr>
"highlight breakpoint guibg=darkred

"
python exec vimimport('py')

python << endpython
#vimpy.command['run'].set('write', '!start cmd /C "python \"%\"" & pause<cr>')
word = lambda text: (text, '((.*\W)|^)(\w+)$', 3)
keyword = lambda text: (text, '\s*({0})$'.format(text), 1)

def switch_to_python2():
    word, = switch_to_python3.context
    vim.command('let g:py_executable="python"')
    vimpy.completer.added = False
    vimpy.completer.add(word('p'), '\<bs>print ')
    vimpy.completer.added = True
    print 'Switched to Python2'
switch_to_python2.context = (word,)

def switch_to_python3():
    word, = switch_to_python3.context
    vim.command('let g:py_executable=expand("$python3")')
    vimpy.completer.added = False
    vimpy.completer.add(word('p'), '\<bs>print()\<left>')
    vimpy.completer.added = True
    print 'Switched to Python3'
switch_to_python3.context = (word,)

if not vimpy.completer.added:
    # keywords
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
    vimpy.completer.add(word('p'), '\<bs>print()\<left>')
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
    vimpy.completer.add(word('su'), '\<bs>\<bs>subprocess')
    
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
" define async function
inoremap ;ds <esc>:python py.defineFunction(async_func=True)<cr>
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
" flask
inoremap ;fi from flask import Flask<cr>
    \<cr>
    \app = Flask(__name__)<cr>
    \<cr>
    \@app.route('/')<cr>
    \def index():<cr>
    \return 'hello world'<cr>
    \<cr>
    \if __name__ == '__main__':<cr>
    \app.run(host='0.0.0.0', port=6560, threaded=True, debug=True)<esc>
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
inoremap ;fl from flask import *<cr>
    \<cr><cr>
    \app = Flask(__name__)<cr>
    \<cr><cr>
    \@app.after_request<cr>
    \def after_request(r):<cr>
    \r.headers['Cache-Control'] = 'no-cache'<cr>
    \return r<cr>
    \<cr><cr>
    \@app.route('/')<cr>
    \def index():<cr>
    \return 'hello world'<cr>
    \<cr><cr>
    \if __name__ == '__main__':<cr>
    \app.run(host='0.0.0.0', port=5000, threaded=True, debug=True)
    \<esc>?hello<cr>

if !has('gui_running')
    nnoremap ;r :write\|!clear; python3.7 %<cr>
    nnoremap ;i :write\|!clear; python3.7 -i %<cr>
endif

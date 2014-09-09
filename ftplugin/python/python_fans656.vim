set tabstop=4
set shiftwidth=4
set expandtab

" pair
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap ' ''<left>
inoremap " ""<left>

inoremap sf self

python exec vimimport('py')

python << endpython
vimpy.command['run'].set('write', '!python %')

# completion
word = lambda text: (text, '((.*\W)|^)(\w+)$', 3)
# keywoards
py.completer.auto = True
py.completer.add(('if', '\s*(if)$', 1), ' :\<left>', auto=True)
py.completer.add(('else', '\s*(else)$', 1), ':\<cr>', auto=True)
py.completer.add(word('elif'), ' :\<left>', auto=True)
py.completer.add(word('none'), '\<bs>'*4 + 'None', auto=True)
py.completer.add(word('true'), '\<bs>'*4 + 'True', auto=True)
py.completer.add(word('false'), '\<bs>'*5 + 'False', auto=True)

py.completer.hotkey = '<c-f>'
py.completer.add(word('f'), '\<bs>from ')
py.completer.add(word('i'), '\<bs>import ')
py.completer.add(word('p'), '\<bs>print ')
py.completer.add(word('e'), '\<bs>except ')
py.completer.add(word('r'), '\<bs>return ')
py.completer.add(word('ri'), '\<bs>raise ')
py.completer.add(word('ps'), '\<bs>\<bs>pass')

# exceptions
py.completer.add(word('ie'), '\<bs>\<bs>IndexError')
py.completer.add(word('ke'), '\<bs>\<bs>KeyError')
py.completer.add(word('ve'), '\<bs>\<bs>ValueError')
py.completer.add(word('si'), '\<bs>\<bs>StopIteration')
py.completer.add(word('ex'), '\<bs>\<bs>Exception')

py.completer.add(word('eie'), '\<bs>\<bs>\<bs>except IndexError:\<cr>')
py.completer.add(word('eke'), '\<bs>\<bs>\<bs>except KeyError:\<cr>')
py.completer.add(word('eve'), '\<bs>\<bs>\<bs>except ValueError:\<cr>')
py.completer.add(word('esi'), '\<bs>\<bs>\<bs>except StopIteration:\<cr>')
py.completer.add(word('eex'), '\<bs>\<bs>\<bs>except Exception:\<cr>')

# others
py.completer.add(word('ii'), '\<bs>'*2 + 'isinstance(, )' + '\<left>'*3)
py.completer.add(word('pro'), '\<bs>'*3 + 'property')
py.completer.add(word('set'), '\<bs>'*3 + 'setter')
py.completer.add(word('main'), '\<bs>'*4 + r"if __name__ == '__main__':\<cr>")
py.completer.add(word('doc'), '\<bs>'*3 + '"""\<cr>"""\<esc>O\<space>\<space>')

del word
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

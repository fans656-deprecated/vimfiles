inoremap ' ''<left>
inoremap " ""<left>
inoremap <m-O> <c-o>O
python << endpython
vimpy.command['run'].set('write', r'silent !{}\t.html'.format(
    vim.eval('expand("%:p:h")')))

if not vimpy.completer.added:
    # completion
    word = lambda text: (text, '((.*\W)|^)(\w+)$', 3)
    keyword = lambda text: (text, '(^|(^\S* ))({})$'.format(text), 3)
    # keywoards
    vimpy.completer.auto = True
    #vimpy.completer.add(keyword('if'), ' () {\<cr>}\<up>\<c-right>\<right>', auto=True)
    vimpy.completer.add(keyword('else'), ' {\<cr>}\<esc>O', auto=True)
    vimpy.completer.add(keyword('for'), ' () {\<cr>}\<esc>kf(a', auto=True)

    vimpy.completer.hotkey = '<c-f>'
    vimpy.completer.add(word('r'), '\<bs>return ;\<left>')
    vimpy.completer.add(word('f'), '\<bs>function')
    vimpy.completer.add(word('d'), '\<bs>document')
    vimpy.completer.add(word('wl'), '\<c-w>document.writeln();\<left>\<left>')
    vimpy.completer.add(word('lg'), '\<c-w>console.log();\<left>\<left>')

    del word
    vimpy.completer.added = True
endpython

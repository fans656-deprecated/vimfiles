nnoremap ;r :write \| !start cmd /C "javac -cp . -encoding utf-8 % && java -cp . -Dfile.encoding=gbk %:r" & pause<cr><cr>

python << endpython
if not vimpy.completer.added:
    # completion
    word = lambda text: (text, '((.*\W)|^)(\w+)$', 3)
    vimpy.completer.hotkey = '<c-f>'
    vimpy.completer.add(word('p'), '\<bs>System.out.println();\<left>\<left>')
    #vimpy.completer.add(word('f'), '\<bs>function')
    #vimpy.completer.add(word('d'), '\<bs>document')
    #vimpy.completer.add(word('wl'), '\<c-w>document.writeln();\<left>\<left>')
    #vimpy.completer.add(word('lg'), '\<c-w>console.log();\<left>\<left>')
    del word
    vimpy.completer.added = True
endpython

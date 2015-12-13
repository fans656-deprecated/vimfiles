from vimimport import vimimport
exec vimimport('vimpy', '*')

def include():
    line.split().wrap('#include <{0}>\n').update()

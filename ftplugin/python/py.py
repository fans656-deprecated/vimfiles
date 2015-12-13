import re

import vim

import vimpy

TAB_WIDTH = 4

# TODO: Token.parse()
class Token(object):

    def __init__(self, cursor=None):
        if not cursor:
            cursor = vimpy.Cursor()
        self.cursor = cursor.clone
        self.parse()

    def parse(self):
        match = lambda pattern: re.match(patter, self.cursor.char)
        if match('\w'):
            pass
        elif match('\s'):
            pass
        elif match('[,.]'):
            pass

    @property
    def next(self):
        return Token(self.end.right)

    @property
    def prev(self):
        return Token(self.beg.left)

class Line(vimpy.Line):

    @property
    def indentLevel(self):
        s = re.search('^\s*', self.text).group(0)
        return len(s) // TAB_WIDTH

    @property
    def indentation(self):
        return ' ' * TAB_WIDTH * self.indentLevel

    @property
    def inclass(self):
        for line in map(Line, reversed(range(vimpy.currow()))):
            if line.blank:
                continue
            if line.indentLevel < self.indentLevel:
                if line.text.startswith('class'):
                    return True
                if line.indentLevel == 0:
                    break
        return False

    def split(self, sep=None):
        t = self.text.split(sep)
        return t[0], t[1:]

def defineClass(withbody=False):
    line = Line()
    name, parents = line.split()
    if not parents:
        parents = ['object']

    line.text = '{indent}class {name}({bases}):'.format(
            indent=line.indentation,
            name=name,
            bases=', '.join(parents))
    vimpy.feed('A')
    if withbody:
        vimpy.feed(' pass')
    else:
        vimpy.feed('\<cr>\<cr>')

def defineFunction(withbody=False, underscore=False):
    line = Line()
    name, args = line.split()
    if underscore:
        name = '__{0}__'.format(name)
    # TODO:
    # class Foo:
    #     def f(self): <- because inside a class
    #         def g(a, b): <- because inside a function
    if line.inclass:
        args = ['self'] + args

    line.text = '{indent}def {name}({args}):'.format(
            indent=line.indentation,
            name=name,
            args=', '.join(args))
    vimpy.feed('A\<cr>')
    if withbody:
        vimpy.feed('pass')

def assignToSelf():
    line = Line()
    vs = line.text.split()
    f = lambda var: '{indent}self.{var} = {var}'.format(
            indent=line.indentation, var=var)
    lines = map(f, vs)
    line.text = lines
    vimpy.feed('{0}jo'.format(len(lines) - 1))

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

    def splitByCol(self, col=None, exclusive=False):
        if col is None:
            col = self.col
        col += exclusive
        text = self.text
        return text[:col], text[col:]

class LineMatcher(object):

    class Checker(object):

        def __init__(self, target, extractor=None, groupindex=None):
            if isinstance(target, tuple):
                target, extractor, groupindex = target
            self.target = target
            self.extractor = extractor
            self.groupindex = groupindex

        def check(self, text):
            if self.extractor:
                try:
                    text = re.match(self.extractor, text).group(self.groupindex)
                except AttributeError:
                    return False
                return text == self.target
            else:
                return re.match(self.target, text)

    def __init__(self, left, right, action=None):
        if not action:
            right, action = '', right
        self.checkers = map(LineMatcher.Checker, (left, right))
        self.action = action

    def match(self, line):
        return all(c.check(t) for c, t in zip(self.checkers, line.splitByCol()))

    @property
    def matched(self):
        return self.match(Line())

class Completer(object):

    def __init__(self):
        self.hotkey_ = None
        self.autos = []
        self.manus = []
        self.added = False

    @property
    def auto(self):
        return self.auto_

    @auto.setter
    def auto(self, on):
        self.auto_ = on
        if on:
            vimpy.command('autocmd CursorMovedI *.py call FeedPythonPrints("py.completer.complete(auto=True)")')

    @property
    def hotkey(self):
        return self.hotkey_

    @hotkey.setter
    def hotkey(self, key):
        if self.hotkey:
            vimpy.command('silent! iunmap {}'.format(self.hotkey))
        self.hotkey_ = key
        vimpy.command('inoremap {} <c-r>=InsertPythonPrints("py.completer.complete()")<cr>'.format(self.hotkey))

    def add(self, patternBefore, patternAfter, action=None, auto=False):
        if self.added:
            return
        m = LineMatcher(patternBefore, patternAfter, action)
        if auto:
            self.autos.append(m)
        else:
            self.manus.append(m)

    def complete(self, auto=False):
        matchers = self.autos if auto else self.manus
        for m in matchers:
            if m.matched:
                print m.action

completer = Completer()

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
        name = '__{}__'.format(name)
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
    vimpy.feed('{}jo'.format(len(lines) - 1))

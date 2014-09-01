import re
from collections import OrderedDict

class Line:

    def __init__(self, text, row):
        self.text = text
        self.row = row
        self.line = text[row]

    def isClass(self):
        return (self.line.startswith('class')
                and not self.line.endswith(';'))

    def isMethod(self):
        pass

    def isStatement(self):
        return self.line.endswith(';')

    def isFunction(self):
        pass

class Method:

    class NotMethod: pass

    def parse(self):
        self.indexes = {}

        def findArgsRightParen(s):
            i = s.rfind(')')
            if i == -1:
                raise Method.NotMethod()
            else:
                self.indexes['args right paren'] = i
                return i

        def findArgsLeftParen(s, iRightParen):
            count = 1
            for i in reversed(range(iRightParen)):
                if s[i] == ')':
                    count += 1
                elif s[i] == '(':
                    count -= 1
                    if count == 0:
                        self.indexes['args left paren'] = i
                        return i
            raise Method.NotMethod()

        def getName(s, iLeftParen):
            m = re.search('((operator.*)|(~?\w+))\(', s[:iLeftParen+1])
            return m.group(2) or m.group(3)

        def getArgs(s):
            # todo: parens in default parameters
            s = re.sub('( = [^,]*)(?=[,)])', '', s)
            return s[:-1]

        def getRet(s, name, iLeftParen):
            i = iLeftParen - len(name)
            return s[:i]

        s = self.line.line
        irp = findArgsRightParen(s)
        ilp = findArgsLeftParen(s, irp)
        self.name = getName(s, ilp)
        self.ret = getRet(s, self.name, ilp)
        self.args = getArgs(s[ilp+1:irp+1])
        self.modifier = s[irp+1:]

    def __repr__(self):
        return '{ret}{classname}::{name}({args}){modifier}'.format(
                ret=self.ret,
                classname=self.classname,
                name=self.name,
                args=self.args,
                modifier=self.modifier)

class MethodDeclaration(Method):

    def __init__(self, line, classname):
        # remove semicolon
        line.line = line.line[:-1]
        # init
        self.line = line
        self.classname = classname
        self.parse()

class Class:

    def __init__(self, line):
        self.text = line.text
        self.row = line.row
        self.rowNumbers = {}
        self.methods = OrderedDict()
        self.parse()

    def parse(self):
        self.parseTemplate()
        self.parseName()
        self.parseMethods()

    def parseTemplate(self):
        row = self.row - 1
        line = self.text[row]
        if line.startswith('template'):
            self.isTemplate = True
            self.rowNumbers['template'] = row
            self.rowNumbers['beg'] = row
        else:
            self.isTemplate = False

    def parseName(self):
        row = self.row
        line = self.text[row]
        self.name = re.match('class (\w+).*', line).group(1)
        self.rowNumbers['name'] = row
        if 'template' not in self.rowNumbers:
            self.rowNumbers['beg'] = row

    def parseMethods(self):

        def isfinished(row):
            if self.text[row].startswith('}'):
                self.rowNumbers['end'] = row + 1
                return True
            else:
                return False

        row = self.row + 2
        while not isfinished(row):
            line = Line(self.text, row)
            if line.isStatement():
                try:
                    method = MethodDeclaration(line, self.name)
                    self.methods[method.name] = method
                except Method.NotMethod:
                    pass
            row += 1

    def getline(self, key):
        row = self.rowNumbers[key]
        return self.text[row]

class Parser:

    def __init__(self, text):
        self.text = [line.strip() for line in text]
        self.classes = {}
        self.row = 0
        self.finished = False

    def parse(self):
        while not self.finished:
            line = self.nextLine()
            if line.isClass():
                cls = Class(line)
                self.classes[cls.name] = cls
            elif line.isMethod():
                pass
            elif line.isFunction():
                pass

    def nextLine(self):
        line = Line(self.text, self.row)
        self.row += 1
        if self.row == len(self.text):
            self.finished = True
        return line

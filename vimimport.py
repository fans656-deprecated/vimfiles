import sys
from os.path import dirname, join, normpath, basename

import vim

def vimimport(module, symbols=None):
    """
    Get a python statement to import modules:
        # foo.py in current directory
        exec vimimport('foo')
        # foo.py in parent directory and alias
        exec vimimport('../foo as fo')
        # symbols
        exec vimimport('foo', '*')
        exec vimimport('foo', 'bar, baz')
    """
    
    def getModulePathAndAlias(path):
        # maybe 'foo as fo'
        names = path.split(' as ')
        # 'foo as fo'
        if len(names) == 2:
            path, alias = names
        # 'foo'
        else:
            path, alias = names[0], None
        return path, alias
    
    def getModuleDirAndName(path):
        # module path is specified relatively
        # to the current script's directory
        cur = vim.eval('expand("<sfile>:p:h")')
        dire = normpath(join(cur, dirname(path)))
        name = basename(path)
        return dire, name

    def makeImportStatement(name, alias, symbols):
        if alias:
            stmt = 'import {} as {}'.format(name, alias)
        else:
            stmt = 'import {}'.format(name)
        if symbols:
            stmt += '; from {} import {}'.format(name, symbols)
        stmt += '; del sys.path[0]'
        return stmt

    path, alias = getModulePathAndAlias(module)
    dire, name = getModuleDirAndName(path)
    sys.path.insert(0, dire)
    stmt = makeImportStatement(name, alias, symbols)
    return 'import sys; ' + stmt

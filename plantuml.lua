-- plantUML LPeg lexer.

local l = require('lexer')
local token, word_match = l.token, l.word_match
local P, R, S = lpeg.P, lpeg.R, lpeg.S

local M = {_NAME = 'plantuml'}

-- Whitespace.
local whitespace = token(l.WHITESPACE, l.space^1)


-- Delimiters.
local braces = token(l.KEYWORD, S('{}'))
local brackets = token(l.VARIABLE, S('[]'))

-- Keywords.
local keyword = token(l.KEYWORD, word_match{
  '<|--', '*--', 'o--', '<--', '<..', '<|..', '<--*', '<-',
  '#--', 'x--', '}--', '+--', '^--', '()--', '()-',
  '--|>', '--+', '--o', '-->', '..>', '..|>', '*-->', '->',
  '--#', '--x', '--{', '--+', '--^', '--()', '-()',
   '--', '..', '<<', '>>',
  '@startuml', '@enduml', '@unlinked',
  'skinparam', 'note', 'left', 'right', 'top', 'link', 'up', 'down',
  'hide', 'show', 'empty', 'members', 'fields', 'attributes', 'methods', 'as'
})

-- Functions.
local func = token(l.FUNCTION, word_match{
  'abstract', 'annotation', 'circle', 'class', 'diamond', 'entity', 'enum',
  'exception', 'interface', 'metaclass', 'protocol', 'stereotype', 'struct'
})

-- Identifiers
local identifier = token(l.IDENTIFIER, l.word)

-- Strings.
local string = token(l.STRING, l.delimited_range('"'))


-- Comment.
local comment = token(l.COMMENT, "'" * l.nonnewline^0)

M._rules = {
  {'whitespace', whitespace},
  {'comment', comment},
  {'braces', braces},
  {'keyword', keyword},
  {'function', func},
  {'string', string},
  {'brackets', brackets},
  {'variable', identifier},
}

M._foldsymbols = {
  _patterns = {'[{}]', '#'},
  [l.KEYWORD] = {['{'] = 1, ['}'] = -1},
  [l.COMMENT] = {["'"] = l.fold_line_comments("'")}
}

return M

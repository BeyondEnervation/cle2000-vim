" Vim syntax file
" Language: CLE-2000
" Maintainer: Luis J. W. Fernandes
" Adapted from the CLE-2000 VS Code grammar by Charles Bienvenue:
" https://github.com/CBienvenue/cle2000-vscode
" Upstream license: MIT

" Installation:
"   Put this file at ~/.vim/syntax/cle2000.vim
"   Put the ftplugin file at ~/.vim/ftplugin/cle2000.vim
"   Put the ftdetect file at ~/.vim/ftdetect/cle2000.vim
"   For Neovim use ~/.config/nvim/...

if exists('b:current_syntax')
    finish
endif

syn case ignore

" -----------------------------------------------------------------------------
" Top-level code container
" -----------------------------------------------------------------------------
" Make strings contained so they can only appear inside real code regions,
" preventing stray quotes inside comments from starting strings during resync.
syn region cle2000Code start=/\%1l\%1c/ end=/\%$/ transparent keepend contains=cle2000Comment,cle2000CommentBlock,cle2000StringSingle,cle2000StringDouble,cle2000Number,cle2000Float,cle2000Boolean,cle2000DollarIdent,cle2000Type,cle2000Assign,cle2000Shift,cle2000RelOp,cle2000Operator,cle2000OperatorWord,cle2000Conversion,cle2000Keyword,cle2000Label,cle2000Terminator,cle2000Illegal,cle2000ModuleBlock

" -----------------------------------------------------------------------------
" Comments
" -----------------------------------------------------------------------------
" Full-line star comments only when '*' is in column 1.
syn match cle2000Comment /^\*.*/ contains=@Spell containedin=ALL display

" Bang-to-end-of-line comments
syn match cle2000Comment /!.*/ contains=@Spell containedin=ALL display

" Block comments: (* ... *)
syn region cle2000CommentBlock start="(\*" end="\*)" keepend contains=@Spell

" -----------------------------------------------------------------------------
" Invalid / punctuation
" -----------------------------------------------------------------------------
" Illegal semicolon when not preceded by whitespace at non-start positions
syn match cle2000Illegal /\%(^\s*\)\@<!\S;/

" Statement terminator
syn match cle2000Terminator /;/

" -----------------------------------------------------------------------------
" Strings
" -----------------------------------------------------------------------------
" Strings are contained so they only start inside code regions that allow them.
syn region cle2000StringSingle start=+'+ skip=+''+ end=+'+ keepend contained
syn region cle2000StringDouble start=+"+ skip=+""+ end=+"+ keepend contained

" -----------------------------------------------------------------------------
" Numbers
" -----------------------------------------------------------------------------
syn match cle2000Number /\<[+-]\=\d\+\>/
syn match cle2000Float /\<[+-]\=\(\d*\.\d\+\|\d\+\.\d*\)\([Ee][+-]\=\d\+\)\=\>/
syn match cle2000Float /\<[+-]\=\(\d*\.?\d\+\|\d\+\.?\d*\)\([Dd][+-]\=\d\+\)\>/
syn match cle2000Float /\<[+-]\=\(\d\+\.\d*\|\.\d\+\|\d\+\)\([eEdD][+-]\=\d\+\)\=\>/

" -----------------------------------------------------------------------------
" Booleans, variables, and types
" -----------------------------------------------------------------------------
syn keyword cle2000Boolean TRUE FALSE
syn match cle2000Boolean /\$True_L\>/
syn match cle2000Boolean /\$False_L\>/
syn match cle2000DollarIdent /\$[_A-Za-z][_A-Za-z0-9]\{0,11}\>/
syn keyword cle2000Type DOUBLE INTEGER LOGICAL REAL STRING

" -----------------------------------------------------------------------------
" Operators
" -----------------------------------------------------------------------------
syn match cle2000Assign /:=/
syn match cle2000Shift /<<\|>>/
syn match cle2000RelOp /<=\|>=\|<>\|<\|>\|=/
" Exclude a leading '*' only in column 1 so true column-1 comments win.
syn match cle2000Operator /\%(^\*\)\@<!\*\*\|\%(^\*\)\@<![+\-*/]/
syn keyword cle2000OperatorWord COS SIN TAN ABS ARCCOS ARCSIN ARCTAN CHS EXP LN NOT SQRT
syn keyword cle2000Conversion R_TO_I D_TO_I I_TO_R D_TO_R I_TO_D R_TO_D

" -----------------------------------------------------------------------------
" Control keywords and declarations
" -----------------------------------------------------------------------------
syn keyword cle2000Keyword PROCEDURE EVALUATE ECHO IF THEN ELSEIF ELSE ENDIF
syn keyword cle2000Keyword REPEAT UNTIL WHILE DO ENDWHILE QUIT
syn keyword cle2000Keyword PARAMETER MODULE LINKED_LIST XSM_FILE SEQ_BINARY SEQ_ASCII

" -----------------------------------------------------------------------------
" Labels
" -----------------------------------------------------------------------------
syn match cle2000Label /\<[A-Za-z][A-Za-z0-9-]*:/

" -----------------------------------------------------------------------------
" Module block support: :: ... ;
" -----------------------------------------------------------------------------
syn region cle2000ModuleBlock start=/::/ end=/\ze;/ keepend contains=cle2000Comment,cle2000CommentBlock,cle2000ModuleInput,cle2000ModuleOutput,cle2000ModuleLabel,cle2000ModuleKeyword,cle2000StringSingle,cle2000StringDouble,cle2000Number,cle2000Float,cle2000Boolean,cle2000DollarIdent,cle2000Type,cle2000Assign,cle2000Shift,cle2000RelOp,cle2000Operator,cle2000OperatorWord,cle2000Conversion,cle2000Keyword

syn region cle2000ModuleInput start=/>>/ end=/<</ keepend contained contains=ALLBUT,cle2000ModuleBlock
syn region cle2000ModuleOutput start=/<</ end=/>>/ keepend contained contains=ALLBUT,cle2000ModuleBlock
syn match cle2000ModuleLabel /\%(^\|\s\)\zs[A-Za-z][A-Za-z0-9_-]*:/ contained
syn match cle2000ModuleKeyword /\%(^\| \)\zs[A-Za-z][A-Za-z0-9_-]*\([+-:]\)\=/ contained

" -----------------------------------------------------------------------------
" Synchronization
" -----------------------------------------------------------------------------
syn sync minlines=200
syn sync maxlines=500

" -----------------------------------------------------------------------------
" Highlight links
" -----------------------------------------------------------------------------
hi def link cle2000Comment Comment
hi def link cle2000CommentBlock Comment
hi def link cle2000Illegal Error
hi def link cle2000Terminator Delimiter
hi def link cle2000StringSingle String
hi def link cle2000StringDouble String
hi def link cle2000Number Number
hi def link cle2000Float Float
hi def link cle2000Boolean Boolean
hi def link cle2000DollarIdent Identifier
hi def link cle2000Type Type
hi def link cle2000Assign Operator
hi def link cle2000Shift Operator
hi def link cle2000RelOp Operator
hi def link cle2000Operator Operator
hi def link cle2000OperatorWord Operator
hi def link cle2000Conversion Operator
hi def link cle2000Keyword Keyword
hi def link cle2000Label Label
hi def link cle2000ModuleBlock Statement
hi def link cle2000ModuleInput Special
hi def link cle2000ModuleOutput Special
hi def link cle2000ModuleLabel Label
hi def link cle2000ModuleKeyword Keyword

let b:current_syntax = 'cle2000'

section .text

; struct lexer
;   .cnt    0
;   .expr*  8

global lex
lex:            ; (rdi: expr*, rsi: cnt)

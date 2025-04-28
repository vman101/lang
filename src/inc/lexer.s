%define LEX_EXPR_CNT    0
%define LEX_VAR_CNT     4
%define LEX_EXPR        8
%define LEX_VAR         16
%define LEX_OUT         24

%define LEX_SIZE    32

%define VAR_NAME 0
%define VAR_OFFS 8
%define VAR_SIZE 16

; struct var
;   .name*      0
;   .stack_off  8

; struct lexer
;   .expr_cnt   0
;   .var_cnt    4
;   .expr*      8
;   .vars       16
;   .output**   24

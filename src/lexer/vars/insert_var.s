%include "./src/inc/token.s"

section .data

    INST_MOV: db "    mov ", 0
    INST_ADD: db "    add ", 0
    INST_SUB: db "    sub ", 0
    INST_XOR: db "    xor ", 0

    OPEN_STACK_VAR: db "[rbp-", 0
    CLOSE_STACK_VAR: db "]", 0
    SEP_INST: db ", ", 0

section .text
    extern putstr
    extern putnumber
    extern putnumberendl
    extern putchar
    extern putendl
    extern VAL_CONST
    extern VAL_VAR
    extern VAL_OP_ADD
    extern VAL_OP_SUB
    extern VAL_OP_LOAD
    extern VAL_FUNC
    extern REG_RAX
    extern REG_RDI

global insert_xor
insert_xor:
    mov rdi, INST_XOR
    call putstr
    ret

global insert_mov
insert_mov:
    mov rdi, INST_MOV
    call putstr
    ret

global insert_add
insert_add:
    mov rdi, INST_ADD
    call putstr
    ret

global insert_sub
insert_sub:
    mov rdi, INST_SUB
    call putstr
    ret

global xor_reg
xor_reg:               ; rdi: char*
    push rbx
    mov rbx, rdi

    call insert_xor

    mov rdi, rbx
    call putstr

    mov rdi, SEP_INST
    call putstr

    mov rdi, rbx
    call putendl

    pop rbx
    ret

global load_reg_var
load_reg_var:           ; (rdi: OFF_S, rsi: REG*)
    push rsi
    push rdi
    call insert_mov

    pop rdi
    call insert_var

    mov rdi, SEP_INST
    call putstr

    pop rdi
    call putendl

    ret

global load_const_reg
load_const_reg:           ; (rdi: const*, rsi: REG*)
    push rdi
    push rsi

    call insert_mov

    pop rdi
    call putstr

    mov rdi, SEP_INST
    call putstr

    pop rdi
    call insert_const_endl

    ret

global load_var_reg
load_var_reg:           ; (rdi: OFF_S, rsi: REG*)
    push rdi
    push rsi

    call insert_mov

    pop rdi
    call putstr

    mov rdi, SEP_INST
    call putstr

    pop rdi
    call insert_var_endl

    ret

global load_rax_var
load_rax_var:           ; (rdi: OFF_S)
    push rdi
    call insert_mov

    pop rdi
    call insert_var

    mov rdi, SEP_INST
    call putstr

    mov rdi, REG_RAX
    call putendl

    ret

global load_var_rax
load_var_rax:           ; (rdi: OFF_S)
    push rdi
    call insert_mov

    mov rdi, REG_RAX
    call putstr

    mov rdi , SEP_INST
    call putstr

    pop rdi
    call insert_var_endl

    mov rdi, '\n'
    call putchar

    ret

global op_const_rax
op_const_rax:          ; (rdi: char *, rsi: op)
    push rdi

    cmp rsi, TOK_SUB
    je .sub
    jmp .add
.sub:
    call insert_sub
    jmp .done
.add:
    call insert_add

.done:
    mov rdi, REG_RAX
    call putstr

    mov rdi, SEP_INST
    call  putstr

    pop rdi
    call putendl

    ret

global op_var_rax
op_var_rax:          ; (rdi: OFF_S, rsi: op)
    push rdi

    cmp rsi, TOK_SUB
    je .sub
    jmp .add
.sub:
    call insert_sub
    jmp .done
.add:
    call insert_add
.done:

    mov rdi, REG_RAX
    call putstr

    mov rdi, SEP_INST
    call  putstr

    pop rdi
    call insert_var_endl

    ret

global sub_var_rax
sub_var_rax:            ; (rdi: OFF_S)
    push rdi
    call insert_sub

    mov rdi, REG_RAX
    call putstr

    mov rdi , SEP_INST
    call putstr

    pop rdi
    call insert_var_endl

    ret

global add_rax_var
add_rax_var:            ; (rdi: OFF_S)
    push rdi
    call insert_add

    pop rdi
    call insert_var

    mov rdi , SEP_INST
    call putstr

    mov rdi, REG_RAX
    call putendl

    ret

global sub_rax_var
sub_rax_var:            ; (rdi: OFF_S)
    push rdi
    call insert_sub

    pop rdi
    call insert_var

    mov rdi , SEP_INST
    call putstr

    mov rdi, REG_RAX
    call putendl

    ret

insert_const_endl:             ; (rdi: const*)
    push rdi
    call putendl
    pop rdi

    ret

insert_var_endl:             ; (rdi: OFF_S)
    push rdi
    mov rdi, OPEN_STACK_VAR
    call putstr

    pop rdi
    call putnumber

    mov rdi, CLOSE_STACK_VAR
    call putendl

    ret

global insert_var
insert_var:             ; (rdi: OFF_S)
    push rdi
    mov rdi, OPEN_STACK_VAR
    call putstr

    pop rdi
    call putnumber

    mov rdi, CLOSE_STACK_VAR
    call putstr

    ret

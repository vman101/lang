%include "./src/inc/token.s"
%include "./src/inc/c_alignment.s"


section .data

    INST_MOV: db "    mov ", 0
    INST_ADD: db "    add ", 0
    INST_SUB: db "    sub ", 0
    INST_XOR: db "    xor %s, %s", 0x0a, 0

    OPERAND_PAIR_CONST_REG: db "%s, %s", 0x0a, 0
    OPERAND_PAIR_CONST: db "%s, %s", 0x0a, 0
    OPERAND_PAIR_REG_VAR: db "[rbp-%d], %s", 0x0a, 0
    OPERAND_PAIR_VAR_REG: db "%s, [rbp-%d]", 0x0a, 0

    LOAD_REG_VAR: db "    mov [rbp-%d], %s", 0x0a, 0
    LOAD_VAR_REG: db "    mov %s, [rbp-%d]", 0x0a, 0
    LOAD_CONST_REG: db "    mov %s, %s", 0x0a, 0

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

    extern ft_fprintf

    extern fd_out

global insert_add
insert_add:
    mov rdi, [fd_out]
    mov rsi, INST_ADD

    c_call ft_fprintf

    ret

global insert_sub
insert_sub:
    mov rdi, [fd_out]
    mov rsi, INST_SUB

    c_call ft_fprintf

    ret

global xor_reg
xor_reg:               ; rdi: char*
    push rbx
    mov rbx, rdi

    mov rdi, [fd_out]
    mov rsi, INST_XOR
    mov rdx, rbx
    mov rcx, rbx

    c_call ft_fprintf

    pop rbx
    ret

global load_var_reg
load_var_reg:           ; (rdi: OFF_S, rsi: REG*)
    push rsi
    push rdi
    mov rdi, [fd_out]
    mov rsi, LOAD_VAR_REG
    pop rcx
    pop rdx

    c_call ft_fprintf
    ret

global load_reg_var
load_reg_var:           ; (rdi: OFF_S, rsi: REG*)
    push rsi
    push rdi
    mov rdi, [fd_out]
    mov rsi, LOAD_REG_VAR
    pop rdx
    pop rcx
    c_call ft_fprintf
    ret

global load_const_reg
load_const_reg:           ; (rdi: const*, rsi: REG*)
    push rdi
    push rsi

    mov rdi, [fd_out]
    mov rsi, LOAD_CONST_REG
    pop rdx
    pop rcx

    c_call ft_fprintf

    ret

global op_const_reg
op_const_reg:          ; (rdi: char *, rsi: op, rdx: reg*)
    push rdi
    push rdx

    cmp rsi, TOK_SUB
    je .sub
    jmp .add
.sub:
    call insert_sub
    jmp .done
.add:
    call insert_add

.done:
    pop rdx
    pop rcx

    mov rdi, [fd_out]
    mov rsi, OPERAND_PAIR_CONST_REG

    c_call ft_fprintf

    ret

global op_var_reg
op_var_reg:          ; (rdi: OFF_S, rsi: op, rdx: reg)
    push rdi
    push rdx

    cmp rsi, TOK_SUB
    je .sub
    jmp .add
.sub:
    call insert_sub
    jmp .done
.add:
    call insert_add
.done:

    pop rdx
    pop rcx

    mov rdi, [fd_out]
    mov rsi, OPERAND_PAIR_VAR_REG

    c_call ft_fprintf

    ret

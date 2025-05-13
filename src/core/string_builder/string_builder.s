%include "./src/core/string_builder/sb.s"

section .text
    extern malloc
    extern err_malloc

    extern memcpy
    extern strlen

global sb_new
sb_new:     ; rax: str*(rdi: char* || NULL, rsi: *hidden_copy_ptr)
    push rbx
    push rdi
    push rsi

    mov rbx, STRING_INIT_CAP
    xor r9, r9

    test rdi, rdi
    jz .alloc_string

    push rdi
    call strlen
    pop rdi
    mov r9, rax
    cmp r9, STRING_INIT_CAP
    jl .alloc_string

.calc_init_len:
    add rbx, STRING_INIT_CAP
    cmp r9, rbx
    jg .calc_init_len


.alloc_string:
    push rdi
    mov rdi, rbx
    call malloc
    test rax, rax
    jz err_malloc
    pop rdi

    pop rsi
    mov dword [rsi + STR_CAP], ebx
    mov dword [rsi + STR_LEN], r9d
    mov [rsi + STR_DATA], rax
    test r9, r9
    jz .done
    mov rdi, rax
    mov rdx, r9
    pop rsi
    call memcpy

.done:
    pop rbx
    ret

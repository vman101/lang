%include "./src/core/vector/vector.inc"

section .text
    extern malloc
    extern err_malloc
    extern memcpy

global vec_create
vec_create:         ; rax: vec* (rdi: member_size)
    push rbp
    mov rbp, rsp
    sub rsp, 16

    ; allocate vector ptr
    push rdi
    mov rdi, VEC_SIZE
    call malloc
    test rax, rax
    jz err_malloc

    pop rdi
    mov [rbp - 8], rax      ; store vec
    mov dword [rax + VEC_COUNT], 0
    mov dword [rax + VEC_CAP], VEC_DEFAULT_CAP
    mov dword [rax + VEC_MEMBER_SIZE], edi

    ; allocate initial vector capacity
    imul rdi, VEC_DEFAULT_CAP
    call malloc
    test rax, rax
    jz err_malloc

    mov rdi, [rbp - 8]
    mov [rdi + VEC_MEM], rax

    mov rax, rdi

    mov rsp, rbp
    pop rbp

    ret

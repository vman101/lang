%include "./src/core/vector/vector.inc"

section .text
    extern malloc
    extern err_malloc
    extern memcpy

global vec_push
vec_push:           ; (rdi: vec*, rsi: mem*)
    push rbp
    mov rbp, rsp
    sub rsp, 48

    mov eax, dword [rdi + VEC_COUNT]
    mov dword [rbp - 4], eax
    mov eax, dword [rdi + VEC_CAP]
    mov dword [rbp - 8], eax
    mov eax, dword [rdi + VEC_MEMBER_SIZE]
    mov dword [rbp - 12], eax

    mov [rbp - 24], rdi             ; store vec
    mov rax, [rdi + VEC_MEM]
    mov [rbp - 32], rax

    mov [rbp - 40], rsi

    mov eax, dword [rbp - 4]
    cmp eax, dword [rbp - 8]
    je .reallocate
.push:

    mov rsi, [rbp - 40]
    mov rdi, [rbp - 24]
    mov eax, dword [rdi + VEC_MEMBER_SIZE]
    imul eax, dword [rbp - 4]
    mov rdi, [rdi + VEC_MEM]
    add rdi, rax

    mov edx, dword [rbp - 12]
    call memcpy
    mov rdi, [rbp - 24]
    inc dword [rdi + VEC_COUNT]

.done:
    mov rsp, rbp
    pop rbp
    ret

.reallocate:
    imul eax, 2
    mov edi, eax
    push rax
    call malloc
    test rax, rax
    jz err_malloc

    mov rdi, rax
    mov rsi, [rbp - 32]
    mov edx, dword [rbp - 4]
    call memcpy
    pop rax
    mov rdx, [rbp - 24]
    mov [rdx + VEC_MEM], rdi
    mov dword [rdx + VEC_CAP], eax
    jmp .push

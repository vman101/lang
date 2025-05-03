%include "./src/core/vector/vector.inc"

section .text
    extern malloc
    extern err_malloc
    extern memcpy

%define vec_count       dword [rbp - 4]
%define vec_cap         dword [rbp - 8]
%define vec_member_size dword [rbp - 12]
%define vec_mem         [rbp - 20]

global vec_push
vec_push:           ; (rdi: vec*, rsi: mem*)
    push rbp
    mov rbp, rsp
    sub rsp, 48

    mov eax, [rdi + VEC_COUNT]
    mov vec_count, eax
    mov eax, [rdi + VEC_CAP]
    mov vec_cap, eax
    mov eax, [rdi + VEC_MEMBER_SIZE]
    mov vec_member_size, eax
    mov rax, [rdi + VEC_MEM]
    mov vec_mem, rax
    mov [rbp - 32], rdi             ; store vec

    mov [rbp - 40], rsi

    mov eax, vec_count
    cmp eax, vec_cap
    je .reallocate
.push:

    mov rsi, [rbp - 40]
    mov rdi, [rbp - 32]
    mov eax, dword [rdi + VEC_MEMBER_SIZE]
    imul eax, vec_count
    mov rdi, [rdi + VEC_MEM]
    add rdi, rax

    mov edx, vec_member_size
    call memcpy
    mov rdi, [rbp - 32]
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
    mov rsi, vec_mem
    mov edx, vec_count
    call memcpy
    pop rax
    mov rdx, [rbp - 32]
    mov [rdx + VEC_MEM], rdi
    mov dword [rdx + VEC_CAP], eax
    jmp .push

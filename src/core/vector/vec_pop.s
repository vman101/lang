%include "./src/core/vector/vector.inc"

section .text
    extern memset

%define vec_count       dword [rbp - 4]
%define vec_cap         dword [rbp - 8]
%define vec_member_size dword [rbp - 12]
%define vec_mem         [rbp - 20]

global vec_pop
vec_pop:       ; rax: bool (rdi: vec*)
    push rbp
    mov rbp, rsp
    sub rsp, 32
    push rbx

    mov eax, dword [rdi + VEC_COUNT]
    test eax, eax
    jz .done

    mov vec_count, eax
    mov eax, dword [rdi + VEC_MEMBER_SIZE]
    mov vec_member_size, eax
    mov rax, qword [rdi + VEC_MEM]
    mov vec_mem, rax

    push rdi

    mov ebx, vec_member_size
    imul ebx, vec_count
    sub ebx, vec_member_size

    mov rdi, vec_mem
    add rdi, rbx
    mov rsi, 0
    mov edx, vec_member_size
    call memset

    pop rdi
    dec dword [rdi + VEC_COUNT]

.done:
    pop rbx
    mov rsp, rbp
    pop rbp
    ret

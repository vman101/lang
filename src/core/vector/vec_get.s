%include "./src/core/vector/vector.inc"

section .text
    extern memcpy

global vec_get
vec_get:        ; rax: bool (rdi: vec*, rsi: dest*, rdx: idx)
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov eax, dword [rdi + VEC_COUNT]

    cmp eax, edx
    jl .not_found

    push rsi
    mov rax, rdx

    mov rsi, [rdi + VEC_MEM]
    imul eax, dword [rdi + VEC_MEMBER_SIZE]
    add rsi, rax
    mov edx, dword [rdi + VEC_MEMBER_SIZE]

    pop rdi
    call memcpy
    mov rax, 1
    jmp .done

.not_found:
    xor rax, rax
.done:

    mov rsp, rbp
    pop rbp
    ret

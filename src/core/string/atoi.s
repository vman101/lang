section .text
    extern strlen

atoi:       ; rax: int (rdi: str*)
    push rbp
    mov rbp, rsp
    sub rsp, 16
    xor rax, rax
    xor rcx, rcx
    push rdi
    call strlen
    mov [rbp - 8], rax
.loop:
    
.done:

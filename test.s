section .text
    global _start
    extern putnumber

_start:
    push rbp
    mov rbp, rsp
    sub rsp, 16
xor rax, rax
add rax, 6
mov [rbp-8], rax
xor rax, rax
add rax, 5
sub rax, 2
add rax, 6
add rax, [rbp-8]
mov [rbp-16], rax
push rdi
mov rdi, [rbp-16]
call putnumber
pop rdi
    mov rsp, rbp
    pop rbp
    ret

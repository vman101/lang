%define SYS_FORK 57

section .text

global fork
fork:   ; rax: pid()
    mov rdi, SYS_FORK
    syscall
    ret

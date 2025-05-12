section .data
    usage:  db "Usage: ./debug <file>.lang", 0xa, 0

section .text
    global _start
    extern exit
    extern err_args
    extern get_file_content
    extern putstr
    extern lex
    extern vec_create
    extern vec_push
    extern vec_get
    extern putchar
    extern vec_pop

print_usage:
    mov rdi, usage
    call putstr

_start:
    pop rdi
    cmp rdi, 2
    jne err_args
    mov rdi, [rsp + 8]          ; argv[1]
    push rbp
    mov rbp, rsp

    sub rsp, 16

    call get_file_content
    mov rdi, rax
    mov [rbp - 8], rax

    mov rdi, rax
    call lex

    mov rsp, rbp
    pop rbp

done:
    xor rdi, rdi
    call exit

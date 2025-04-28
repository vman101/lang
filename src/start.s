section .data

    usage:  db "Usage: ./debug <file>.lang", 0xa, 0
section .text
    global _start
    extern exit
    extern split
    extern print_split
    extern putchar
    extern putstr
    extern putnumber
    extern open
    extern close
    extern read
    extern get_file_size
    extern malloc
    extern lseek
    extern read_file
    extern err_args
    extern putendl
    extern parse
    extern print_tokens
    extern err_malloc
    extern get_file_content
    extern create_expressions
    extern lex

print_usage:
    mov rdi, usage
    call putstr

_start:
    pop rdi
    cmp rdi, 2
    jne err_args
    mov rdi, [rsp + 8]      ; argv[1]
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

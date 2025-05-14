%include "./src/core/string_builder/sb.s"

section .data
    usage:  db "Usage: ./debug <file>.lang", 0xa, 0
    fd_out:     dd 0
    dot_s:      db ".s", 0

    global fd_out

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
    extern sb_new
    extern sb_append
    extern ft_fprintf
    extern ft_printf
    extern split
    extern ft_strjoin
    extern open

print_usage:
    mov rdi, usage
    call putstr

_start:
    ;push rbp
    ;mov rbp, rsp
    ;sub rsp, 16
    ;mov rdi, usage
    ;lea rsi, [rbp - 16]
    ;call sb_new
    ;
    ;lea rdi, [rbp - 16]
    ;mov rsi, example_data
    ;call sb_append
    ;mov al, 1
    ;mov rsi, 1
    ;mov rdi, qword [rbp - 16 + STR_DATA]
    ;call ft_printf

    pop rdi
    cmp rdi, 2
    jne err_args
    mov rdi, [rsp + 8]          ; argv[1]

    push rbp
    mov rbp, rsp

    sub rsp, 16

    ; store filename on stack
    mov [rbp - 16], rdi

    mov rsi, '.'
    call split

    mov rdi, rax
    mov rdi, [rdi]
    mov rsi, dot_s
    call ft_strjoin
    mov rdi, rax
    mov rsi, 0x241
    mov rdx, 0o644
    call open
    mov [fd_out], rax

    mov rdi, [rbp - 16]

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

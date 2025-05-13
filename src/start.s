%include "./src/core/string_builder/sb.s"

section .data
    usage:  db "Usage: ./debug <file>.lang", 0xa, 0
    example_data: db "Do you know Ligma?"

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

print_usage:
    mov rdi, usage
    call putstr


_start:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    mov rdi, usage
    lea rsi, [rbp - 16]
    call sb_new

    mov rdi, [rbp - 16 + STR_DATA]
    call putstr
    lea rdi, [rbp - 16]
    mov rsi, example_data
    call sb_append
    mov rdi, [rbp - 16 + STR_DATA]
    call putstr

;    pop rdi
;    cmp rdi, 2
;    jne err_args
;    mov rdi, [rsp + 8]          ; argv[1]
;    push rbp
;    mov rbp, rsp
;
;    sub rsp, 16
;
;    call get_file_content
;    mov rdi, rax
;    mov [rbp - 8], rax
;
;    mov rdi, rax
;    call lex
;
   mov rsp, rbp
   pop rbp

done:
   xor rdi, rdi
   call exit

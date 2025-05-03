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
    push rbp
    mov rbp, rsp
    sub rsp, 16

    mov rdi, 1
    call vec_create
    mov rdi, rax

    xor rcx, rcx
    mov rbx, 90
    mov r8, ' '

.loop:
    cmp rcx, rbx
    je .done
    push rcx
    push r8
    mov byte [rbp - 4], r8b
    lea rsi, [rbp - 4]
    push rdi
    call vec_push
    pop rdi
    pop r8
    pop rcx
    inc r8
    inc rcx
    jmp .loop
.done:
    push rdi
    call vec_pop
    pop rdi
    push rdi
    mov rdi, [rdi + 16]
    call putstr
    pop rdi
    lea rsi, [rbp - 1]
    mov rdx, 88
    call vec_get
    test rax, rax
    jz done

    mov dil, byte [rbp - 1]
    call putchar

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
;    mov rsp, rbp
;    pop rbp

done:
    xor rdi, rdi
    call exit

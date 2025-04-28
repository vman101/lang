
section .text
    global read_file
    extern err_lseek
    extern err_malloc
    extern malloc
    extern read
    extern lseek
    extern get_file_size

read_file:      ; rax: char * (rdi: int fd)
    push rbp
    mov rbp, rsp
    sub rsp, 32

    mov [rbp - 24], rdi          ; fd
    call get_file_size

    inc rax
    mov [rbp - 8], rax

    mov rdi, rax
    call malloc
    cmp rax, 0
    jz err_malloc

    mov [rbp - 16], rax

    mov rdi, [rbp - 24]
    mov rsi, 0
    mov rdx, 0
    call lseek

    cmp rax, 0
    jnz err_lseek

    mov rdi, [rbp - 24]
    mov rdx, [rbp - 8]
    mov rsi, [rbp - 16]
    call read

    mov byte [rsi + rax], 0

    mov rsp, rbp
    pop rbp

    mov rax, rsi
    ret

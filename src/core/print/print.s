
section .text
    extern strlen
    global putstr
    global putchar
    global print_split
    global putendl

print_split:        ; print_split(rdi: char **)
    xor rcx, rcx
.loop:
    cmp qword [rdi], 0
    je  .done
    push rdi
    mov r8, [rdi]
    mov rdi, r8
    push rcx
    call putendl
    pop rcx
    pop rdi
    add rdi, 8
    inc rcx
    jmp .loop
.done:
    mov rax, rcx
    ret

write:              ; RAX: int write(RDI: int fd, RSI: char *buf, RDX: size_t n)
    mov rax, 1      ; sys_write
    syscall
    ret

putchar:
    sub rsp, 16     ; create stack var
    mov [rsp], dil  ; move lower byte of tdi into stack
    mov rsi, rsp
    mov rdx, 1
    mov rdi, 1
    call write
    add rsp, 16
    ret

putstr:       ; print_string(RDI: char *string)
    call strlen

    mov rdx, rax    ; string length
    mov rsi, rdi    ; mov buffer
    mov rdi, 1      ; stdout

    call write

    ret

putendl:
    call putstr
    mov rdi, 0xa
    call putchar
    ret

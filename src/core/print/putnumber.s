global putnumber
global putnumberendl

section .text
    extern putchar

putnumberendl:
    call putnumber
    mov rdi, 0xa
    call putchar
    ret

putnumber:      ;   void put_number(RDI: int c)
    push rbx
    xor rcx, rcx

.start:
    inc rcx
    cmp rdi, 10
    jl  .print
    push rdi
    mov rax, rdi
    xor rdx, rdx
    mov rbx, 10
    idiv rbx
    mov rdi, rax
    jmp .start

.print:
    mov rax, rdi
    xor rdx, rdx
    mov rbx, 10
    idiv rbx
    mov rdi, rdx
    mov rdx, 0x30
    add rdi, rdx
    push rcx
    call putchar
    pop rcx
    dec rcx
    cmp rcx, 0
    je .done
    pop rdi
    jmp .print

.done:
    pop rbx
    xor rcx, rcx
    ret

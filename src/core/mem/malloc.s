section .data
    heap_break: dq 0
    heap_start: dq 0
    failure: db "[MALLOC] ERROR rax address: ", 0
    success: db "[MALLOC] INFO new address: ", 0
    str_allocated: db " allocated ", 0
    str_bytecnt: db " bytes", 0
    rdi_addr: db "rdx address: "

section .text
    global  malloc
    global  brk_find_break

    extern putstr
    extern putchar
    extern putnumber
    extern putendl

brk_find_break:     ; RAX: long brk(0)
    mov rdi, 0x0
    mov rax, 0xC    ; sys_brk
    syscall
    ret

malloc:                     ; RAX: long basic_malloc(RDI: size_t n)
    push rbx
    mov rbx, rdi
    mov r8, [heap_break]
    cmp r8, 0
    jne .allocate           ; allocate normally if exists

    call brk_find_break
    mov [heap_start], rax        ; get heap beginning
    mov [heap_break], rax        ; get heap beginning

.allocate:
    add rbx, 7
    and rbx, ~7

    mov rdi, [heap_break]
    add rdi, rbx

    mov rax, 0xC        ; sys_brk
    syscall

    cmp rax, rdi
    jne .print_failure

    mov [heap_break], rax
    mov r8, rdi
    push rdi

%ifdef DEBUG_BUILD
    mov rdi, success
    call putstr
    mov rdi, r8
    call putnumber

    mov rdi, str_allocated
    call putstr

    mov rdi, rbx
    call putnumber
    mov rdi, str_bytecnt
    call putendl

%endif
    pop rax
    sub rax, rbx
    pop rbx

    ret

.print_failure:
    push rdi
    mov rdi, failure
    call putstr
    mov rdi, rax
    call putnumber
    mov rdi, 0xa
    call putchar
    mov rdi, rdi_addr
    call putstr
    pop rdi
    call putnumber

    xor rax, rax    ; Return NULL on failure
    pop rbx

    ret

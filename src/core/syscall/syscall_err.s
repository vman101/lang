section .data
    EARGCNT: db "[ERROR] Invalid arg count: expected 1", 0xa, 0
    EMALLOC: db "[ERROR] Malloc fialed!", 0xa, 0
    ELSEEK: db "[ERROR] lseek failed!", 0xa, 0

section .text
    global err_args
    global err_malloc
    global err_lseek
    extern exit_err
    extern putstr

err_args:
    mov rdi, EARGCNT
    call putstr
    jmp exit_err

err_malloc:
    mov rdi, EMALLOC
    call putstr
    jmp exit_err

err_lseek:
    mov rdi, ELSEEK
    call putstr
    jmp exit_err

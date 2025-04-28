
section .text
    global exit
    global exit_err

exit:
    mov     rax, 60
    syscall

exit_err:
    mov rdi, 1
    call exit

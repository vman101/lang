section .text
    extern putstr
    extern putnumberendl

    func_stack_alloc: db "    push rbp", 0xa, "    mov rbp, rsp", 0xa, "    sub rsp, ", 0
    func_stack_dealloc: db "    mov rsp, rbp", 0xa, "    pop rbp", 0xa, 0
    ret_inst:   db "    ret", 0xa, 0

global func_prologue
func_prologue:  ; (rdi: var_count)
    mov rax, 8
    imul rax, rdi
    push rax
    mov rdi, func_stack_alloc
    call putstr
    pop rdi
    call putnumberendl
    ret

global func_epilogue
func_epilogue:      ;
    mov rdi, func_stack_dealloc
    call putstr
    mov rdi, ret_inst
    call putstr
    ret

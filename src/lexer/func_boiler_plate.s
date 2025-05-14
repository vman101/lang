%include "./src/inc/c_alignment.s"

section .text
    extern putstr
    extern putnumberendl
    extern fd_out
    extern ft_fprintf

    func_stack_alloc: db "    push rbp", 0xa, "    mov rbp, rsp", 0xa, "    sub rsp, %d", 0x0a, 0
    func_stack_dealloc: db "    mov rsp, rbp", 0xa, "    pop rbp", 0xa, 0
    ret_inst:   db "    ret", 0xa, 0

global func_prologue
func_prologue:  ; (rdi: var_count)
    ; calculate var offsets
    mov rax, 8
    imul rax, rdi

    ; prepare func call
    mov rdi, [fd_out]
    mov rsi, func_stack_alloc
    mov rdx, rax

    c_call ft_fprintf

    ret

global func_epilogue
func_epilogue:      ;
    mov rdi, [fd_out]
    mov rsi, func_stack_dealloc

    c_call ft_fprintf

    ret

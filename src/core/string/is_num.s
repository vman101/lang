section .text
    global is_num
    global is_num_str

is_num:         ; rax: bool (rdi: int c)
    cmp rdi, 48
    jl not_num
    cmp rdi, 57
    jg not_num
    mov rax, 1
    ret
not_num:
    mov rax, 0
    ret

is_num_str:     ; rax: bool (rdi: char *)
    xor rcx, rcx
    mov r8, rdi
.loop:
    mov dil, byte [r8 + rcx]
    cmp dil, 0
    je .done
    call is_num
    cmp rax, 0
    je not_num
    inc rcx
    jmp .loop

.done:
    mov rax, 1
    ret

section .text
    global is_alpha
    global is_alpha_str

is_alpha:         ; rax: bool (rdi: int c)
    mov al, dil
    sub al, 'A'
    cmp al, 25
    jc .is_alpha_true

    mov al, dil
    sub al, 'a'
    cmp al, 25
    ja .not_alpha

.is_alpha_true:
    mov rax, 1
    ret

.not_alpha:
    xor rax, rax
    ret

is_alpha_str:     ; rax: bool (rdi: char *)
    xor rcx, rcx
    mov r8, rdi

.loop:
    mov dil, byte [r8 + rcx]
    cmp dil, 0
    je .done

    call is_alpha
    test rax, rax
    jz .not_alpha

    inc rcx
    jmp .loop

.done:
    mov rax, 1
    ret

.not_alpha:
    xor rax, rax
    ret

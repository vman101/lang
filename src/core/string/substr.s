global substr

section .text
    extern strlen
    extern malloc

substr:             ; rax: char*(rdi: char*, rsi: size_t begin, rdx: size_t end)
    cmp rdi, 0
    je .fail

    cmp rsi, rdx
    jg .fail

    call strlen

    cmp rax, rsi
    jl .fail

    cmp rax, rdx
    jl .fail

    push rdi
    push rsi
    push rdx
    mov rdi, rax
    add rdi, 1
    call malloc
    pop rdx
    pop rsi
    pop rdi


.loop:
    cmp rsi, rdx
    je .done
    mov r9b, [rdi + rsi]
    mov [rax + rsi], r9b
    inc rsi
    jmp .loop

.done:
    mov byte [rax + rdx], 0
    ret

.fail:
    xor rax, rax
    ret

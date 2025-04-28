global memchr

section .text

memchr:         ; rax: void *(rdi: void *, rsi: int find, rdx: size_t size)
    cmp rdi, 0
    je .fail

    cmp rdx, 0
    je .no_size

    xor rcx, rcx
.loop:
    cmp byte [rdi + rcx], sil
    je .done
    cmp byte [rdi + rcx], 0
    je .done
    inc rcx
    jmp .loop

.fail:
    xor rax, rax
    ret

.no_size:
    mov rax, rdi
    ret

.done:
    lea rax, [rdi + rcx]
    ret

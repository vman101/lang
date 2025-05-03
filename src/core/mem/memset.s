section .text

global memset
memset:     ; (rdi: mem*, rsi: c, rdx: n)
    xor rcx, rcx
.loop:
    cmp rcx, rdx
    je .done
    mov byte [rdi + rcx], sil
    inc rcx
    jmp .loop
.done:
    ret


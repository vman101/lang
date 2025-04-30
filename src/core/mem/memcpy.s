section .text

global memcpy
memcpy:             ; (rdi: dst*, rsi: src*, rdx: len)
    xor rcx, rcx
    push rbx

.copy:
    cmp rcx, rdx
    je .done
    mov bl, byte [rsi + rcx]
    mov byte [rdi + rcx], bl
    inc rcx
    jmp .copy

.done:
    pop rbx
    ret

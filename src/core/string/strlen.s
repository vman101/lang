global strlen

section .text
strlen:                 ; strlen(RDI: char *str)
    push rcx            ; save counter
    xor rcx, rcx
.loop:                  ; loop until '\0' character
    cmp byte [rdi + rcx], 0
    jz  .done
    inc rcx
    jmp .loop
.done:
    mov rax, rcx        ; mov return value to rax
    pop rcx             ; restore counter
    ret


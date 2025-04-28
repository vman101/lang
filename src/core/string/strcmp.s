section .text
    global strcmp

strcmp:         ; rax: int (rdi: char *, rsi: char *)
    ; Check for NULL pointers first
    test rdi, rdi                ; Check if first string is NULL
    jz .handle_null
    test rsi, rsi                ; Check if second string is NULL
    jz .handle_null

    xor rcx, rcx                 ; initialize counter to 0

.loop:
    ; Load characters safely using registers
    movzx r9, byte [rdi + rcx]   ; load current char from first string
    movzx r10, byte [rsi + rcx]  ; load current char from second string

    ; Check if we've reached the end of either string
    test r9, r9                  ; check if we reached end of first string
    jz .check_second             ; if so, jump to check second string

    test r10, r10                ; check if we reached end of second string
    jz .greater                  ; if second string ends first, first string is greater

    ; Compare the characters
    cmp r9, r10                  ; compare characters
    jl .less                     ; if first char < second char, first string is less
    jg .greater                  ; if first char > second char, first string is greater

    ; Characters are equal, continue to next character
    inc rcx                      ; increment counter
    jmp .loop                    ; continue loop

.check_second:
    test r10, r10                ; if first string ended, check if second ended too
    jz .equal                    ; if both ended at same position, strings are equal
    jmp .less                    ; if only first ended, first string is less

.handle_null:
    ; Handle NULL pointer case (implementation-dependent, could also raise error)
    ; Here we'll follow standard C behavior: if both are NULL, equal; otherwise compare addresses
    cmp rdi, rsi
    je .equal
    jl .less
    jmp .greater

.less:
    mov rax, -1                  ; return -1 if first string is less
    ret

.greater:
    mov rax, 1                   ; return 1 if first string is greater
    ret

.equal:
    xor rax, rax                 ; return 0 if strings are equal
    ret

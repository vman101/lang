%macro c_call 1-*
    push r12
    ; Save current stack pointer in a scratch register
    mov r12, rsp
    mov al, 0

    ; Align stack to 16 bytes
    and rsp, -16

    ; Set up arguments if provided
    %if %0 > 1
        mov rdi, %2
    %endif
    %if %0 > 2
        mov rsi, %3
    %endif
    %if %0 > 3
        mov rdx, %4
    %endif
    %if %0 > 4
        mov rcx, %5
    %endif
    %if %0 > 5
        mov r8, %6
    %endif
    %if %0 > 6
        mov r9, %7
    %endif

    ; Set al to 0 for variadic functions
    mov al, 0

    ; Make the call
    call %1

    ; Restore original stack pointer
    mov rsp, r12
    pop r12
%endmacro

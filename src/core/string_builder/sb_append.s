%include "./src/core/string_builder/sb.s"

section .text
    extern strlen
    extern memcpy
    extern malloc
    extern err_malloc
    extern ft_strlcpy
    extern ft_strlcat

%define SB [rbp - 16]
%define SB_LEN dword [rbp - 4]
%define SB_CAP dword [rbp - 8]
%define APPENDIX [rbp - 24]
%define APP_LEN dword [rbp - 28]

global sb_append
sb_append:      ; (rdi: *sb, rsi: char*)
    push rbp
    mov rbp, rsp
    sub rsp, 32

    test rsi, rsi
    jz .done
    ; store sb on stack
    mov SB, rdi

    ; store new str on stack
    mov APPENDIX, rsi

    ; get sb len
    mov eax, dword [rdi + STR_LEN]
    mov SB_LEN, eax

    mov eax, dword [rdi + STR_CAP]
    mov SB_CAP, eax

    push rdi
    mov rdi, rsi
    call strlen

    mov APP_LEN, eax

    add eax, SB_LEN
    cmp eax, SB_CAP
    jl .copy_string

    mov r9d, SB_CAP
    ; new string will be to large for current cap, need to realloc
.get_new_len:
    imul r9, 2
    cmp r9, rax
    jl .get_new_len
    mov SB_CAP, r9d
    push r9
    push rax
    mov rdi, r9
    call malloc
    test rax, rax
    jz err_malloc
    mov rdi, rax
    mov rsi, SB
    mov rsi, [rsi + STR_DATA]
    mov edx, SB_LEN
    call ft_strlcpy
    pop rax
    mov rsi, SB
    pop r9
    mov [rsi + STR_CAP], r9

.copy_string:
    pop rdi
    mov r9, SB
    mov dword [r9 + STR_LEN], eax
    mov rdi, [r9 + STR_DATA]
    mov eax, dword [rbp - 4]
    mov rsi, APPENDIX
    mov edx, SB_CAP
    call ft_strlcat

.done:
    mov rsp, rbp
    pop rbp
    ret

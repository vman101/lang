%include "./src/core/string_builder/sb.s"

%define FD dword [rbp - 4]

section .text
    extern write

global sb_dump_to_file
sb_dump_to_file:    ; (rdi: *sb, rsi: int fd)
    push rbp
    mov rbp, rsp
    sub rsp, 16

    ; load data, len and fd into regs to prepare for write syscall
    mov FD, esi
    mov rsi, [rdi + STR_DATA]
    mov rdx, [rdi + STR_LEN]
    mov edi, FD

    ; dump to file
    call write

    mov rsp, rbp
    pop rbp
    ret

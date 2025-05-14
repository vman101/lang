
section .text
    global open
    global close
    global read
    global get_file_size
    global lseek
    global write

write:              ; write(RDI: int fd, RSI: char *buffer, RDX: size_t size)
    mov rax, 1
    syscall
    ret

open:               ; rax: int fd (rdi: char *name, rsi: int flags)
    mov rax, 2      ; sys_open
    syscall
    ret

close:
    mov rax, 3      ; sys_close
    syscall
    ret

read:               ; read(RDI: int fd, RSI: char *buffer, RDX: size_t size)
    mov rax, 0      ; sys_read
    syscall         ;
    ret

get_file_size:          ;rax: size_t(rdi: int fd)
    mov rax, 8          ; sys_lseek
    mov rsi, 0          ; offset 0
    mov rdx, 2
    syscall
    ret

lseek:                  ; rax: uint (rdi: int fd, rsi: offset, rdx: int whence)
                        ; whence:   SEEK_SET 0 = set cursor to offset
                        ;           SEEK_CUR 1 = set cursor to current_pos + offset
                        ;           SEEK_END 2 = set cursor to end
                        ; return = current offset
    mov rax, 8
    syscall
    ret

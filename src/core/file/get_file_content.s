section .text
    global get_file_content
    extern open
    extern read_file
    extern close

get_file_content:       ; rax: char *(rdi: char*)
    mov rsi, 0
    call open
    mov rdi, rax
    push rax
    call read_file
    mov rsi, rax
    pop rdi
    call close
    mov rax, rsi
    ret

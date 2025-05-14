section .data
    putnumber_func: db "putnumber", 0
    exit_func: db "exit", 0

    global ftable
    ftable: dq 2,        \
        putnumber_func, \
        exit_func

    global func_call_prologue
    func_call_prologue:  db "    push rdi", 0x0a, 0

    global func_call
    func_call:      db "    call %s", 0x0a, 0

    global func_call_epilogue
    func_call_epilogue:  db "    pop rdi", 0x0a, 0

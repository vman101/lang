section .data
    func_syms: db \
        "putnumber", 0 \

    global ftable
    ftable: dq 1,        \
            func_syms
    global func_prologue
    func_prologue:  db "push rdi", 0

    global func_call
    func_call:      db "call ", 0

    global func_epilogue
    func_epilogue:  db "pop rdi", 0


%define VEC_SIZE            32
%define VEC_DEFAULT_CAP     64

%define VEC_COUNT           0
%define VEC_CAP             4
%define VEC_MEMBER_SIZE     8
%define VEC_MEM             16


; for all macros,
;   arg1 should be the target reg,
;   arg2 is the offset on the stack for vec_count

%macro vec_cap 2
    mov %1, [rbp - (%2 + 8)]
%endmacro

%macro vec_member_size 1
    [rbp - (%1 + 12)]
%endmacro

%macro vec_mem 2
    mov %1, [rbp - (%2 + 20)]
%endmacro

%macro vec_onto_stack 2

    mov eax, dword [%1 + VEC_COUNT]
    mov dword [rbp - (%2 + 4)], eax
    mov eax, dword [%1 + VEC_CAP]
    mov dword [rbp - (%2 + 8)], eax
    mov eax, dword [%1 + VEC_MEMBER_SIZE]
    mov dword [rbp - (%2 + 12)], eax
    mov rax, [%1 + VEC_MEM]
    mov [rbp - (%2 + 20)], rax

%endmacro

;   struct vec
;       .count          0
;       .cap            4
;       .member_size    8
;       .mem            16

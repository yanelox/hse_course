extern printf, scanf

global main

section .data
    fmt : db "%f %f",0
    out_eq : db "Numbers approx equal",10,0
    out_neq : db "Numbers not equal",10,0
    out_error : db "Something wrong %d",10,0
    eps  dd 0.001

section .bss
    num1 resd 1
    num2 resd 1

section .text

main:
    push ebp
    mov ebp, esp
    and esp, -16

    sub esp, 16
    mov dword [esp], fmt
    mov dword [esp + 4], num1
    mov dword [esp + 8], num2
    call scanf
    add esp, 16

    cmp eax, 2
    jne .error

.fp_start:
    finit

    fld dword [num1]
    fsub dword [num2]

    fabs    ; ST0 = |num1 - num2|

    fld dword [eps]
.compare:
    fucomip st0, st1    ; compare eps ? |num1 - num2|

    ja .approx_equal
    jmp .not_equal

.approx_equal:
    sub esp, 16
    mov dword [esp], out_eq
    call printf
    add esp, 16
    jmp .end

.not_equal:
    sub esp, 16
    mov dword [esp], out_neq
    call printf
    add esp, 16
    jmp .end

.error:
    sub esp, 16
    mov dword [esp], out_error
    mov dword [esp + 4], eax
    call printf
    add esp, 16

.end:
    xor eax, eax
    leave
    ret

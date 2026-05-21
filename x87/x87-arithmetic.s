global main

section .data
    num1 dq 4.2
    num2 dd 6.9
    num3 dd 322

section .text

main:
    push ebp
    mov ebp, esp

    finit
    ; fld - float load
    fld qword [num1]
    fld dword [num2]

    ; simple add, result in st0
    fadd st0, st1

    ; st1 = st1 + st0, then pop
    faddp st1, st0

    ; add integer to st0
    fiadd dword [num3]

    ; division
    finit
    fld qword [num1]
    fld dword [num2]

    fdiv st0, st1

    ; reverse-division
    finit
    fld qword [num1]
    fld dword [num2]

    fdivr st0, st1

    xor eax, eax
    leave
    ret

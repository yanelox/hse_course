global main

section .data
    num1 dq 4.2
    num2 dd 6.9

section .text

main:
    push ebp
    mov ebp, esp

    ; fld - float load
    fld qword [num1]
    fld dword [num2]

    fld qword [num1]
    fld dword [num2]

    fld qword [num1]
    fld dword [num2]

    fld qword [num1]
    fld dword [num2]


    ; overflow here
    .overflow:
    fld dword [num1]
    fwait

    xor eax, eax
    leave
    ret

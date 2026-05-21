global main

section .data
    num1 dq 4.2
    num2 dd 6.9

section .bss
    out_num1 resq 1
    out_num2 resd 1

section .text

main:
    push ebp
    mov ebp, esp

    ; fld - load
    fld qword [num1]
    fld dword [num2]

    ; fst - store
    fst qword [out_num1]
    fst dword [out_num2]

    ; fstp - store + pop 
    fstp qword [out_num1]
    fstp dword [out_num2]

    xor eax, eax
    leave
    ret

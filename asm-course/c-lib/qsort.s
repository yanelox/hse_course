extern printf, scanf, calloc, free, qsort

SIZE equ 4
COUNT equ 10

section .data
    array dd 10, 3, 5, 1, 9, 8, 2, 7, 4, 6   ; array

section .bss
    size resd 1
    tmp resd 1

section .text

comp:
    push ebp
    mov ebp, esp

    mov eax, [ebp + 8]
    mov edx, [ebp + 12]

    mov eax, [eax]
    mov edx, [edx]

    sub eax, edx

    leave
    ret


global main
main:
    push ebp
    mov ebp, esp
    and esp, -16

    sub esp, 16
    mov dword [esp], array
    mov dword [esp + 4], COUNT
    mov dword [esp + 8], SIZE
    mov dword [esp + 12], comp
    call qsort
    add esp, 16

.end:
    xor eax, eax
    leave
    ret

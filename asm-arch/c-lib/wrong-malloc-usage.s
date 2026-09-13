extern printf
extern malloc
extern free

section .data
    msg db "Pointer is: %p", 10, 0

section .text

global main
main:
    push ebp
    mov ebp, esp

    sub esp, 16
    mov dword [esp], 100
    call malloc
    add esp, 16

    sub esp, 16
    mov dword [esp], msg
    mov dword [esp + 4], eax
    call printf
    add esp, 16

    xor eax, eax
    leave
    ret
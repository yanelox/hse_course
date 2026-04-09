extern printf
extern malloc
extern free

section .data
    data_msg db "Data is: %d", 10
    pointer_msg db "Pointer is: %p", 10, 0

section .text

global main
main:
    push ebp
    mov ebp, esp
    ; allocate some mem for local vars + allignment
    sub esp, 16

    sub esp, 16
    mov dword [esp], 4
    call malloc
    add esp, 16

    mov dword [ebp - 4], eax
    mov dword [eax], 42

    sub esp, 16
    mov dword [esp], pointer_msg
    mov dword [esp + 4], eax
    call printf
    add esp, 16

    sub esp, 16
    mov dword [esp], data_msg
    mov eax, dword [ebp - 4]
    mov eax, dword [eax]
    mov dword [esp + 4], eax
    call printf
    add esp, 16

    sub esp, 16
    mov eax, dword [ebp - 4]
    mov dword [esp], eax
    call free
    add esp, 16

    xor eax, eax
    leave
    ret
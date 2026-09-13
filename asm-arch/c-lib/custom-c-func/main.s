extern fact
extern printf
extern scanf

section .data
    fmt : db "%d",0
    out : db "Number: %d",10,0
    out_error : db "Shit happened: %d",10,0

section .bss
    x resd 1

section .text

global main
main:
    push ebp
    mov ebp, esp

    sub esp, 16
    mov dword [esp], fmt
    mov dword [esp + 4], x
    call scanf
    add esp, 16

    ; check eax
    cmp eax, 1
    jne .not_ok

.ok:
    sub esp, 16
    mov eax, [x]
    mov dword [esp], eax
    call fact
    add esp, 16

    sub esp, 16
    mov dword [esp], out
    mov dword [esp + 4], eax

    jmp .end

.not_ok:
    sub esp, 16
    mov dword [esp], out_error
    mov dword [esp + 4], eax

.end:
    call printf
    add esp, 16

    xor eax, eax
    leave
    ret
extern printf

%define SKULL_EMOJI 0xF0, 0x9F, 0x92, 0x80

section .data
    msg db "Hello from NASM: %d", SKULL_EMOJI, 10, 0

section .text

global main
main:
    push ebp
    mov ebp, esp

    sub esp, 16
    mov dword [esp + 4], 42
    mov dword [esp], msg
    call printf
    add esp, 16

    xor eax, eax
    leave
    ret
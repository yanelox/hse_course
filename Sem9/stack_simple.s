; ../lib/build_asm.sh stack_simple.s

global main
extern io_print_udec, io_newline

section .text

main:
    mov eax, esp
    call io_print_udec
    call io_newline

    push eax
    mov eax, esp
    call io_print_udec
    call io_newline

    pop eax
    mov eax, esp
    call io_print_udec
    call io_newline

    xor eax, eax
    ret

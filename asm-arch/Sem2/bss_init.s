; ../lib/build_asm.sh bss_init.s

extern io_print_hex, io_newline

section .bss
    big_array resw 1024*1024

section .text
global main

main:
    mov eax, [big_array + 7]
    call io_print_hex
    call io_newline
    xor eax, eax
    ret
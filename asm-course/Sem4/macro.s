; ../lib/build_asm.sh macro.s

global main
extern io_print_hex, io_newline

%macro print_hex_newline 0
    call io_print_hex
    call io_newline
%endmacro

%macro print_two_constants 2
    mov eax, %1
    call io_print_hex
    call io_newline

    mov eax, %2
    call io_print_hex
    call io_newline
%endmacro

section .text
main:
    mov eax, 0x42
    print_hex_newline

    print_two_constants 0x12, 0x34

    ret
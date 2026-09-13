; ../lib/build_asm.sh data_init.s
; llvm-objdump data_init -s > objdump.txt

extern io_print_hex, io_newline

section .data
    var1 : dw 0xAABB
    var2 : dd 0x1234789A
    

section .text

global main

main:
    mov eax, var1
    call io_print_hex
    call io_newline

    mov eax, var2
    call io_print_hex
    call io_newline

    movzx eax, WORD [var1]
    call io_print_hex
    call io_newline

    mov eax, [var2]
    call io_print_hex
    call io_newline

    ; operand size
    mov eax, [var1]
    call io_print_hex
    call io_newline

    xor eax, eax
    ret
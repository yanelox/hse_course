; ../lib/build_asm.sh little_endian.s
; llvm-objdump little_endian -s > objdump.txt

extern io_print_hex, io_newline

section .data
    var1 : dw 0xAABB
    var2 : dd 0x1234789A
    

section .text

global main

main:
    mov eax, [var1]
    call io_print_hex
    call io_newline

    xor eax, eax
    ret
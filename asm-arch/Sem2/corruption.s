; ../lib/build_asm.sh corruption.s
; llvm-objdump corruption -s > objdump.txt

extern io_print_hex, io_newline

MAGIC_NUM equ 0x42
BIG_MAGIC_NUM equ 0x4242

section .data
    byte_var   db 0xFF          ; 8 bit
    word_var   dw 0x1234        ; 16 bit

section .text
global main

main:
    movzx eax, byte [byte_var]
    call io_print_hex
    call io_newline

    movzx eax, word [word_var]
    call io_print_hex
    call io_newline


    mov word [byte_var], BIG_MAGIC_N0x4242
    

    movzx eax, byte [byte_var]
    call io_print_hex
    call io_newline

    movzx eax, word [word_var]
    call io_print_hex
    call io_newline

    xor eax, eax
    ret
; ../lib/build_asm.sh neg.s
; llvm-objdump neg -s > objdump.txt
; llvm-objdump neg -d -M intel > objdump.txt

extern io_print_hex, io_newline

NUM1 equ 0x42

section .bss
    storage resd 1024 * 1024

section .text
global main

main:
    ; --------------------------------------------------
    ; 1. NEG
    ; --------------------------------------------------

    ; --------------------------------------------------
    ; neg register value
    ; --------------------------------------------------
    mov eax, NUM1
    neg eax
    call io_print_hex           ; ffffffbe (-0x42)
    call io_newline

    mov dword [storage], NUM1
    ; --------------------------------------------------
    ; neg memory value
    ; --------------------------------------------------
    neg dword [storage]
    mov eax, dword [storage]
    call io_print_hex           ; ffffffbe (-0x42)
    call io_newline
    
    xor eax, eax
    ret
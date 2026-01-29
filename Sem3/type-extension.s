; ../lib/build_asm.sh type-extension.s
; llvm-objdump type-extension -s > objdump.txt
; llvm-objdump type-extension -d -M intel > objdump.txt
; du -h type-extension

extern io_print_hex, io_newline

section .data
    byte_var   db 0xFF          ; 8 bit

section .bss
    storage resw 1024 * 1024

section .text
global main

main:
    ; --------------------------------------------------
    ; 1. ZERO-EXTENDED
    ; --------------------------------------------------
    movzx eax, byte [byte_var]
    call io_print_hex           ; 000000FF
    call io_newline
    
    xor eax, eax
    mov dx, 0x42
    movzx eax, dx
    call io_print_hex           ; 00000042
    call io_newline

    ; COMPILATION ERROR:
    ;
    ; movzx word [storage], eax

    ; --------------------------------------------------
    ; 2. SIGN-EXTENDED
    ; --------------------------------------------------
    movsx eax, byte [byte_var]
    call io_print_hex           ; ffffffff (-1)
    call io_newline

    xor eax, eax
    mov dx, -0x42
    movsx eax, dx
    call io_print_hex           ; ffffffbe (-0x42)
    call io_newline
    
    xor eax, eax
    ret
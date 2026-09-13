; ../lib/build_asm.sh add.s
; llvm-objdump add -s > objdump.txt
; llvm-objdump add -d -M intel > objdump.txt

extern io_print_hex, io_newline

NUM1 equ 0x42
NUM2 equ 0x69

section .data
    byte_var   db 0xFF          ; 8 bit

section .bss
    storage resd 1024 * 1024

section .text
global main

main:
    ; --------------------------------------------------
    ; 1. ADD
    ; --------------------------------------------------

    ; --------------------------------------------------
    ; add constant to register
    ; --------------------------------------------------
    xor eax, eax
    add eax, NUM1
    call io_print_hex           ; 42
    call io_newline

    mov eax, NUM1
    ; --------------------------------------------------
    ; add register to memory
    ; --------------------------------------------------
    add dword [storage], eax
    mov eax, dword [storage]
    call io_print_hex           ; 42
    call io_newline

    mov eax, NUM2
    ; --------------------------------------------------
    ; add memory to register
    ; --------------------------------------------------
    add eax, dword [storage]
    call io_print_hex           ; 42 + 69 = ab
    call io_newline


    ; --------------------------------------------------
    ; add memory to memory - error
    ; --------------------------------------------------
    ; add dword [storage + 8], dword [storage]
    
    xor eax, eax
    ret
; ../lib/build_asm.sh sub.s
; llvm-objdump sub -s > objdump.txt
; llvm-objdump sub -d -M intel > objdump.txt

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
    ; 1. SUB
    ; --------------------------------------------------

    ; --------------------------------------------------
    ; subtract constant from register
    ; --------------------------------------------------
    xor eax, eax
    sub eax, NUM1
    call io_print_hex           ; ffffffbe (-0x42)
    call io_newline

    mov eax, NUM1
    ; --------------------------------------------------
    ; sub register from memory
    ; --------------------------------------------------
    sub dword [storage], eax
    mov eax, dword [storage]
    call io_print_hex           ; ffffffbe (-0x42)
    call io_newline

    mov eax, NUM2
    mov dword [storage], NUM1
    ; --------------------------------------------------
    ; sub memory from register
    ; --------------------------------------------------
    sub eax, dword [storage]
    call io_print_hex           ; 69 - 42 = 27
    call io_newline


    ; --------------------------------------------------
    ; sub memory to memory - error
    ; --------------------------------------------------
    ; sub dword [storage + 8], dword [storage]
    
    xor eax, eax
    ret
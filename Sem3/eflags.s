; ../lib/build_asm.sh eflags.s
; llvm-objdump eflags -s > objdump.txt
; llvm-objdump eflags -d -M intel > objdump.txt
; gdb -ex "set disassembly-flavor intel" ./eflags

extern io_print_hex, io_newline

DWORD_UNSIGNED_MAX equ 0xffffffff

section .bss
    storage resd 1024 * 1024

section .text
global main

main:
    ; --------------------------------------------------
    ; 1. EFLAGS
    ; --------------------------------------------------

    ; --------------------------------------------------
    ; add overflow
    ; --------------------------------------------------
    mov eax, DWORD_UNSIGNED_MAX
    add eax, 1
    call io_print_hex
    call io_newline

    ; --------------------------------------------------
    ; 1
    ; --------------------------------------------------
    mov eax, 0x7fffffff
    add eax, 1

    ; --------------------------------------------------
    ; 2
    ; --------------------------------------------------
    mov eax, 0xffffffff
    add eax, 1

    ; --------------------------------------------------
    ; 3
    ; --------------------------------------------------
    mov eax, 0x80000000
    sub eax, 1

    ; --------------------------------------------------
    ; 4
    ; --------------------------------------------------
    mov eax, 0
    sub eax, 1

    xor eax, eax
    ret
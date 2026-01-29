; ../lib/build_asm.sh setcc.s
; llvm-objdump setcc -s > objdump.txt
; llvm-objdump setcc -d -M intel > objdump.txt
; gdb -ex "set disassembly-flavor intel" ./setcc

extern io_print_hex, io_newline

section .bss
    flags resb 4

section .text
global main

main:
    ; --------------------------------------------------
    ; 1. setcc
    ; --------------------------------------------------

    mov eax, 0x7fffffff
    add eax, 1

    setz byte [flags]
    sets byte [flags + 1]
    seto byte [flags + 2]
    setc byte [flags + 3]

    mov eax, dword [flags]
    call io_print_hex
    call io_newline

    xor eax, eax
    ret
; ../lib/build_asm.sh mul.s
; llvm-objdump mul -s > objdump.txt
; llvm-objdump mul -d -M intel > objdump.txt
; gdb -ex "set disassembly-flavor intel" ./mul

extern io_print_hex, io_newline

section .data
    byte_var db 0xff

section .bss
    storage resd 2

section .text
global main

; ----
; FUNC_NAME print_storage
; DESCRIPTION: prints content of `storage` var
; EXPECTS: expects values you want to print in `storage` var
; CORRUPTS: EAX
; RETURNS: None
; ----
print_storage:
    mov eax, [storage]
    call io_print_hex
    call io_newline

    mov eax, [storage + 8]
    call io_print_hex
    call io_newline
    ret

main:
    ; --------------------------------------------------
    ; 1. mul
    ; --------------------------------------------------

    mov eax, 0xffffffff
    mov ebx, 0x10
    mul ebx

    mov dword [storage], eax
    mov dword [storage + 8], edx

    call print_storage

    ; --------------------------------------------------
    ; 2. mul
    ; --------------------------------------------------

    mov eax, 0x76543210
    mul byte [byte_var]

    mov dword [storage], 0
    mov dword [storage + 8], 0

    mov byte [storage], al
    mov byte [storage + 8], ah

    call print_storage

    xor eax, eax
    ret
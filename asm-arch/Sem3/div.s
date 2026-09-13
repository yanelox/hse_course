; ../lib/build_asm.sh div.s
; llvm-objdump div -s > objdump.txt
; llvm-objdump div -d -M intel > objdump.txt
; gdb -ex "set disassembly-flavor intel" ./div

extern io_print_dec, io_newline

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
    call io_print_dec
    call io_newline

    mov eax, [storage + 8]
    call io_print_dec
    call io_newline
    ret

main:
    ; --------------------------------------------------
    ; 1. div
    ; --------------------------------------------------

    xor edx, edx
    mov eax, 100
    mov ebx, 7
    div ebx
    
    mov dword [storage], eax
    mov dword [storage + 8], edx

    call print_storage
    call io_newline

    ; --------------------------------------------------
    ; 2. idiv
    ; --------------------------------------------------

    mov eax, -100
    cdq			; extend dword to qword; sign-extend eax to edx:eax
    mov ebx, 7
    idiv ebx

    mov dword [storage], eax
    mov dword [storage + 8], edx

    call print_storage
    call io_newline

    xor eax, eax
    ret
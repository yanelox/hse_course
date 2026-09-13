; ../lib/build_asm.sh imul.s
; llvm-objdump imul -s > objdump.txt
; llvm-objdump imul -d -M intel > objdump.txt
; gdb -ex "set disassembly-flavor intel" ./imul

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
    ; 1. imul
    ; --------------------------------------------------

    mov eax, 0xffffffff
    mov ebx, 0x42
    imul ebx

    mov dword [storage], eax
    mov dword [storage + 8], edx

    call print_storage

    ; --------------------------------------------------
    ; 2. imul
    ; --------------------------------------------------

    mov eax, 0xfffdfffe		; -0x20002
    mov ebx, 0xfffdfffe		; -0x20002
    imul ebx

    mov dword [storage], eax
    mov dword [storage + 8], edx

    call print_storage

    ; -0x20002 * -0x20002 = 0x400080004

    ; --------------------------------------------------
    ; 3. imul
    ; --------------------------------------------------

    mov eax, 0xfffdfffd		; -0x20003
    mov ebx, 0xfffdfffd		; -0x20003
    imul eax, ebx		; same as `imul ebx`, but edx is not used
				; c0009 in eax, trash in edx
    mov dword [storage], eax
    mov dword [storage + 8], edx

    call print_storage

    ; --------------------------------------------------
    ; 4. imul
    ; --------------------------------------------------

    mov ebx, 0xfffdfffc		; -0x20004
    imul eax, ebx, 0xfffdfffc	; same as `imul ebx`, but edx is not used
				; 100010 in eax, trash in edx
    mov dword [storage], eax
    mov dword [storage + 8], edx

    call print_storage

    xor eax, eax
    ret
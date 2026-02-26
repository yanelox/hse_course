; ../../lib/build_asm.sh array.s

global main
extern io_print_hex, io_newline

%macro print_hex_newline 0
    call io_print_hex
    call io_newline
%endmacro

%macro somehow_fill_array 1
    mov ecx, 0
    mov dword[%1 + 4 * ecx], 0x42

    mov ecx, 4
    mov dword[%1 + 4 * ecx], 0x128

    mov ecx, 9
    mov dword[%1 + 4 * ecx], 0x420
%endmacro

N equ 10

section .bss
    a resd N

section .text

; ----
; FUNC_NAME print_array
; DESCRIPTION: print array of N numbers with 4 byte size
; EXPECTS: array address in esi
; CORRUPTS: eax, ebx, esi
; RETURNS: None
; ----
print_array:
    mov ebx, 0
.L:
    cmp ebx, N
    jge .end
    mov eax, dword[esi]
    print_hex_newline
    add esi, 4
    inc ebx
    jmp .L
.end:
    ret

main:
    somehow_fill_array a

    mov esi, a
    call print_array

    xor eax, eax
    ret
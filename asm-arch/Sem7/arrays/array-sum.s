; ../../lib/build_asm.sh array-sum.s

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

section .bss
    a resd 1024

section .text

; ----
; FUNC_NAME array_sum
; DESCRIPTION: count sum of array
; EXPECTS: array address in esi, array size in edi
; CORRUPTS: eax, ebx, esi
; RETURNS: sum in eax
; ----
array_sum:
    mov ebx, 0
    mov eax, 0 
.L:
    cmp ebx, edi
    jge .end
    add eax, dword[esi]
    add esi, 4
    inc ebx
    jmp .L
.end:
    ret

; ----
; FUNC_NAME print_array
; DESCRIPTION: print array of numbers with 4 byte size
; EXPECTS: array address in esi, array size in edi
; CORRUPTS: eax, ebx, esi
; RETURNS: None
; ----
print_array:
    mov ebx, 0
.L:
    cmp ebx, edi
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
    mov edi, 10
    call print_array

    mov esi, a
    mov edi, 10
    call array_sum
    print_hex_newline 

    xor eax, eax
    ret
; ../../lib/build_asm.sh two-dimension-array-sum.s

global main
extern io_print_hex, io_newline, io_print_char

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
    rows resd 1
    columns resd 1

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
; EXPECTS: array address in esi, rows count in edi, columns count in ebx
; CORRUPTS: eax, edi, ebx
; RETURNS: None
; ----
print_array:
    mov dword[rows], edi
    xor edi, edi
    mov dword[columns], ebx
.L1:
    cmp edi, dword[rows]
    jge .end1
    xor ebx, ebx
.L2:
    cmp ebx, dword[columns]
    jge .end2

    mov eax, dword[columns]
    imul eax, edi
    add eax, ebx
    mov eax, dword[esi + 4 * eax]
    call io_print_hex
    mov eax, " "
    call io_print_char
    inc ebx
    jmp .L2
.end2:
    call io_newline
    inc edi
    jmp .L1
.end1:
    ret

main:
    somehow_fill_array a

    mov esi, a
    mov edi, 16
    mov ebx, 16
    call print_array

    xor eax, eax
    ret
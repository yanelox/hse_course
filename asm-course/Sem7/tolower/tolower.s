; ../../lib/build_asm.sh tolower.s

global main
extern io_newline, io_print_string

section .data
    str : db "HelLO, wORlD!", 0

section .bss
    storage resd 32

section .text

; ----
; FUNC_NAME tolower
; DESCRIPTION: takes null-terminated string by address from esi, 
;              do tolower for all symbols, save result to address from edi
; EXPECTS: input address in esi, output address at edi
; CORRUPTS: eax, ecx, esi
; RETURNS: None
; ----
tolower:
.L1:
    movzx eax, byte[esi]
    test eax, eax
    jz .end
    
    mov ecx, "A"
    cmp eax, ecx
    jb .L2
    
    mov ecx, "Z"
    cmp eax, ecx
    ja .L2

    add eax, "a"
    sub eax, "A"
.L2:
    mov byte[edi], al
    inc esi
    inc edi

    jmp .L1
.end:
    ret

main:
    mov eax, str
    call io_print_string
    call io_newline

    mov esi, str
    mov edi, storage
    call tolower

    mov eax, storage
    call io_print_string
    call io_newline

    xor eax, eax
    ret
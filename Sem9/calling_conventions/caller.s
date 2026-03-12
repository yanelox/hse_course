.intel_syntax noprefix ; need this for proper compilation

default rel
global main

extern add_sysv
extern add_ms

section .text
main:
    push rbp
    mov  rbp, rsp
    sub  rsp, 16

    ; --- add_sysv(10, 20) ---
    ; System V ABI:
    ;   1st arg -> edi
    ;   2nd arg -> esi
    mov  edi, 10
    mov  esi, 20
    call add_sysv
    mov  dword [rbp-4], eax

    ; --- add_ms(30, 40) ---
    ; cdecl x64 ABI:
    ;   1st arg -> ecx
    ;   2nd arg -> edx
    sub  rsp, 32
    mov  ecx, 30
    mov  edx, 40
    call add_ms
    add  rsp, 32
    mov  dword [rbp-8], eax

    xor  eax, eax
    leave
    ret

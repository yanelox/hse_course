; ../lib/build_asm.sh test.s

global main
extern io_print_hex, io_newline

%macro print_hex_newline 0
    call io_print_hex
    call io_newline
%endmacro

%macro save_eflags 0
    setc byte [flag]		; CF
    seto byte [flag + 1]	; OF
    setz byte [flag + 2]	; ZF
    sets byte [flag + 3]	; SF
%endmacro

%macro print_eflags 0
    movzx eax, byte [flag]	; CF
    print_hex_newline

    movzx eax, byte [flag + 1]	; OF
    print_hex_newline

    movzx eax, byte [flag + 2]	; ZF
    print_hex_newline

    movzx eax, byte [flag + 3]	; SF
    print_hex_newline
%endmacro

section .bss
    flag resb 4

section .text
main:
    mov eax, 2
    mov ebx, 3
    cmp eax, ebx
    save_eflags
    print_eflags		; CF = 1, OF = 0, ZF = 0, SF = 1

    call io_newline

    test eax, ebx		; 10 & 11 = 10
    save_eflags
    print_eflags		; CF = 0, OF = 0, ZF = 0, SF = 0

    ret
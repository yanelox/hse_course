; ../lib/build_asm.sh cyclic-shift.s

global main
extern io_print_hex, io_newline

%macro print_hex_newline 0
    call io_print_hex
    call io_newline
%endmacro

%macro save_eflags 0
    setc byte [flag]		; CF
    seto byte [flag + 1]	; OF
%endmacro

%macro print_eflags 0
    movzx eax, byte [flag]	; CF
    print_hex_newline

    movzx eax, byte [flag + 1]	; OF
    print_hex_newline
%endmacro

%macro set_cf_1 0
    mov byte [storage], 0x81
    rol byte [storage], 1
%endmacro

section .bss
    flag resb 2
    storage resb 1

section .text
main:
    ; ROR
    mov al, 0x81		; 81 = 10000001
    ror al, 1
    save_eflags
    movzx eax, al
    print_hex_newline		; c0000000 = 11000000

    print_eflags		; CF = 1, OF = 0

    call io_newline
    
    ; ROL
    mov al, 0x81		; 81 = 10000001
    rol al, 1
    save_eflags
    movzx eax, al
    print_hex_newline		; 3 = 00000011
    
    print_eflags		; CF = 1, OF = 1

    call io_newline

    ; RCR
    mov al, 0xa1		; a1 = 10100001
    
    set_cf_1

    rcr al, 2
    save_eflags
    movzx eax, al
    print_hex_newline		; e8 = 11101000

    print_eflags		; CF = 0, OF = 0

    call io_newline
    
    ; RCL
    mov al, 0xa1		; a1 = 10100001
    
    set_cf_1

    rcl al, 2
    save_eflags
    movzx eax, al
    print_hex_newline		; 87 = 10000111

    print_eflags		; CF = 0, OF = 1

    ret
; ../lib/build_asm.sh shift.s

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
    storage resd 1

section .text
main:

    ; SHL
    mov eax, 0x42
    shl eax, 1
    print_hex_newline		; 42 << 1 = 84

    ; SHL: memory
    mov dword [storage], 0x42
    sal dword [storage], 1
    mov eax, [storage]
    print_hex_newline		; 42 << 1 = 84

    ; SHL: count is cl
    mov cl, 1
    mov eax, 0x42
    shl eax, cl	
    print_hex_newline		; 42 << 1 = 84

    ; SAL
    mov eax, 0x42
    sal eax, 1
    print_hex_newline		; 42 << 1 = 84

    ; EFLAGS
    mov al, 0x69		; 69 = 01101001
    shl al, 2			; 01101001 << 2 = 10100100 = a4, bits `01` are discarded
    save_eflags
    print_hex_newline
    
    print_eflags		; CF = 1, OF = 1, ZF = 0, SF = 1
    
    call io_newline

    ; SHR
    mov eax, 0x42
    shr eax, 1
    print_hex_newline		; 42 >> 1 = 21

    ; EFLAGS
    mov al, 0x69		; 69 = 01101001
    shr al, 2			; 01101001 >> 2 = 00011010 = 1a, bits `01` are discarded
    save_eflags
    print_hex_newline

    print_eflags		; CF = 0, OF = 0, ZF = 0, SF = 0

    call io_newline

    ; SAR
    mov al, 0x67		; 67 = 01100111
    sar al, 2			; 01100111 >> 2 = 00011001 = 19
    print_hex_newline

    mov al, -0x67		; -67 = 10011001
    sar al, 2			; 10011001 >> 2 = 11100110 = e6
    save_eflags
    print_hex_newline

    print_eflags		; CF = 0, OF = 0, ZF = 0, SF = 1

    call io_newline

    ; SHLD
    mov ax, 0x42		; 42 = 01000010
    mov bx, 0xA000		; A000 = 1010000000000000
    shld ax, bx, 3		; 01000010 << 3 + 101 = 1000010000 + 101 = 1000010101 = 215
    save_eflags
    movzx eax, ax
    print_hex_newline

    print_eflags		; CF = 0, OF = 0, ZF = 0, SF = 0

    call io_newline

    ; SHRD
    mov ax, 0x42		; 42 = 01000010
    mov bx, 0x55		; 55 = 01010101
    shrd ax, bx, 3		; 01000010 >> 3 + 1010 0000 0000 0000 = 1010 0000 0000 1000 =  a008
    save_eflags
    movzx eax, ax
    print_hex_newline

    print_eflags		; CF = 0, OF = 1, ZF = 0, SF = 1

    ret
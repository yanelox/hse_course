; ../lib/build_asm.sh checkup.s

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
    ; --------------------------------------------------
    ; 1) SHL — логический сдвиг влево
    ; --------------------------------------------------
    mov al, 0x40        ; 0100 0000
    shl al, 1           ; -> 1000 0000
    save_eflags
    print_eflags
    call io_newline
    ; --------------------------------------------------
    ; 2) SHR — логический сдвиг вправо
    ; --------------------------------------------------
    mov al, 0x81        ; 1000 0001
    shr al, 1           ; -> 0100 0000
    save_eflags
    print_eflags
    call io_newline
    ; --------------------------------------------------
    ; 3) SAR — арифметический сдвиг вправо
    ; --------------------------------------------------
    mov al, 0x81        ; 1000 0001  (-127)
    sar al, 1           ; -> 1100 0000
    save_eflags
    print_eflags
    call io_newline
    ; --------------------------------------------------
    ; 4) ROL — циклическое вращение влево
    ; --------------------------------------------------
    mov al, 0x81        ; 1000 0001
    rol al, 1           ; -> 0000 0011
                        ; CF = 1, OF = MSB^CF = 0
                        ; ZF/SF не меняются
    save_eflags
    print_eflags
    call io_newline
    ; --------------------------------------------------
    ; 5) ROR — циклическое вращение вправо
    ; --------------------------------------------------
    mov al, 0x81        ; 1000 0001
    ror al, 1           ; -> 1100 0000
                        ; CF = 1, OF = MSB^bit6 = 0
    save_eflags
    print_eflags
    call io_newline
    ; --------------------------------------------------
    ; 6) RCL — вращение через CF влево
    ; --------------------------------------------------
    stc                 ; CF = 1
    mov al, 0x80        ; 1000 0000
    rcl al, 1           ; -> 0000 0001
                        ; CF = 1, OF = MSB^CF = 1
    save_eflags
    print_eflags
    call io_newline
    ; --------------------------------------------------
    ; 7) RCR — вращение через CF вправо
    ; --------------------------------------------------
    clc                 ; CF = 0
    mov al, 0x01        ; 0000 0001
    rcr al, 1           ; -> 0000 0000
                        ; CF = 1, OF = MSB^bit6 = 0
    save_eflags
    print_eflags
    call io_newline
    ; --------------------------------------------------
    ; 8) TEST — логическое И без сохранения результата
    ; --------------------------------------------------
    mov al, 0x80        ; 1000 0000
    test al, al         ; результат не записывается
                        ; ZF = 0, SF = 1, CF = 0, OF = 0
    save_eflags
    print_eflags
    call io_newline
    ret
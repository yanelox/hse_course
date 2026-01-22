; ../lib/build_asm.sh const.s

extern io_print_hex, io_newline, io_print_dec

NUM1 equ 42
NUM2 equ NUM1 + 69

section .text

global main

main:
	mov eax , NUM1
	call io_print_dec
	call io_newline

	mov eax , NUM2
	call io_print_dec
	call io_newline
	
	xor eax , eax
	ret
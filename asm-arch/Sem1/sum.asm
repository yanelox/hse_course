; ../lib/build_asm.sh sum.asm

extern io_get_dec , io_print_dec , io_newline

section .text

global main

main:
	call io_get_dec
	mov ebx, eax
	call io_get_dec
	add eax, ebx
	call io_print_dec
	call io_newline
	xor eax, eax
	ret
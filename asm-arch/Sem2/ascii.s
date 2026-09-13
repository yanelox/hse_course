; ../../lib/build_asm.sh ascii.s
; llvm-objdump ascii -s > objdump.txt

extern io_print_string, io_print_hex, io_newline

section .data
	str : db `Hello , world!\n`, 0

section .text

global main

main:
	; This is a comment
	mov eax , str
	call io_print_string
	mov eax , str
	call io_print_hex
	call io_newline
	xor eax , eax
	ret
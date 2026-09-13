; ../lib/build_asm.sh hello_world.s

extern io_print_string

section .data
	str : db `Hello , world!\n`, 0

section .text

global main

main:
	; This is a comment
	mov eax , str
	call io_print_string
	xor eax , eax
	ret
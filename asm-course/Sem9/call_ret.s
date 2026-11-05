; ../lib/build_asm.sh call_ret.s
; objdump call_ret -d > objdump.txt

global main
extern io_print_hex, io_newline

section .text

print_ret_address:
    mov eax, [esp]
    call io_print_hex
    call io_newline
    ret

main:
    call print_ret_address

    xor eax, eax
    ret

extern scanf, printf, fopen, fclose, fprintf

%macro scanf_string_with_check_to 1
    sub esp, 16
    mov dword [esp], scanf_fmt
    mov dword [esp + 4], %1
    call scanf
    add esp, 16

    cmp eax, 1
    jne .error
%endmacro

section .data
    scanf_fmt : db "%s",0
    printf_fmt : db "%s",10,0
    out_error : db "Shit happened",10,0
    fopen_flags : db "w+",0

section .bss
    file_name resb 64
    text_buff resb 64
    file_descriptor resd 1

section .text

print_error:
    push ebp
    mov ebp, esp
    and esp, -16

    sub esp, 16
    mov dword [esp], out_error
    call printf
    add esp, 16

    leave
    ret

global main
main:
    push ebp
    mov ebp, esp
    and esp, -16

    ; read filename
    scanf_string_with_check_to file_name

    ; open file
    sub esp, 16

    mov dword [esp], file_name
    mov dword [esp + 4], fopen_flags
    call fopen

    add esp, 16

    mov [file_descriptor], eax

    ; read text
    scanf_string_with_check_to text_buff

    ; write text to file
    sub esp, 16

    mov eax, [file_descriptor]
    mov dword [esp], eax
    mov dword [esp + 4], printf_fmt
    mov dword [esp + 8], text_buff
    call fprintf

    add esp, 16

    ; close file
    sub esp, 16

    mov eax, [file_descriptor]
    mov dword [esp], eax
    call fclose

    add esp, 16

.end:
    xor eax, eax
    leave
    ret

.error:
    call print_error
    mov eax, -1
    leave
    ret

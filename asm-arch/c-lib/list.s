; add push-front, print-list, reverse - task on seminar

extern printf, scanf, calloc, free

; struct Node {
;     int value;
;     struct Node* next;
; };
; size - 8b

NODE_SIZE equ 8

section .data
    out_error : db "Shit happened: %d",10,0

section .bss
    list_head resd 1

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

; ----
; FUNC_NAME make_node
; DESCRIPTION: allocate memory for 1 node
; EXPECTS: value for Node.value
; RETURNS: pointer to new node
; ----
make_node:
    push ebp
    mov ebp, esp 
    and esp, -16

    sub esp, 16
    mov dword [esp], 1
    mov dword [esp + 4], NODE_SIZE
    call calloc
    add esp, 16

    cmp eax, 0
    je .end

    mov edx, [ebp + 8]
    mov dword [eax], edx
.end:
    leave
    ret

; ----
; FUNC_NAME delete_list
; DESCRIPTION: delete list
; EXPECTS: pointer to head
; RETURNS: 0
; ----
delete_list:
    push ebp
    mov ebp, esp
    and esp, -16

    mov eax, [ebp + 8] ; take pointer to head

    sub esp, 16
.L1:
    cmp eax, 0
    je .end

    mov edx, [eax + 4]  ; eax points to Node -> points to Node.value  
                        ; eax + 4 points to Node.next
    mov [esp + 4], edx  ; save Node.next to esp + 4 
    
    mov [esp], eax
    call free

    mov eax, [esp + 4] ; restore 

    jmp .L1

.end:
    add esp, 16
    leave
    ret

; ----
; FUNC_NAME push_back
; DESCRIPTION: push value to the end of the list
; EXPECTS: pointer to head, value to push
; RETURNS: 0
; ----
push_back:
    push ebp
    mov ebp, esp
    and esp, -16

    mov edx, [ebp + 8]  ; take pointer to head

.L1:
    mov eax, edx
    mov edx, [eax + 4]
    cmp edx, 0
    jne .L1

    push eax
    sub esp, 12
    mov eax, [ebp + 12]     ; takes value
    mov [esp], eax
    call make_node
    add esp, 12

    mov edx, eax    ; pointer to new node in edx
    pop eax         ; pointer to old last node in eax

    mov dword [eax + 4], edx    ; Node.next = new Node
.end:
    leave
    ret


global main
main:
    push ebp
    mov ebp, esp
    and esp, -16

.make_head:
    ; make a list head
    sub esp, 16
    mov dword [esp], 42
    call make_node
    add esp, 16

    ; check calloc result
    cmp eax, 0
    je .error
    mov [list_head], eax

.push_back:
    ; push back value
    sub esp, 16
    mov eax, [list_head]
    mov [esp], eax
    mov dword [esp + 4], 69
    call push_back
    add esp, 16

.delete:
    sub esp, 16
    mov eax, [list_head]
    mov [esp], eax
    call delete_list
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
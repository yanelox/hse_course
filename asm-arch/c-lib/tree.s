extern printf, scanf, calloc, free

; struct Node {
;     int value;
;     struct Node* left;
;     struct Node* right;
; };
; size - 12b

NODE_SIZE equ 12

section .data
    out_error : db "Shit happened: %d",10,0

section .bss
    tree_head resd 1

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
; FUNC_NAME delete_tree
; DESCRIPTION: delete tree
; EXPECTS: pointer to head
; RETURNS: 0
; ----
delete_tree:
    push ebp
    mov ebp, esp
    and esp, -16

    mov eax, [ebp + 8]
    cmp eax, 0
    je .end

    sub esp, 16

    mov eax, [ebp + 8]  ; eax = pointer to head
    mov eax, [eax + 4]  ; Node.left
    mov [esp], eax
    call delete_tree

    mov eax, [ebp + 8]  ; eax = pointer to head
    mov eax, [eax + 8]  ; Node.right
    mov [esp], eax
    call delete_tree

    mov eax, [ebp + 8]
    mov [esp], eax
    call free

    add esp, 16

.end:
    leave
    ret

; ----
; FUNC_NAME push_val
; DESCRIPTION: add value to a tree
; EXPECTS: pointer to head, value
; RETURNS: 1 if val already exitst, -1 if list_head is nullptr, otherwise 0
; ----
push_val:
    push ebp
    mov ebp, esp
    and esp, -16

    mov eax, [ebp + 8]  ; ecx = pointer to head
    cmp eax, 0
    jne .L1
    mov eax, -1
    leave
    ret

.L1:
    cmp eax, 0
    je .add_val

    mov ecx, [eax]
    mov edx, [ebp + 12] ; edx = new val
    cmp edx, ecx
    jl .left
    jg .right

.equal:
    mov eax, 1
    leave
    ret

.left:
    lea ecx, [eax + 4]
    mov eax, [eax + 4]
    jmp .L1

.right:
    lea ecx, [eax + 8]
    mov eax, [eax + 8]
    jmp .L1

.add_val:
    push ecx
    sub esp, 12

    mov eax, [ebp + 12]
    mov [esp], eax
    call make_node

    add esp, 12
    pop ecx

    mov [ecx], eax

.end:
    xor eax, eax
    leave
    ret

global main
main:
    push ebp
    mov ebp, esp
    and esp, -16

.make_head:
    ; make a tree head
    sub esp, 16
    mov dword [esp], 42
    call make_node
    add esp, 16

    ; check calloc result
    cmp eax, 0
    je .error
    mov [tree_head], eax

.push_values:
    sub esp, 16

    mov eax, [tree_head]
    mov [esp], eax

    mov dword [esp + 4], 69
    call push_val

    mov dword [esp + 4], 123
    call push_val

    mov dword [esp + 4], 55
    call push_val

    mov dword [esp + 4], 31
    call push_val

    add esp, 16

.delete:
    sub esp, 16
    mov eax, [tree_head]
    mov [esp], eax
    call delete_tree
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
%macro pushd 0
    push edx
    push ecx
    push ebx
    push eax
%endmacro

%macro popd 0 
    pop eax
    pop ebx
    pop ecx
    pop edx
%endmacro

%macro print 2
    pushd
    mov edx, %1
    mov ecx, %2
    mov ebx, 1
    mov eax, 4
    int 0x80
    popd
%endmacro

%macro dprint 0
    pushd
    
    mov ecx, 10
    mov bx, 0
    
    %%_divide:
        mov edx, 0
        div ecx
        push dx
        inc bx
        test eax, eax
        jnz %%_divide
        
    mov cx, bx

    %%_digit:
        pop ax
        add ax, '0'
        mov [count], ax
        print 1, count
        dec cx
        mov ax, cx
        cmp cx, 0
        jg %%_digit
    
    popd
%endmacro


section .text

global _start

_start:
    mov al, 144
    mov cl, al
    mov bl, 2
    div bl
    mov ah, 0
    mov [array+1], al
    
_loop:
    mov [array], al
    mov al, cl
    mov bl, [array]
    div bl
    mov ah, 0

    add al, [array]

    mov bl, 2
    div bl
    mov ah, 0
    mov [array+1], al
    mov bl, [array]
    sub bl, 1
    cmp bl, [array+1]
    jge _loop
    
    dprint
    print nlen, newline
    
    
    
    print nlen, newline
    print len, message
    print nlen, newline
   
    mov     eax, 1
    int     0x80

section .data
    array db 1,1
    alen equ $ - array
    message db "Done"
    len equ $ - message
    newline db 0xA, 0xD
    nlen equ $ - newline
    
section .bss
    count resb 1

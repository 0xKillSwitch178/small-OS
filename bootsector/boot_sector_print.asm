print_nl:
    pusha

    mov ah, 0x0e ;tty mode
    mov al, 0x0a ; \n
    int 0x10
    mov al, 0x0d ; cariage return
    int 0x10

    popa
    ret


print:
    pusha
    
    start:
        mov al, [bx]
        cmp al, 0
        je done

        mov ah, 0x0e
        int 0x10

        add bx, 1
        jmp start
    
    done:
        popa
        ret
    

print_hex:
    pusha
     mov cx, 0 ; our index variable

    hex_loop:
        cmp cx, 4 ; loop 4 times
        je end
        
        mov ax, dx 
        and ax, 0x000f 
        add al, 0x30 
        cmp al, 0x39 
        jle step2
        add al, 7 

    step2:
        mov bx, HEX_OUT + 5 
        sub bx, cx  
        mov [bx], al 
        ror dx, 4 

        add cx, 1
        jmp hex_loop

    end:
        mov bx, HEX_OUT
        call print

        popa
        ret

    HEX_OUT:
        db '0x0000',0 ; reserve memory for our new string
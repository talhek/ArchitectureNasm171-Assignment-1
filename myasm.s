section .data                    	; data section, read-write
        an:    DD 0              	; this is a temporary var

section .text                    	; our code is always in the .text section
        global do_Str          	; makes the function appear in global scope
        extern printf            	; tell linker that printf is defined elsewhere 							; (not used in the program)

do_Str:                        	; functions are defined as labels
        push    ebp              	; save Base Pointer (bp) original value
        mov     ebp, esp         	; use base pointer to access stack contents
        pushad                   	; push all variables onto stack
        mov ecx, dword [ebp+8]	; get function argument

;;;;;;;;;;;;;;;; FUNCTION EFFECTIVE CODE STARTS HERE ;;;;;;;;;;;;;;;; 

	mov	dword [an], 0		      ; initialize answer
	label_here:

        cmp byte[ecx],'('         ;compar with '('
        je change1
        cmp byte[ecx], ')'
        je change2

        cmp byte[ecx], 'A'        ; compare with 'A'
        jl counter                ; if less than 'A', jump to counter
        cmp byte[ecx], 'Z'        ; compare with 'Z'
        jg check_lower            ; if greater than 'Z', jumpt to check lower
        jmp continue

    change:
        sub byte[ecx], 32         ; convert to upper case
        jmp continue
   	
    change1:
        mov byte[ecx], 60         ; change '(' to '<'
        jmp counter

    change2:
        mov byte [ecx], 62        ; change ')' to '>'
        jmp counter
    
    counter:
        inc dword[an]             ; increment an
        jmp continue
    
    check_lower:
        cmp byte[ecx], 'a'        ; compare with 'a'
        jl counter                ; if >'Z' && <'a'
        cmp byte[ecx], 'z'        ; compare with 'z'
        jle change                ; if >='a' and <= 'z'
        jmp counter

    continue:
		inc ecx      	          ; increment pointer
		cmp byte [ecx], 0         ; check if byte pointed to is zero
		jnz label_here            ; keep looping until it is null terminated


;;;;;;;;;;;;;;;; FUNCTION EFFECTIVE CODE ENDS HERE ;;;;;;;;;;;;;;;; 

         popad                    ; restore all previously used registers
         mov     eax,[an]         ; return an (returned values are in eax)
         mov     esp, ebp
         pop     ebp
         ret 
		 

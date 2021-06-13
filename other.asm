; A library to be linked to an another 
; obj file containg methods to call 
; write, read, reset functionality
 

section .data

section .bss
	
section .text

global RESET, WRITE, READ, SOLVE, END
extern BUFFER, RESULT, RESULTLEN, HEXDIGITS, BUFFERLEN, RESET_WORD

RESET: mov ax, word[RESET_WORD]
       
       mov word[RESULT+0], ax
       mov byte[RESULT+2], 020h		; add space
       
       mov word[RESULT+3], ax
       mov byte[RESULT+5], 020h
       
       mov word[RESULT+6], ax
       mov byte[RESULT+8], 020h
       
       mov word[RESULT+9], ax
       ret
       


READ: 	mov eax, 3	 	; choose sys_read
	mov ebx, 0	 	; choose STDIN
	mov ecx, BUFFER  	; copy Buffer-Address
	mov edx, BUFFERLEN 	; read 4 bytes into BUFFER
	int 80h		; make call
	ret 

	; DOESNT RETURN ANYTHING WRITE BACK RESULT INTO MEMORY 
	; TAKE INPUT ECX
	
SOLVE:	pushad				; push back all registers
	mov al, [BUFFER+ecx]		; Get one byte of user-input adjusted by counter in ax
	mov bl, al			; Get a copy so you can isolate high-4 bits 			
	and eax, 0Fh			; Isolated lower 4 bits
	and ebx, 0F0h			; Isolated higher 4 bits
	shr bl, 04h			; right shift bl by 4 bits to adjust index
	
	mov ah, byte[HEXDIGITS+eax]	; Store al HEX EQUIVALENT in AH (LOW)
	mov bh, byte[HEXDIGITS+ebx]	; Store bl HEX EQUIVALENT in BH (HIGH)

	mov bl, ah			; Combine Both HEX Digits into one COMPLETE-BYTE
	xchg bh, bl			; switch the values of them
	mov word[RESULT+edx], bx 	; Store result Back to memory in RESULT
	popad				; pop back all registers
	ret				; Return to the caller

END:    mov eax, 1			; specify sys_exit
	mov ebx, 0			; exit code 0
	int 80h			; call sys_exit

WRITE: pushad				; push back all registers
       mov eax, 4			; specify sys_write
       mov ebx, 1			; write to standard output
       mov ecx, RESULT			; pass result address
       mov edx, RESULTLEN		; pass result length
       int 80h				; make system call
       popad 				; pop back all registers
       ret		  		; Return to the caller


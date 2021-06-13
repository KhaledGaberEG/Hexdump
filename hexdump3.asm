; A simple Program That Read 4 Bytes at a time 
; from standard input convert them to hex then 
; write them back to stdout 
; THIS IS AN EXTENSION USING EXTERNAL PROCEDURES 
; AUTHOUR: KHALED GABER
section .data
	RESET_WORD: dw"00"

	RESULT: db"00 00 00 00",10
	RESULTLEN: equ $-RESULT

	HEXDIGITS: db"0123456789ABCDEF"
	HEXLENGTH: equ $-HEXDIGITS

section .bss
	
	BUFFER: resb 4			; reserve 16 Bytes to buffer
	BUFFERLEN equ 4
	
section .text

extern END, WRITE, RESET, READ, SOLVE
global BUFFER, BUFFERLEN, HEXDIGITS, RESULT, RESULTLEN, RESET_WORD 

global _start
_start:

START:	call READ
		; Check read return value back	
	cmp eax, 0			; check sys_read return value
	mov ecx, 0			; RESET number to solve to ecx(counter)
	mov edx, 0			; RESET result counter
	ja NEXT	  		; END if Zero is reached(EOF)
	call END			; call END if eax <= 0

NEXT:	call SOLVE			; solve one byte
	inc ecx			; increment solved counter
	add edx, 3			; increment result counter
	cmp ecx, eax			; Compare Number written to Number READ
	jb  NEXT			; go to next if ecx <= eax
	call WRITE			; Call write
	call RESET			; RESET line
	jmp  START			; call read for next 4 bytes


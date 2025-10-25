%ifndef IO_ASM
%define IO_ASM
;----------------------------
;printing individual numbers
;----------------------------

;prHex
;prints a hexadecimal representation of a letter in eax
;inputs:
; eax = letter to print
;outputs:
; terminal: hex representation of eax
;ex:
; eax = 0xff
; call prHex
; output stream = "ff"
;
; eax = 0x1e
; call prHex
; output stream = "1e"
hexTable: db "0123456789abcdef"
prHex:
	pusha
	xor cx, cx	
	mov esi, 0x10
.loop:
	xor edx, edx
	div esi
	push edx
	inc cx
	cmp eax, 0
	jne .loop
	mov ah, 0x0e
.print:
	pop ebx
	add ebx, hexTable
	mov al, [ebx]
	int 0x10
	loop .print
.end:
	mov al, ','
	int 0x10
	popa
	ret

;-----------------------
;text print statements
;-----------------------

;print
;prints a null terminated string to the terminal
;inputs:
; si: pointer to the string
;outputs:
; terminal should have your string
print:
	pusha
	mov ah, 0x0e
.loop:
	lodsb
	cmp al, 0
	je .end
	int 0x10
jmp .loop
.end:
	popa
	ret

;printL
;prints a non null terminated string to the terminal
;inputs:
; si: pointer to the string
; cx: length of string
;outputs:
; terminal should have your string
printL:
	pusha
	mov ah, 0x0e
.loop:
	lodsb
	int 0x10
	loop .loop
.end:
	popa
	ret

%ifndef BOOTSEC

%endif
%endif

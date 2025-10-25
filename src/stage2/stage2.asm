[org 0x1000]
mov si, victoryText
call print
jmp $


;inputs:
; si: pointer to the string
;outputs:
; si: end of string
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

victoryText: db 0xa, 0xd, "successfully loaded into stage 2"

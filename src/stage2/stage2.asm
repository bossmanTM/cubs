[org 0x1000]
mov si, victoryText
call print
jmp $

%include "IO.asm"

victoryText: db 0xa, 0xd, "successfully loaded into stage 2"

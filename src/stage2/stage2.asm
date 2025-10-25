[org 0x7e00]
mov si, victoryText
call print
jmp $

%include "IO.asm"

victoryText: db 0xa, 0xd, "successfully loaded into stage 2"

%include "defs.asm"
[org STAGE2_LOCATION]
mov si, victoryText
call print
jmp $

%include "IO.asm"

victoryText: db 0xa, 0xd, "successfully loaded into stage 2"

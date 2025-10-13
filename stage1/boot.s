;BIOS parameter block
;Note i am only referencing the location of these parameters as a macro because i am not going to be making the file system
OEMName equ 0x7c03 ;name of whoever formatted this disk
BytsPerSec equ 0x7c0b ;amount of bytes in a sector
ClusSize equ 0x7c0d ;amount of sectors in a cluster
RsvdSecCnt equ 0x7c0e ;amount of sectors that are reserved
NumFats equ 0x7c10  ; number of fats, should be two but we do not actually care and will only use one
RootEntCnt equ 0x7c11 ; contains the amount of entries in the root directory
TotalSec16 equ 0x7c13 ; contains the total count of sectors in the volume (0 for FAT32)
Media equ 0x7c15 ; not used anymore for anything but stores the type of media this is on
FATSz16 equ 0x7c16 ; contains the amount of sectors occupied by one FAT, 0 on FAT32
SPT equ 0x7c18 ; amount of sectors on one track only relevant if the disk has tracks that can be seen by int 0x13
HPC equ 0x7c1a ; number of heads for int 0x13 also only relevant in the same conditions as SecPerTrk
HiddSec equ 0x7c1c ; count of hidden sectors before the partition containing this volume
TotSec32 equ 0x7c20 ;bit count of sectors on the volume
;----------------------
;FAT12/16 specifics   
;----------------------
DrvNum16 equ 0x7c24 ; drive number for use with int 0x13 
Reserved116 equ 0x7c25 ; reserved for windows NT (will always be zero)
BootSig16 equ 0x7c26 ; extended boot signature (should be 0x29 to indicate the next 3 are present on FAT16/12)
VOLID16 equ 0x7c27 ; volume serial number used for device tracking, usually set to the date and time at the time of creation
VolLab16 equ 0x7c2b ; matches the 11 byte label in the root directory and should be set to "NO NAME    " when there is no label
FilSysType equ 0x7c36 ; literally just the name of the filesystem, should be set to either "FAT12   ", "FAT16   ", or "FAT     "
;----------------------
;FAT32 specifics
;----------------------
FATSz32 equ 0x7c24 ; amount of sectors occupied by one FAT
ExtFlags32 equ 0x7c28 	; bits 0-3: number of active FAT only active if mirroring is disabled (idk what mirroring is either lmao(nvm figured it out(see bit 7))
					; bits 4-6: reserved (idk what for)
					; bit 7: 0 means the FAT is mirrored at runtime into all FATS 1 means only one FAT is active
FSVer32 equ 0x7c2a ; version number, high bite is major revision low is minor (this program is made for 0.0)
RootClus32 equ 0x7c2c ; set to the cluster number of the first cluster(usually 2 but not required to be)
FSInfo32 equ 0x7c30 ; sector number of filesystem info sector(usually 1)
BkBootSec32 equ 0x7c32 ; sector of the backup boot sector just in case (tbh im prolly not gonna do anything with the backup but well see)
Reserved32 equ 0x7c34 ; reserved for future updates (see how much more clever the devs were compared to the FAT12 and FAT16 devs)
DrvNum32 equ 0x7c40 ; same thing as on FAT16/12 but in a different spot
Reserved132 equ 0x7c41 ; more dealing with fucking windows NT because they think they are better than us
BootSig32 equ 0x7c42 
VolID32 equ 0x7c43
VolLab32 equ 0x7c47
FilSysType32 equ 0x7c52

selectedFatSector equ 0
 
boot:
[org 0x7c5a]
mov [DriveNum], dl
xor ax, ax
mov ds, ax
mov es, ax
mov cs, ax
mov ss, ax
mov fs, ax
mov gs, ax

mov si, FilSysType32
mov cx, 8
call printL

;testing
;mov ah, 0x42
;mov dl, 0x80
;mov si , DAPI13
;int 0x13
;jc error
;mov si, 0x7e00
;call print
xor ebx, ebx
mov eax, [FATSz32]
mov bl, [NumFats]
mul ebx
push eax

;load start of root directory to memory
mov eax, [RootClus32]
sub eax, 2
mov bl, [ClusSize]
mul ebx
mov bx, [RsvdSecCnt]
add eax, ebx
pop ebx
add eax, ebx
mov [DAPAddr], eax
mov ah, 0x42
mov dl, [DriveNum]
mov si, DAP
int 0x13
jc error
mov si, 0x7e00
call print
;find FAT

;load FAT to memory


jmp $

debp:
pusha
mov ah, 0x0e
mov al, ','
int 0x10
popa
ret

prInt:
	pusha
	xor cx, cx
	mov esi, 10
.loop:
	xor edx, edx
	div esi
	push edx
	inc cx
	cmp eax, 0
	jne .loop
.print:
	pop eax
	or al, 0x30
	mov ah, 0x0e
	int 0x10
	loop .print
	popa
	ret

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
	popa
	ret

;inputs:
; si: pointer to the string
;outputs:
; si: end of string
print:
push ax
mov ah, 0x0e
.loop:
lodsb
cmp al, 0
je .end
int 0x10
jmp .loop
.end:
pop ax
ret

;inputs:
; si: pointer to the string
; cx: length of string
;outputs:
;
printL:
pusha
mov ah, 0x0e
.loop:
lodsb
int 0x10
loop .loop
popa
ret

error:
call prHex
mov si, errorMessage
call print
jmp $
errorMessage: db "there was an error", 0

DriveNum: db 0

;might throw this to a random piece of memory in the future tbh
DAP:
DAPSize: db 0x10
DAPUnused: db 0 ;WHY ARE THERE ALWAYS UNUSED BYTES
DAPSecs: dw 1 ;sometimes cant be over 127
DAPBuf:  ; where to place it 
DAPBufOff: dw 0x7e00
DAPBufSeg: dw 0x0000
DAPAddr: dq 0x00000000
times 510-90-($-$$) db 0
dw 0xaa55

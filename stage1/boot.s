;BIOS parameter block
;Note i am only referencing the location of these parameters as a macro because i am not going to be making the file system
OEMName equ 3 ;name of whoever formatted this disk
BytsPerSec equ 11 ;amount of bytes in a sector
SecPerClus equ 13 ;amount of sectors in a cluster
RsvdSecCnt equ 14 ;amount of sectors that are reserved
NumFats equ 16  ; number of fats, should be two but we do not actually care and will only use one
RootEntCnt equ 17 ; contains the amount of entries in the root directory
TotalSec16 equ 19 ; contains the total count of sectors in the volume (0 for FAT32)
Media equ 21 ; not used anymore for anything but stores the type of media this is on
FATSz16 equ 22 ; contains the amount of sectors occupied by one FAT, 0 on FAT32
SecPerTrk equ 24 ; amount of sectors on one track only relevant if the disk has tracks that can be seen by int 0x13
NumHeads equ 26 ; number of heads for int 0x13 also only relevant in the same conditions as SecPerTrk
HiddSec equ 28 ; count of hidden sectors before the partition containing this volume
TotSec32 equ 32 ; 32 bit count of sectors on the volume
;----------------------
;FAT12/16 specifics   
;----------------------
DrvNum16 equ 36 ; drive number for use with int 0x13 
Reserved116 equ 37 ; reserved for windows NT (will always be zero)
BootSig16 equ 38 ; extended boot signature (should be 0x29 to indicate the next 3 are present on FAT16/12)
VOLID16 equ 39 ; volume serial number used for device tracking, usually set to the date and time at the time of creation
VolLab16 equ 43 ; matches the 11 byte label in the root directory and should be set to "NO NAME    " when there is no label
FilSysType equ 54 ; literally just the name of the filesystem, should be set to either "FAT12   ", "FAT16   ", or "FAT     "
;----------------------
;FAT32 specifics
;----------------------
FATSz32 equ 36 ; amount of sectors occupied by one FAT
ExtFlags32 equ 40 	; bits 0-3: number of active FAT only active if mirroring is disabled (idk what mirroring is either lmao(nvm figured it out(see bit 7))
					; bits 4-6: reserved (idk what for)
					; bit 7: 0 means the FAT is mirrored at runtime into all FATS 1 means only one FAT is active
FSVer32 equ 42 ; version number, high bite is major revision low is minor (this program is made for 0.0)
RootClus32 equ 44 ; set to the cluster number of the first cluster(usually 2 but not required to be)
FSInfo32 equ 48 ; sector number of filesystem info sector(usually 1)
BkBootSec32 equ 50 ; sector of the backup boot sector just in case (tbh im prolly not gonna do anything with the backup but well see)
Reserved32 equ 52 ; reserved for future updates (see how much more clever the devs were compared to the FAT12 and FAT16 devs)
DrvNum32 equ 64 ; same thing as on FAT16/12 but in a different spot
Reserved132 equ 65 ; more dealing with fucking windows NT because they think they are better than us
BootSig32 equ 66 
VolID32 equ 67
VolLab32 equ 71
FilSysType32 equ 82

boot:
mov ax, 0x07c0
mov ds, ax
xor ax, ax
mov cs, ax
mov ss, ax
mov es, ax
mov fs, ax
mov gs, ax
mov bp, 0x8000
mov sp, bp

mov si, FilSysType32
mov cx, 8
call printL



jmp $
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

message: db "hello world", 0

times 510-90-($-$$) db 0
dw 0xaa55

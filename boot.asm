; boot.asm - Michael's Homelab Fleet Bootloader
; A simple 512-byte bootloader that prints a message

[BITS 16]           ; 16-bit real mode
[ORG 0x7C00]        ; BIOS loads us at 0x7C00

start:
    ; Clear the screen using BIOS interrupt
    mov ah, 0x00
    mov al, 0x03    ; 80x25 text mode
    int 0x10

    ; Set cursor position to top-left
    mov ah, 0x02
    mov bh, 0x00
    mov dh, 0x00
    mov dl, 0x00
    int 0x10

    ; Print the message
    mov si, message
    call print_string

    ; Halt the CPU
    cli             ; disable interrupts
hang:
    hlt             ; halt
    jmp hang        ; infinite loop

; Function: print_string
; Prints a null-terminated string pointed to by SI
print_string:
    mov ah, 0x0E    ; BIOS teletype function
.loop:
    lodsb           ; load byte from SI into AL, increment SI
    cmp al, 0
    je .done
    int 0x10        ; print character in AL
    jmp .loop
.done:
    ret

; Data
message:
    db '============================================', 0x0D, 0x0A
    db '    MICHAELs HOMELAB FLEET BOOTLOADER', 0x0D, 0x0A
    db '============================================', 0x0D, 0x0A
    db 0x0D, 0x0A
    db '  Fleet Status: 7 machines, 1 Pi camera', 0x0D, 0x0A
    db '  Tailscale:    Connected', 0x0D, 0x0A
    db '  Monitoring:   Grafana + Prometheus', 0x0D, 0x0A
    db '  AI:           Ollama (self-hosted)', 0x0D, 0x0A
    db '  Cluster:      Kubernetes k3s (3 nodes)', 0x0D, 0x0A
    db 0x0D, 0x0A
    db '  Written in x86 assembly.', 0x0D, 0x0A
    db '  512 byte bootloader.', 0x0D, 0x0A
    db 0

; Pad the rest with zeros and add the boot signature
times 510 - ($ - $$) db 0
dw 0xAA55           ; magic boot signature at the end

; boot_pm.asm
[BITS 16]
[ORG 0x7C00]           ; Punto de entrada del bootloader

start:
    cli                ; Deshabilitar interrupciones

    lgdt [gdt_descriptor] ; Cargar GDT

    mov eax, cr0       ; Leer CR0
    or eax, 1          ; Activar modo protegido (bit PE)
    mov cr0, eax

    jmp 0x08:protected_mode_start ; Salto lejano: cambia a modo protegido

; ------------------------------------
; GDT con solo un descriptor de código
; ------------------------------------
gdt_start:
    dq 0x0000000000000000       ; Descriptor nulo (index 0)

    ; Descriptor de código plano (index 1 → selector 0x08)
    dw 0xFFFF                   ; Límite (15:0)
    dw 0x0000                   ; Base (15:0)
    db 0x00                     ; Base (23:16)
    db 0x9A                     ; Acceso: código presente, ejecutable, legible
    db 0xCF                     ; Flags: gran = 1, 32-bit = 1, límite alto
    db 0x00                     ; Base (31:24)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1 ; Tamaño GDT - 1
    dd gdt_start               ; Dirección base GDT

; -------------------------
; Código en modo protegido
; -------------------------
[BITS 32]
protected_mode_start:
    hlt                 ; Detiene la CPU (útil para testear que llegamos)

; -------------------------
; Boot sector (512 bytes)
; -------------------------
times 510-($-$$) db 0
dw 0xAA55               ; Firma del bootloader

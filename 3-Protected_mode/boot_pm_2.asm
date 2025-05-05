; boot_pm_ro.asm
[BITS 16]
[ORG 0x7C00]

start:
    cli                             ; Deshabilitar interrupciones

    lgdt [gdt_descriptor]           ; Cargar GDT

    mov eax, cr0
    or eax, 1                       ; Activar el modo protegido (bit PE)
    mov cr0, eax

    jmp 0x08:protected_mode_start   ; Salto lejano al segmento de código (selector 0x08)

; --------------------------
; GDT con dos descriptores:
; --------------------------
gdt_start:
    dq 0x0000000000000000           ; Descriptor nulo (índice 0)

    ; Descriptor de código plano (índice 1 → selector 0x08)
    dw 0xFFFF                       ; Límite (15:0)
    dw 0x0000                       ; Base (15:0)
    db 0x00                         ; Base (23:16)
    db 0x9A                         ; Acceso: código ejecutable, presente, RPL=0
    db 0xCF                         ; Flags: gran=1 (4KiB), 32-bit=1
    db 0x00                         ; Base (31:24)

    ; Descriptor de datos solo lectura (índice 2 → selector 0x10)
    dw 0xFFFF                       ; Límite (15:0)
    dw 0x0000                       ; Base (15:0)
    db 0x10                         ; Base (23:16) → 0x00100000 >> 16
    db 0x90                         ; Acceso: datos solo lectura, presente, RPL=0
    db 0xCF                         ; Flags
    db 0x00                         ; Base (31:24)

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; -----------------------------
; Código en modo protegido
; -----------------------------
[BITS 32]
protected_mode_start:
    ; Cargar selectores de segmento de datos (0x10 = índice 2 << 3)
    mov ax, 0x10
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Inicializar pila (dentro del segmento de datos solo lectura)
    mov esp, 0x00001000             ; offset dentro del segmento (total = base + offset)

    hlt                             ; Pausa para debug

    ; Esta instrucción debería causar un fallo de protección general
    mov dword [0x00000000], 0xDEADBEEF

    hlt                             ; No debería llegar acá

; ---------------------------
; Boot sector (512 bytes)
; ---------------------------
times 510 - ($ - $$) db 0
dw 0xAA55

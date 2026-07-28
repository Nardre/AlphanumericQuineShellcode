;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Purpose : Alphanumeric Quine Shellcode
;; Inputs  : EAX Quine Start Adresse - ESP+0x4 Quine Argv
;; Explanation : Nardre.com
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

bits 32
global _start

section .text
_start:
quine:
        ; --- initialisation ---
        pop     edx             ; Preserve stack alignment
        pop     ecx
        push    ecx
        push    edx

        push    ecx             ; Save quine argv
        push    eax             ; Save quine start address

        push    "0"
        pop     eax
        xor     al, "0"
        push    eax
        pop     edx             ; Set EAX = 0, EDX = 0

        aaa
        inc ecx
        dec ecx                 ; Padding

        ; --- Self Modifying Code (int 0x80) ---
        pop     ecx             ; Load quine start address
        dec     ax
        xor     ax, "a7"
        xor     [byte ecx + sys_write_off], ax
        xor     [byte ecx + sys_exit_off], ax

        ; --- sys_write (fd=STDOUT, buf=quine, count=quine_size) ---
        pop     ecx             ; Load quine argv
        inc     edx
        push    edx
        pop     eax
        inc     edx
        inc     edx
        inc     edx

        push    edx             ; pusha EAX (sys_write)
        push    ecx             ; pusha ECX (quine argv)
        push    len             ; pusha EDX (quine size)
        push    eax             ; pusha EBX (STDOUT)
        push    esp             ; pusha ESP
        push    ebp             ; pusha EBP
        push    esi             ; pusha ESI
        push    edi             ; pusha EDI
        popad                   ; Load sys_write registers
sys_write:
        dw      "SH"            ; Patched to "int 0x80"

        ; --- sys_exit (status=0) ---
        push    ebx
        pop     eax
        dec     ebx
sys_exit:
        dw      "SH"            ; Patched to "int 0x80"

        db      "QuineByNardre"
        sys_write_off equ sys_write - quine
        sys_exit_off  equ sys_exit - quine
        len equ $ - quine

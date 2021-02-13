*
* SPIR
*
basl    equ $28
cout    equ $FDED
home    equ $FC58
bascalc equ $FBC1
wait    equ $FCA8
timer   equ #$40

*
        org $4000
debut   jmp main
nblib   hex 00
curline hex 00
left    hex 00      ; marge gauche
right   hex 00      ; marge droite
top     hex 00      ; marge haute
bottom  hex 00      ; marge basse
;tempo   hex 00
col     hex 00
lig     hex 00
cpt     hex 00
lettre  asc "-" 
lettre2 asc "!"

main    nop
        jsr home
*
* ligne haute
*
vlineh  nop
        lda curline
        jsr bascalc
        ldy left
        lda #$28    ; 40 col.
        sec          
        sbc right   ; on soustrait la mage droite

        sec
        sbc left    ; on soustrait la mage gauche
        tax         ; ==> nombre caracteres de la ligne

        lda lettre
loop    sta (basl),y
        pha 
        lda timer
        jsr wait
        pla
        iny
        dex         ; compteur de caractères
        bne loop

*
* bord droit
*
bd      nop
        lda #$27
        sec
        sbc right
        sta col         ;  position de la colonne
        
        lda curline     ; calcul top et bottom
        cmp #$0B
        beq finbd
        clc
        adc #$01
        sta top         ; top
        lda #$17
        sec
        sbc curline
        sec
        sbc #$01
        sta bottom     ; bottom
        
        sec
        sbc top
        cmp #$01
        beq finbd      ; top = bottom ==> fin
        clc
        adc #$01
        sta cpt        ; compteur = bottom - top + 1
        lda top
        sta lig
loopbd  jsr bascalc
        lda lettre2
        ldy col
        sta (basl),y
        lda timer
        jsr wait
        inc lig
        lda lig
        dec cpt
        bne loopbd

finbd  nop


*
* ligne basse
*
vlineb  nop
        lda #$17
        sec
        sbc curline ; curline basse = 23 - curline
        jsr bascalc
        lda #$28    ; 40 col.
        sec
        sbc right
        tay         ; bord droit
        dey
        sec
        sbc left
        tax         ; nombre caracteres de la ligne

        lda lettre
loopb   sta (basl),y
        pha 
        lda timer
        jsr wait
        pla
        dey
        dex         ; compteur de caractères
        bne loopb

*
* bord gauche
*
bg      nop
        lda left
        sta col         ;  position de la colonne
        
        lda curline     ; calcul top et bottom
        cmp #$0B
        beq finbd
        clc
        adc #$01
        sta top         ; top
        lda #$17
        sec
        sbc curline
        sec
        sbc #$01
        sta bottom     ; bottom
        sec
        sbc top
        cmp #$01
        beq finbg      ; top = bottom ==> fin
        clc
        adc #$01
        sta cpt        ; compteur = bottom - top + 1
        lda bottom
        sta lig
loopbg  jsr bascalc
        lda lettre2
        ldy col
        sta (basl),y
        lda timer
        jsr wait
        dec lig
        lda lig
        dec cpt
        bne loopbg

finbg  nop

*
* looper
* 
        inc curline
        inc left
        inc right
        lda curline
        cmp #$0C
        beq fin
        jmp vlineh

fin     rts



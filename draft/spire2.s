*
* SPIR
*
basl    equ $28
cout    equ $FDED
home    equ $FC58
bascalc equ $FBC1
wait    equ $FCA8
timer   equ $01

*
        org $4000
debut   jmp main
nblib   hex 0C
curline hex 00
left    hex 00
right   hex 00
top     hex 00
bottom  hex 00
lettre  asc "o" 

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
* ligne basse
*
vlineb  nop
        lda #$17
        sec
        sbc curline ; curline basse = 23 - curline
        jsr bascalc
        ;ldy left
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
        inc curline
        inc left
        inc right
        lda left
        cmp #$0C
        bne vlineh

fin     rts



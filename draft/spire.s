*
* SPIR
*
lettre  equ #$C1
basl    equ $28
cout    equ $FDED
home    equ $FC58
bascalc equ $FBC1
wait    equ $FCA8

*
        org $4000
debut   jmp main
nblib   hex 0C
curline hex 00
left    hex 00
right   hex 00
top     hex 00
bottom  hex 00

main    nop
        jsr home

vlineh  nop
        lda curline
        jsr bascalc
        ldy left
        lda #$28    ; 40 col.
        sec
        sbc right
        sec
        sbc left
        tax         ; marge droite

        lda lettre
loop    sta (basl),y
        pha 
        lda #$40
        jsr wait
        pla
        iny
        dex
        bne loop
*
        inc curline
        inc left
        inc right
        lda left
        cmp #$0C
        bne vlineh

fin     rts



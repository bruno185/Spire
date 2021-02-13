*
* SPIRE aller - retour
*
* version finale 30/01/2021
* TODO : ne faire varier que curline, left et right (marge gauche et marge droite) = curline. 
* 
basl    equ $28
kbd     equ $C000
kbdstrb equ $C010
cout    equ $FDED
home    equ $FC58
bascalc equ $FBC1
wait    equ $FCA8
delay   equ $20
delay2  equ $0B

*
        org $4000
debut   jmp main
curline hex 00
left    hex 00      ; marge gauche
right   hex 00      ; marge droite
top     hex 00      ; marge haute
bottom  hex 00      ; marge basse
col     hex 00
lig     hex 00
cpt     hex 00
lettre  asc "-" 
lettre2 asc "!"
lettre3 asc "."
lettre4 asc " "
savl    hex 00000000    ; 4 octets pour sauver les lettre
timer   hex 00
timer2  hex 00

main    nop
        jsr home
        jsr init
*
* ligne haute
*
aller  nop
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
        jsr mywait
        iny         ; car. suivant dans la ligne
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
        beq suite
        clc
        adc #$01        ; la ligne verticale 
        sta top         ; top
        lda #$17
        sec
        sbc curline
        sec
        sbc #$01
        sta bottom      ; bottom
        
        sec
        sbc top
        clc
        adc #$01
        sta cpt         ; compteur = bottom - top + 1
        lda top
        sta lig
loopbd  jsr bascalc
        lda lettre2
        ldy col
        sta (basl),y
        jsr mywait
        inc lig
        lda lig
        dec cpt
        bne loopbd

suite   nop
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
        dey         ; position dans la ligne
        sec
        sbc left
        tax         ; nombre caracteres de la ligne

        lda lettre
loopb   sta (basl),y
        jsr mywait
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
        beq suite2
        clc
        adc #$01
        sta top         ; top
        lda #$17
        sec
        sbc curline
        cmp #$0B
        sec
        sbc #$01
        sta bottom      ; bottom
        
        sec
        sbc top
        clc
        adc #$01
        sta cpt         ; compteur = bottom - top + 1
        lda bottom
        sta lig
loopbg  jsr bascalc
        lda lettre2
        ldy col
        sta (basl),y
        jsr mywait        
        dec lig
        lda lig
        dec cpt
        bne loopbg

suite2  nop
*
* looper
* 
        inc curline
        inc left
        inc right
        lda left
        cmp #$0C
        beq fin
        jmp aller




fin     jsr readkey



* * * * * * * * * * * *  
*       RETOUR        * 
* * * * * * * * * * * * 

retour  nop
        jsr init2
        lda lettre3
        sta lettre
        sta lettre2
*
* bord gauche RETOUR
*
bgr     nop
        lda left
        sta col         ;  position de la colonne
        
        lda curline     ; calcul top et bottom
        cmp #$0B
        beq suite3      ; 12 lignes ==> pas de bord vertical ==> sortie
        clc
        adc #$01        ; la ligne verticale démarre une ligne sous curline...  
        sta top         ; top
        lda #$17
        sec
        sbc curline     ; bas de ligne = hauteur écran - curline - 1
        sec
        sbc #$01        ; ... et finit au dessus de la ligne horizontale basse
        sta bottom      ; bottom
        sec
        sbc top
        clc
        adc #$01
        sta cpt         ; compteur = bottom - top + 1
        lda top         ; on part du haut
        sta lig         ; ligne courante
loopbgr jsr bascalc     ; adresse debut ligne
        lda lettre3     ; charge lettre
        ldy col         ; offset horizontal dans la ligne courante
        sta (basl),y    ; poke caractere
        jsr mywait        
        inc lig         ; ligne suivante
        lda lig         ; pour préparer la boucle suivante
        dec cpt         ; compteur de loop
        bne loopbgr     ; fini ?

suite3  nop

*
* ligne basse RETOUR
*
        nop
        lda #$17
        sec
        sbc curline     ; curline basse = 23 - curline
        jsr bascalc     ; adresse libre 
        ldy left        ; offset marge gauche
        lda #$28    ; 40 col.
        sec          
        sbc right   ; on soustrait la mage droite

        sec
        sbc left    ; on soustrait la mage gauche
        tax         ; ==> nombre caracteres de la ligne

        lda lettre3
looplbr sta (basl),y
        jsr mywait
        iny         ; car. suivant dans la ligne
        dex         ; compteur de caractères
        bne looplbr

*
* bord droit RETOUR
*
bdr     nop
        lda #$27
        sec
        sbc right 
        sta col         ; position de la colonne
        
        lda curline     ; calcul top et bottom
        cmp #$0B
        beq suite4
        clc
        adc #$01        ; la ligne verticale 
        sta top         ; top (sous la ligne horizontale)
        lda #$17
        sec
        sbc curline
        sec
        sbc #$01
        sta bottom      ; bottom
        
        sec
        sbc top
        clc
        adc #$01
        sta cpt         ; compteur = bottom - top + 1
        lda bottom
        sta lig
loopbdr jsr bascalc
        lda lettre3
        ldy col
        sta (basl),y
        jsr mywait
        dec lig
        lda lig
        dec cpt
        bne loopbdr

suite4  nop


*
* ligne haute RETOUR
*
        nop
        lda curline     ;
        jsr bascalc     ; adresse ligne
        lda #$28    ; 40 col.
        sec
        sbc right
        tay         ; bord droit
        dey         ; position dans la ligne
        sec
        sbc left
        tax         ; nombre caracteres de la ligne
        lda lettre3
looplhr sta (basl),y
        jsr mywait
        dey         ; car. suivant dans la ligne
        dex         ; compteur de caractères
        bne looplhr
*
* looper RETOUR
* 
        dec left
        dec right
        dec curline
        bmi finr
        jmp bgr

finr    jsr readkey
*
* * * * * * * FIN * * * * * * * 
*
        lda savl        ; restaure lettres
        sta lettre
        lda savl+1
        sta lettre2
        lda savl+2
        sta lettre3
        lda savl+3
        sta lettre4
*
        jsr home
        lda kbd
        bit kbdstrb
        rts
*
*
*  routines init.  
*
init    nop
        lda #delay
        sta timer
        lda #delay2
        sta timer2
        lda #$00
        sta curline
        sta left
        sta right
        lda lettre      ; sauve les lettres
        sta savl
        lda lettre2
        sta savl+1
        lda lettre3
        sta savl+2
        lda lettre4
        sta savl+3
        rts
*
init2   nop
        lda #$0B        ; 12 lignes (0-->11 = $0-->$B)
        sta curline
        sta right
        sta left
        rts
*
mywait  nop 
        pha
        txa
        pha
        tya
        pha
        lda timer2
wbig    ldx timer
waitl   nop
        dex
        bne waitl
        sec
        sbc #$01
        bne wbig
        pla 
        tay
        pla
        tax
        pla
        rts
* * * 
readkey nop
        bit kbdstrb             ; Clear out any data that is already at KBD
keyloop bit kbd
        bpl keyloop
        lda kbd         ; get data (in case)
        bit kbdstrb
        rts


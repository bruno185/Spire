*
* SPIRE aller - retour
*
basl equ $28
kbd equ $C000
kbdstrb equ $C010
cout equ $FDED
home equ $FC58
bascalc equ $FBC1
wait equ $FCA8
timer equ $01

*
 org $4000
debut jmp main
curline hex 00
left hex 00 ; marge gauche
right hex 00 ; marge droite
top hex 00 ; marge haute
bottom hex 00 ; marge basse
;tempo hex 00
col hex 00
lig hex 00
cpt hex 00
lettre asc "-" 
lettre2 asc "!;"

lettre3 asc " "
;lettre2 asc "C"

main nop
 jsr home
 jsr init
*
* ligne haute
*
vlineh nop
 lda curline
 jsr bascalc
 ldy left
 lda #$28 ; 40 col.
 sec 
 sbc right ; on soustrait la mage droite

 sec
 sbc left ; on soustrait la mage gauche
 tax ; ==> nombre caracteres de la ligne

 lda lettre
loop sta (basl),y
 pha 
 lda timer
 jsr wait
 pla
 iny ; car. suivant dans la ligne
 dex ; compteur de caractères
 bne loop
*
* bord droit
*
bd nop
 lda #$27
 sec
 sbc right 
 sta col ; position de la colonne
 lda curline ; calcul top et bottom
 cmp #$0B
 beq suite
 clc
 adc #$01 ; la ligne verticale 
 sta top ; top
 lda #$17
 sec
 sbc curline
 sec
 sbc #$01
 sta bottom ; bottom
 sec
 sbc top
 clc
 adc #$01
 sta cpt ; compteur = bottom - top + 1
 lda top
 sta lig
loopbd jsr bascalc
 lda lettre2
 ldy col
 sta (basl),y
 lda timer
 jsr wait
 inc lig
 lda lig
 dec cpt
 bne loopbd

suite nop
*
* ligne basse
*
vlineb nop
 lda #$17
 sec
 sbc curline ; curline basse = 23 - curline
 jsr bascalc
 lda #$28 ; 40 col.
 sec
 sbc right
 tay ; bord droit
 dey ; position dans la ligne
 sec
 sbc left
 tax ; nombre caracteres de la ligne

 lda lettre
loopb sta (basl),y
 pha 
 lda timer
 jsr wait
 pla
 dey
 dex ; compteur de caractères
 bne loopb
*
* bord gauche
*
bg nop
 lda left
 sta col ; position de la colonne
 lda curline ; calcul top et bottom
 cmp #$0B
 beq suite2
 clc
 adc #$01
 sta top ; top
 lda #$17
 sec
 sbc curline
 cmp #$0B
 sec
 sbc #$01
 sta bottom ; bottom
 sec
 sbc top
 clc
 adc #$01
 sta cpt ; compteur = bottom - top + 1
 lda bottom
 sta lig
loopbg jsr bascalc
 lda lettre2
 ldy col
 sta (basl),y
 lda timer
 jsr wait 
 dec lig
 lda lig
 dec cpt
 bne loopbg

suite2 nop
*
* looper
* 
 inc curline
 inc left
 inc right
 lda left
 cmp #$0C
 beq fin
 jmp vlineh




fin lda kbd
 bpl fin
 sta kbdstrb


* * * * * * * * * * * * 
* RETOUR * 
* * * * * * * * * * * * 

retour nop
 jsr init2
 lda lettre3
 sta lettre
 sta lettre2
*
* bord gauche RETOUR
*
bgr nop
 lda left
 sta col ; position de la colonne
 lda curline ; calcul top et bottom
 cmp #$0B
 beq suite3 ; 12 lignes ==> pas de bord vertical ==> sortie
 clc
 adc #$01 ; la ligne verticale démarre une ligne sous curline... 
 sta top ; top
 lda #$17
 sec
 sbc curline ; bas de ligne = hauteur écran - curline - 1
 sec
 sbc #$01 ; ... et finit au dessus de la ligne horizontale basse
 sta bottom ; bottom
 sec
 sbc top
 clc
 adc #$01
 sta cpt ; compteur = bottom - top + 1
 lda top ; on part du haut
 sta lig ; ligne courante
loopbgr jsr bascalc ; adresse debut ligne
 lda lettre3 ; charge lettre
 ldy col ; offset horizontal dans la ligne courante
 sta (basl),y ; poke caractere
 lda timer ; wait
 jsr wait 
 inc lig ; ligne suivante
 lda lig ; pour préparer la boucle suivante
 dec cpt ; compteur de loop
 bne loopbgr ; fini ?

suite3 nop

*
* ligne basse RETOUR
*
 nop
 lda #$17
 sec
 sbc curline ; curline basse = 23 - curline
 jsr bascalc ; adresse libre 
 ldy left ; offset marge gauche
 lda #$28 ; 40 col.
 sec 
 sbc right ; on soustrait la mage droite

 sec
 sbc left ; on soustrait la mage gauche
 tax ; ==> nombre caracteres de la ligne

 lda lettre3
looplbr sta (basl),y
 pha 
 lda timer
 jsr wait
 pla
 iny ; car. suivant dans la ligne
 dex ; compteur de caractères
 bne looplbr

*
* bord droit RETOUR
*
bdr nop
 lda #$27
 sec
 sbc right 
 sta col ; position de la colonne
 lda curline ; calcul top et bottom
 cmp #$0B
 beq suite4
 clc
 adc #$01 ; la ligne verticale 
 sta top ; top (sous la ligne horizontale)
 lda #$17
 sec
 sbc curline
 sec
 sbc #$01
 sta bottom ; bottom
 sec
 sbc top
 clc
 adc #$01
 sta cpt ; compteur = bottom - top + 1
 lda bottom
 sta lig
loopbdr jsr bascalc
 lda lettre3
 ldy col
 sta (basl),y
 lda timer
 jsr wait
 dec lig
 lda lig
 dec cpt
 bne loopbdr

suite4 nop


*
* ligne haute RETOUR
*
 nop
 lda curline ;
 jsr bascalc ; adresse ligne
 lda #$28 ; 40 col.
 sec
 sbc right
 tay ; bord droit
 dey ; position dans la ligne
 sec
 sbc left
 tax ; nombre caracteres de la ligne
 lda lettre3
looplhr sta (basl),y
 pha 
 lda timer
 jsr wait
 pla
 dey ; car. suivant dans la ligne
 dex ; compteur de caractères
 bne looplhr


*
* looper RETOUR
* 
 dec left
 dec right
 dec curline
 bmi finr
 jmp bgr

 sta kbdstrb
finr lda kbd
 bpl finr
*
* * * * * * * FIN * * * * * * * 
*
 rts
*
* routines init. 
*
*
init nop
 lda #$00
 sta curline
 sta left
 sta right
 sta top
 sta bottom
 sta col
 sta lig
 sta cpt
 rts
*
init2 nop
 lda #$0B ; 12 lignes (0-->11 = $0-->$B)
 sta curline
 sta right
 sta left
 lda #$00
 sta top
 sta bottom
 sta col
 sta lig
 sta cpt
 rts
*
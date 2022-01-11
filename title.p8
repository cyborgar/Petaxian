; Title
;  - Have to split in two since ubyte array max at 256 chars
;  27 x 5 in each half 
;

title {

  ; Title top
  ubyte[] title_p1 = [
    $20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$7B,$6C,$20,$7B,$6C,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,$20,
    $20,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$5F,$F7,$F7,$F7,$69,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$46,$20,
    $20,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$5F,$A0,$DF,$D7,$D7,$D7,$E9,$A0,$69,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$63,$20,
    $20,$A0,$A0,$A0,$DF,$20,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$20,$E9,$A0,$A0,$DF,$5F,$A0,$E3,$E3,$E3,$A0,$69,$E9,$A0,$20,$E9,$A0,$A0,$DF,$20,$A0,$DF,$20,$A0,$20,
    $20,$A0,$A0,$20,$A0,$20,$A0,$A0,$20,$20,$20,$20,$A0,$A0,$20,$20,$A0,$A0,$E1,$A0,$20,$5F,$A0,$A0,$A0,$69,$20,$A0,$A0,$20,$A0,$A0,$E1,$A0,$20,$A0,$A0,$DF,$A0,$20
  ]

  ; Title bottom
  ubyte[] title_p2 = [
    $20,$A0,$A0,$A0,$69,$20,$A0,$A0,$A0,$20,$20,$20,$A0,$A0,$20,$20,$A0,$A0,$A0,$A0,$20,$E9,$A0,$A0,$A0,$DF,$20,$A0,$A0,$20,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$20,
    $20,$A0,$A0,$20,$20,$20,$A0,$A0,$20,$20,$20,$20,$A0,$A0,$20,$20,$A0,$A0,$E1,$A0,$20,$A0,$A0,$20,$A0,$A0,$20,$A0,$A0,$20,$A0,$A0,$E1,$A0,$20,$A0,$A0,$5F,$A0,$20,
    $20,$62,$62,$20,$20,$20,$62,$62,$62,$62,$20,$20,$62,$62,$20,$20,$62,$62,$6C,$62,$20,$62,$62,$20,$62,$62,$20,$62,$62,$20,$62,$62,$6C,$62,$20,$62,$62,$20,$62,$20,
    $20,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$64,$20,
    $20,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$44,$20
  ]

  ; screen color data
  ubyte[] colors_p1 = [
    $0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0D,$0D,$0D,$0D,$0D,$0E,$0E,$0E,$00,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,
    $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$0D,$0D,$0D,$0D,$0D,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
    $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
    $03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,$03,
    $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D
  ]

  ubyte[] colors_p2 = [
    $0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,$0D,
    $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,
    $05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,$05,
    $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,
    $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  ]

  const ubyte TITLE_WDT = 40
  const ubyte TITLE_HGT = 5

  ubyte[] credits = [
    $6F, $6F, $61, $E1, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $6F, $61, $E1, $6F, $6F,
    $70, $43, $6E, $70, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $6E, $70, $43, $6E,
    $5D, $20, $3A, $3A, $20, $20, $02, $0F, $12, $07, $01, $12, $20, $0F, $0C, $13, $05, $0E, $20, $32, $30, $32, $31, $20, $20, $3A, $3A, $20, $5D,
    $6B, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $73,
    $5D, $03, $0F, $04, $05, $04, $20, $09, $0E, $20, $10, $12, $0F, $07, $38, $20, $03, $12, $05, $01, $14, $05, $04, $20, $02, $19, $20, $20, $5D,
    $5D, $20, $09, $12, $0D, $05, $0E, $20, $04, $05, $20, $0A, $0F, $0E, $07, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $5D
  ]
  
  ubyte[] credits_p2 = [
    $6B, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $73,
    $5D, $07, $06, $18, $20, $17, $0F, $12, $0B, $20, $09, $0E, $20, $10, $05, $14, $13, $03, $09, $09, $20, $05, $04, $09, $14, $0F, $12, $20, $5D,
    $5D, $20, $28, $08, $14, $14, $10, $3A, $2F, $2F, $10, $05, $14, $13, $03, $09, $09, $2E, $0B, $12, $09, $13, $13, $1A, $2E, $08, $15, $29, $5D,
    $6D, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $43, $7D,
    $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77, $77,
    $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
  ]

  ubyte[] credits_col = [
    $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03, $03,
    $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D,
    $0D, $01, $0D, $0D, $01, $06, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $0D, $0D, $0D, $0D,
    $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D,
    $0D, $0A, $0A, $0A, $0A, $0A, $01, $0A, $0A, $01, $01, $01, $01, $01, $01, $01, $0A, $0A, $0A, $0A, $0A, $0A, $0A, $03, $0A, $0A, $0E, $0E, $0D,
    $0D, $01, $0E, $0E, $0E, $0E, $0E, $01, $0E, $0E, $01, $0E, $0E, $0E, $0E, $03, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0D
  ]

  ubyte[] credits_p2_col = [
    $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D,
    $0D, $0A, $0A, $0A, $03, $0A, $0A, $0A, $0A, $03, $0A, $0A, $03, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $01, $0D,
    $0D, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0E, $0D,
    $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D, $0D,
    $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05, $05,
    $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $99
  ]

  const ubyte CREDITS_WDT = 29
  const ubyte CREDITS_HGT = 6

  sub draw() {
    ubyte i
    for i in 0 to (TITLE_WDT * TITLE_HGT - 1) {
      txt.setcc( (i % TITLE_WDT), base.UBORDER + (i/TITLE_WDT), title_p1[i], colors_p1[i] )
      txt.setcc( (i % TITLE_WDT), base.UBORDER + 5 + (i/TITLE_WDT), title_p2[i], colors_p2[i] )
    }

    for i in 0 to (CREDITS_WDT * CREDITS_HGT - 1) {
      txt.setcc( (i % CREDITS_WDT) + 5 , base.UBORDER + 11 + (i/CREDITS_WDT), credits[i], credits_col[i] )
      txt.setcc( (i % CREDITS_WDT) + 5 , base.UBORDER + 17 + (i/CREDITS_WDT), credits_p2[i], credits_p2_col[i] )
    }

  }

  sub write(ubyte col, ubyte x, ubyte y, uword messageptr) {
    txt.color(col)
    txt.plot( x, y )
    txt.print( messageptr )
  }

}

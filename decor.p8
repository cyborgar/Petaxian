; Decor on title screen
decor {
  ; char data
  ubyte[] sidebar = [
    $61, $20, $20, $20, $20, $20, $20, $20, $20,
    $61, $13, $03, $0F, $12, $05, $40, $43, $6E,
    $61, $4A, $43, $B0, $B0, $B0, $B0, $B0, $4B,
    $61, $0C, $09, $16, $05, $13, $40, $43, $6E,
    $61, $4A, $43, $43, $43, $43, $40, $B3, $4B,
    $61, $17, $01, $16, $05, $40, $40, $43, $6E,
    $61, $4A, $43, $43, $43, $40, $B0, $B1, $4B,
    $61, $20, $20, $20, $20, $20, $20, $20, $20,
    $61, $20, $20, $20, $20, $20, $20, $20, $20,
    $61, $20, $20, $20, $20, $20, $20, $20, $20,
    $61, $20, $20, $20, $20, $20, $20, $20, $20,
    $61, $20, $20, $20, $20, $2E, $20, $20, $20,
    $61, $20, $20, $20, $7B, $6C, $20, $20, $20,
    $61, $20, $20, $6A, $75, $76, $74, $20, $2E,
    $61, $2E, $20, $76, $74, $6A, $75, $20, $20,
    $61, $20, $20, $E1, $E9, $DF, $61, $20, $20,
    $61, $6A, $20, $F5, $A0, $A0, $F6, $2E, $74,
    $61, $6A, $E9, $C7, $FC, $FE, $C8, $DF, $74,
    $61, $6A, $D4, $C7, $CC, $FA, $C8, $D9, $74,
    $61, $6A, $D4, $C7, $C0, $C0, $C8, $D9, $74,
    $61, $6A, $69, $7C, $7E, $7C, $7E, $5F, $74,
    $61, $20, $20, $67, $20, $20, $65, $20, $2E,
    $61, $20, $2E, $76, $74, $6A, $75, $20, $20,
    $61, $20, $20, $E1, $61, $76, $61, $20, $20,
    $61, $20, $20, $20, $20, $2E, $20, $20, $20 ]

; color data
  ubyte[] sidebar_col = [
    $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,
    $0F, $07, $07, $07, $07, $07, $0F, $0F, $0F,
    $0F, $0F, $0F, $01, $01, $01, $01, $01, $0F,
    $0F, $0E, $0E, $0E, $0E, $0E, $0F, $0F, $0F,
    $0F, $0F, $0F, $0F, $0F, $0F, $0F, $01, $0F,
    $0F, $0D, $0D, $0D, $0D, $0F, $0F, $0F, $0F,
    $0F, $0F, $0F, $0F, $0F, $0F, $01, $01, $0F,
    $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,
    $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,
    $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,
    $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F, $0F,
    $0F, $00, $00, $00, $00, $0D, $00, $00, $00,
    $0F, $00, $00, $00, $0A, $02, $00, $00, $00,
    $0F, $00, $00, $0C, $0A, $02, $0B, $00, $08,
    $0F, $03, $00, $0C, $0A, $02, $0B, $00, $00,
    $0F, $00, $00, $0C, $01, $0C, $0B, $00, $00,
    $0F, $01, $00, $0C, $01, $0C, $0B, $09, $0F,
    $0F, $0F, $0A, $0C, $0A, $02, $0B, $02, $0C,
    $0F, $0F, $0A, $0C, $0A, $02, $0B, $02, $0C,
    $0F, $0F, $0A, $0C, $0F, $0C, $0B, $02, $0C,
    $0F, $0F, $0A, $0C, $0A, $02, $0B, $02, $0C,
    $0F, $00, $00, $0D, $0E, $0E, $03, $00, $08,
    $0F, $00, $0C, $0D, $03, $0D, $03, $00, $00,
    $0F, $00, $00, $0D, $03, $0D, $03, $00, $00,
    $0F, $00, $00, $00, $00, $02, $00, $00, $00 ]

  const ubyte WDT = 9
  const ubyte HGT = 25

  sub draw() {
    ubyte i
    for i in 0 to (WDT*HGT - 1) {
      txt.setcc( 31 + (i % WDT), (i/WDT), sidebar[i], sidebar_col[i] )
    }
  }

}

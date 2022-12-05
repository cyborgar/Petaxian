;
; Code to extract upper and lower 4 bit nibbles from ubyte and convert
; to correct PETSCII character based on nibble.
; 
convert {
  %option force_output

  ubyte[] table = [  $20, $7E, $7C, $E2, $7B, $61, $FF, $EC,
                   $6C, $7F, $E1, $FB, $62, $FC, $FE, $A0 ]

  ;    sub get_high_old(ubyte data) -> ubyte {
  ;      return table[ (data & 240) >> 4 ]
  ;    }
  inline asmsub get_high(ubyte value @A) clobbers(Y) -> ubyte @A {
    %asm {{
      and #$F0
      lsr a
      lsr a
      lsr a
      lsr a
      tay
      lda convert.table,y
    }}
  }

  ;    sub get_low_old(ubyte data) -> ubyte {
  ;      return table[ data & 15 ]
  ;    }
  inline asmsub get_low(ubyte value @A) clobbers(Y) -> ubyte @A {
    %asm {{
      and #$0F
      tay
      lda convert.table,y
    }}
  }

;  sub to_nibble_old(ubyte cnv) -> ubyte {
;    ubyte i = 0
;    while i < 7 {
;      if table[i] == cnv
;        return i
;      i++
;    }
;    return 7
;  }
  asmsub to_nibble(ubyte cnv @A) -> ubyte @A {
    %asm {{
        ldy  #6
-       cmp  table,y
        beq  +
        dey
        bpl  -
        lda  #7
        rts
+       tya
        rts
    }}
  }
}

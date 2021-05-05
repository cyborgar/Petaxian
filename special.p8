;
; Code to extract upper and lower 4 bit nibbles from ubyte and convert
; to correct PETSCII character based on nibble.
; 
convert {

  ubyte[] tbl = [  $20, $7E, $7C, $E2, $7B, $61, $FF, $EC,
                   $6C, $7F, $E1, $FB, $62, $FC, $FE, $A0 ]

  ;    sub get_high_old(ubyte data) -> ubyte {
  ;      return tbl[ (data & 240) >> 4 ]
  ;    }
  asmsub get_high(ubyte value @A) clobbers(Y) -> ubyte @A {
    %asm {{
      sta P8ZP_SCRATCH_REG
      lda #$F0
      and P8ZP_SCRATCH_REG
      lsr a
      lsr a
      lsr a
      lsr a
      tay
      lda tbl,y
      rts
    }}
  }

  ;    sub get_low_old(ubyte data) -> ubyte {
  ;      return tbl[ data & 15 ]
  ;    }
  asmsub get_low(ubyte value @A) clobbers(Y) -> ubyte @A {
    %asm {{
      sta P8ZP_SCRATCH_REG
      lda #$0F
      and P8ZP_SCRATCH_REG
      tay
      lda tbl,y
      rts
    }}
  }

  sub to_nibble(ubyte cnv) -> ubyte {
    ubyte i = 0
    while i < 7 {
      if tbl[i] == cnv
        return i
      i++
    }
    return 7
  }
}

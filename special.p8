;
; Code to extract upper and lower 4 bit nibbles from ubyte and convert
; to correct PETSCII character based on nibble.
; 
convert {

  ubyte[] tbl = [  $20, $7E, $7C, $E2, $7B, $61, $FF, $EC,
                   $6C, $7F, $E1, $FB, $62, $FC, $FE, $A0 ]

  sub get_high(ubyte data) -> ubyte {
      return tbl[ (data & 240) >> 4 ]
  }

  sub get_low(ubyte data) -> ubyte {
      return tbl[ data & 15 ]
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

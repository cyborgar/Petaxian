;
; Code to extract upper and lower 4 bit nibbles from ubyte and convert
; to correct PETSCII character based on nibble.
; 
convert {

  ubyte[] tbl = [   32, 126, 124, 226, 123,  97, 255, 236,
                   108, 127, 225, 251,  98, 252, 252, 160 ]

  sub get_high(ubyte data) -> ubyte {
      return tbl[ (data & 240) >> 4 ]
  }

  sub get_low(ubyte data) -> ubyte {
      return tbl[ data & 15 ]
  }
}

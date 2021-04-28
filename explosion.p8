%import special

explosion {
  const ubyte ANIM_LENGHT = 5
  ubyte[] gfx = [
    $80, $00, $04, $00, $00, $20, $00, $01,
    $E4, $20, $8D, $01, $80, $B1, $04, $27,
    $91, $11, $26, $22, $44, $64, $88, $89,
    $64, $20, $89, $01, $80, $91, $04, $26,
    $11, $11, $22, $22, $44, $44, $88, $88
  ]

  ; Cycle colers (white, yellow, yellow, orange, red
  ubyte[] color = [ 0, 1, 7, 8, 8, 2 ]

  const ubyte FIELD_COUNT = 4
  const ubyte MAX_EXPL = 5 ;
  ubyte active = 0

  ubyte[FIELD_COUNT * MAX_EXPL] explosionData
  const ubyte EX_STAGE = 0   ; Works as both "on" and progres in animation
  const ubyte EX_SUBPOS = 1
  const ubyte EX_X = 2
  const ubyte EX_Y = 3

  sub trigger(ubyte x, ubyte y, ubyte subpos) {
    txt.setcc(x, y, 100, 1)

    if active == MAX_EXPL  ; May not be required.
      return

    ubyte i = 0
    while ( i < MAX_EXPL ) {
      uword explosionRef = &explosionData + i * FIELD_COUNT

      if explosionRef[EX_STAGE] == 0 { ; First free data slot
        explosionRef[EX_STAGE] = 1
        explosionRef[EX_SUBPOS] = subpos
        explosionRef[EX_X] = x
        explosionRef[EX_Y] = y
        draw(i)
        active++
        return 
      }
      i++
    }
  }

  sub clear(ubyte explosion_num) {
    uword explosionRef = &explosionData + explosion_num * FIELD_COUNT

    ubyte tmp_x
    ubyte tmp_y
    tmp_x = explosionRef[EX_X]
    tmp_y = explosionRef[EX_Y]

    txt.setcc(tmp_x,   tmp_y,   main.CLR, 1)
    txt.setcc(tmp_x+1, tmp_y,   main.CLR, 1)
    txt.setcc(tmp_x,   tmp_y+1, main.CLR, 1)
    txt.setcc(tmp_x+1, tmp_y+1, main.CLR, 1)
  }

  sub draw(ubyte explosion_num) {
    uword explosionRef = &explosionData + explosion_num * FIELD_COUNT

    ubyte tmp_x
    ubyte tmp_y
    tmp_x = explosionRef[EX_X]
    tmp_y = explosionRef[EX_Y]
    ubyte col =  color[explosionRef[EX_STAGE]]
 
    ; Find korrekt animation, first correct "step"
    ubyte gfx_ind = (explosionRef[EX_STAGE] - 1 ) * 8
    ; Correct for nibble shift
    gfx_ind += (not explosionRef[EX_SUBPOS] & main.TOPMOST) * 4
    gfx_ind += (not explosionRef[EX_SUBPOS] & main.LEFTMOST) * 2

    ; Convert first byte to two PETSCII chars and draw
    ubyte gfx_byte = gfx[gfx_ind]
    txt.setcc(tmp_x,   tmp_y, convert.get_high(gfx_byte), col)
    txt.setcc(tmp_x+1, tmp_y, convert.get_low(gfx_byte), col)

    ; Convert second byte and draw
    gfx_ind++
    gfx_byte = gfx[gfx_ind]
    txt.setcc(tmp_x,   tmp_y+1, convert.get_high(gfx_byte), col)
    txt.setcc(tmp_x+1, tmp_y+1, convert.get_low(gfx_byte), col)
  }

  sub animate() {
    if active == 0 ; any animation at all
      return

    ubyte i = 0
    while ( i < MAX_EXPL ) {
      uword explosionRef = &explosionData + i * FIELD_COUNT

      if explosionRef[EX_STAGE] > 0 {
        explosionRef[EX_STAGE]++

        if explosionRef[EX_STAGE] > 5 { ; Done with animation ?
          explosionRef[EX_STAGE] = 0
          clear(i)
          active--
        } else {
          draw(i)
        }
      }
      i++
    }
  }
}

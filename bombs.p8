; Simple bombs dropped by enemy
;
; Bombs can be on either "half" of a character. Use single "bit"
; figure
;
bombs {
  const ubyte COL = 7

  const ubyte MAX_BOMBS = 40
  const ubyte FIELD_COUNT = 4

  ubyte active_bombs = 0
  ubyte[FIELD_COUNT * MAX_BOMBS] bombData

  const ubyte BMB_ON = 0
  const ubyte BMB_LEFTMOST = 1
  const ubyte BMB_X = 2
  const ubyte BMB_Y = 3

  uword bombRef ; Global to avoid sending reference to subs

  sub set_data() {
    active_bombs = 0
    sys.memset(&bombData, FIELD_COUNT * MAX_BOMBS, 0 )
  }

  sub trigger(ubyte x, ubyte y, bool leftmost) {
    if active_bombs == MAX_BOMBS ; No more (is this required?)
      return

    bombRef = &bombData
    ubyte i = 0
    while i < MAX_BOMBS {
      if bombRef[BMB_ON] == 0 { ; Find first "free" bomb
        bombRef[BMB_ON] = 1
        if leftmost {
          bombRef[BMB_LEFTMOST] = 1
          bombRef[BMB_X] = x + 1
        } else {
          bombRef[BMB_LEFTMOST] = 0
          bombRef[BMB_X] = x
        }
        bombRef[BMB_Y] = y + 1
        draw()
        active_bombs++
        sound.bomb()
        return ; No need to check any more
      }
      bombRef += FIELD_COUNT
      i++
    }

  }

  sub clear() {
    txt.setcc(bombRef[BMB_X], bombRef[BMB_Y], main.CLR, 0)
  }

  ; Can bomb and bullet meet?
  ;
  sub draw() {
    if bombRef[BMB_LEFTMOST] == 1
      txt.setcc(bombRef[BMB_X], bombRef[BMB_Y], 123, COL)
    else
      txt.setcc(bombRef[BMB_X], bombRef[BMB_Y], 108, COL)
  }

  sub move() {
    bombRef = &bombData
    ubyte i = 0
    while i < MAX_BOMBS {
      if bombRef[BMB_ON] == 1 { 
        clear() ; Clear old position
        bombRef[BMB_Y]++;
        ubyte tmp_y = bombRef[BMB_Y]
        if tmp_y == base.DBORDER {
          bombRef[BMB_ON] = 0
          active_bombs--
        } else if tmp_y == base.DBORDER - 1 {
          if gun.check_collision( bombRef ) {
            bombRef[BMB_ON] = 0
            active_bombs--
          } else
            draw()
        } else {
          draw()
        }
      }
      bombRef += FIELD_COUNT
      i++
    }
  }  

}

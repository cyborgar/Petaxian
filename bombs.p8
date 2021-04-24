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

  sub trigger(ubyte x, ubyte y, ubyte leftmost) {
    if active_bombs == MAX_BOMBS ; No more (is this required?)
      return

    ubyte i = 0
    while ( i < MAX_BOMBS ) {
      uword bombRef = &bombData + i * FIELD_COUNT

      if bombRef[BMB_ON] == false { ; Find first "free" bomb
        bombRef[BMB_ON] = true
	if leftmost == true {
          bombRef[BMB_LEFTMOST] = true
          bombRef[BMB_X] = x + 1
        } else {
          bombRef[BMB_LEFTMOST] = false
          bombRef[BMB_X] = x
	}
        bombRef[BMB_Y] = y + 1
	draw(i)
        active_bombs++
        return ; No need to check any more
      }
      i++
    }

  }

  sub clear(ubyte bomb_num) {
    uword bombRef = &bombData + bomb_num * FIELD_COUNT
    
    txt.setcc(bombRef[BMB_X], bombRef[BMB_Y], main.CLR, 0)
  }

  ; Can bomb and bullet meet?
  ;
  sub draw(ubyte bomb_num) {
    uword bombRef = &bombData + bomb_num * FIELD_COUNT

    if bombRef[BMB_LEFTMOST]
      txt.setcc(bombRef[BMB_X], bombRef[BMB_Y], 123, COL)
    else
      txt.setcc(bombRef[BMB_X], bombRef[BMB_Y], 108, COL)
  }

  sub move() {
    ubyte i = 0
    while ( i < MAX_BOMBS ) {
      uword bombRef = &bombData + i * FIELD_COUNT

      if bombRef[BMB_ON] == true { 
        clear(i) ; Clear old position
        bombRef[BMB_Y]++;
        if bombRef[BMB_Y] == main.DBORDER {
          bombRef[BMB_ON] = false
          active_bombs--
        } else {
	  if gun.check_collision( bombRef ) {
            bombRef[BMB_ON] = false
	    active_bombs--
	  } else {
            draw(i)
	  }
        }
      }
      i++
    }
  }  

}

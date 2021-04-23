bombs {
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
      ubyte offset = i * FIELD_COUNT
      
      if bombData[offset + BMB_ON] == false { ; Find first "free" bomb
        bombData[offset + BMB_ON] = true
	if leftmost == true {
          bombData[offset + BMB_LEFTMOST] = true
          bombData[offset + BMB_X] = x + 1
	} else {
          bombData[offset + BMB_LEFTMOST] = false
          bombData[offset + BMB_X] = x
	}
        bombData[offset + BMB_Y] = y + 1
	draw(i)
        active_bombs++
        return ; No need to check any more
      }
      i++
    }

  }

  sub clear(ubyte bomb_num) {
    ubyte offset = bomb_num * FIELD_COUNT
    
    ubyte indx = offset + BMB_X
    ubyte indy = offset + BMB_Y
    txt.setcc(bombData[indx], bombData[indy], main.CLR, 2)
  }

  ; Can bomb and bullet meet?
  ;
  sub draw(ubyte bomb_num) {
    ubyte offset = bomb_num * FIELD_COUNT

    ubyte indx = offset + BMB_X
    ubyte indy = offset + BMB_Y
    if bombData[offset + BMB_LEFTMOST]
      txt.setcc(bombData[indx], bombData[indy], 123, 1)
    else
      txt.setcc(bombData[indx], bombData[indy], 108, 1)
  }

  sub move() {
    ubyte i = 0
    while ( i < MAX_BOMBS ) {
      uword BombRef = &bombData + i * FIELD_COUNT

      if BombRef[BMB_ON] == true { 
        clear(i) ; Clear old position
        BombRef[BMB_Y]++;
        if BombRef[BMB_Y] == main.DBORDER {
          BombRef[BMB_ON] = false
          active_bombs--
        } else {
;	  if enemy.check_collision( BombRef ) {
;            BombRef[BMB_ON] = false
;	    active_bombs--
;	  } else {
            draw(i)
;	  }
        }
      }
      i++
    }
  }  

}

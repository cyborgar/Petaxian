; Seeker bombs dropped by enemy
;
; Seekers can be on either "half" of a character. Use left/right half chars.
; Bombs move left/right towards player at every other move downwards
;
seeker_bombs {
  const ubyte COL = 1

  const ubyte MAX_SEEKERS = 5
  const ubyte FIELD_COUNT = 4

  ubyte active_bombs = 0
  ubyte[FIELD_COUNT * MAX_SEEKERS] seekerData

  const ubyte SKR_ON = 0
  const ubyte SKR_LEFTMOST = 1
  const ubyte SKR_X = 2
  const ubyte SKR_Y = 3

  uword seekerRef ; Global to avoid sending reference to subs

  sub set_data() {
    active_bombs = 0
    sys.memset(&seekerData, FIELD_COUNT * MAX_SEEKERS, 0 )
  }

  sub trigger(ubyte x, ubyte y, ubyte leftmost) {
    if active_bombs == MAX_SEEKERS ; No more (is this required?)
      return

    seekerRef = &seekerData
    ubyte i = 0
    while i < MAX_SEEKERS {
      if seekerRef[SKR_ON] == false { ; Find first "free" bomb
        seekerRef[SKR_ON] = true
        if leftmost == true {
          seekerRef[SKR_LEFTMOST] = true
          seekerRef[SKR_X] = x + 1
        } else {
          seekerRef[SKR_LEFTMOST] = false
          seekerRef[SKR_X] = x
        }
        seekerRef[SKR_Y] = y + 1
        draw()
        active_bombs++
        sound.bomb()
        return ; No need to check any more
      }
      seekerRef += FIELD_COUNT
      i++
    }

  }

  sub clear() {
    txt.setcc(seekerRef[SKR_X], seekerRef[SKR_Y], main.CLR, 0)
  }

  ; Can bomb and bullet meet?
  ;
  sub draw() {
    if seekerRef[SKR_LEFTMOST]
      txt.setcc(seekerRef[SKR_X], seekerRef[SKR_Y], 123, COL)
    else
      txt.setcc(seekerRef[SKR_X], seekerRef[SKR_Y], 108, COL)
  }

  sub move() {
    seekerRef = &seekerData
    ubyte i = 0
    while i < MAX_SEEKERS {
      if seekerRef[SKR_ON] == true { 
        clear() ; Clear old position
        seekerRef[SKR_Y]++;
	ubyte tmp_y = seekerRef[SKR_Y]
        ; Seek gun every other drop
        if tmp_y % 2 == 0 {
          if seekerRef[SKR_X] <= gun.x {
             seekerRef[SKR_X]++
           } else {
             seekerRef[SKR_X]--
          }
        }
        if tmp_y == base.DBORDER {
          seekerRef[SKR_ON] = false
          active_bombs--
        } else if tmp_y == base.DBORDER - 1 {
          if gun.check_collision( seekerRef ) {
            seekerRef[SKR_ON] = false
            active_bombs--
          } else 
	    draw()
        } else {
          draw()
        }
      }
      seekerRef += FIELD_COUNT
      i++
    }
  }  

}

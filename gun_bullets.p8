;
; Draw and move gun_bullets
;
; Unlike the gun and the enemies the bullets are moved a full char per step
; since they need to be fast. This is still tied to the gun movement speed
; but is for practical purposes twice as fast.
;
; Collision detection (in ememy.p8) still need to use nibble checking to
; verify hit since it is possible to past on left or right side of enemy
; without hitting
;
gun_bullets {
  const ubyte COL = 15

  const ubyte MAX_BULLETS = 3
  const ubyte FIELD_COUNT = 4
  ubyte active_bullets = 0

  ubyte[FIELD_COUNT * MAX_BULLETS] bulletData
  const ubyte BD_ON = 0
  const ubyte BD_LEFTMOST = 1
  const ubyte BD_X = 2
  const ubyte BD_Y = 3

  uword bulletRef ; Global to save on parameter passing

  sub set_data() {
    active_bullets = 0
    sys.memset(&bulletData, FIELD_COUNT * MAX_BULLETS, 0)
  }

  sub trigger(ubyte x, ubyte y, ubyte lm) {
    if active_bullets == MAX_BULLETS ; All bullets in use
      return

    bulletRef = &bulletData
    ubyte i = 0
    while i < MAX_BULLETS {
      if bulletRef[BD_ON] == false { ; Find first "free" bullet
        bulletRef[BD_ON] = true
        bulletRef[BD_LEFTMOST] = lm
        bulletRef[BD_X] = x
        bulletRef[BD_Y] = y
	draw()
        active_bullets++
        return ; No need to check any more
      }
      bulletRef += FIELD_COUNT
      i++
    }
  }

  sub clear() {
    txt.setcc(bulletRef[BD_X], bulletRef[BD_Y], main.CLR, 2)
  }

  ; NB. Bullet might be drawn on top of underlying char without
  ; actually hitting enemy. Could add a merge "function" of sort
  ; to combine bullet+char. Not sure if it visually is necessary yet
  sub draw() {
    if bulletRef[BD_LEFTMOST]
      txt.setcc(bulletRef[BD_X], bulletRef[BD_Y], $61, COL)
    else
      txt.setcc(bulletRef[BD_X], bulletRef[BD_Y], $E1, COL)
  }

  sub move() {
    bulletRef = &bulletData
    ubyte i = 0
    while i < MAX_BULLETS {
      if bulletRef[BD_ON] == true { 
        clear() ; Clear old position
        if bulletRef[BD_Y] == base.UBORDER {
          bulletRef[BD_ON] = false
          active_bullets--
        } else {
          bulletRef[BD_Y]--;
	  if enemy.check_collision( bulletRef ) {
            bulletRef[BD_ON] = false
	    active_bullets--
	  } else {
            draw()
	  }
        }
      }
      bulletRef += FIELD_COUNT
      i++
    }
  }  
}

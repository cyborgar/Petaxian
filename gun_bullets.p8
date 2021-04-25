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

  sub trigger(ubyte x, ubyte y, ubyte lm) {
    if active_bullets == MAX_BULLETS ; All bullets in use
      return

    ubyte i = 0
    while ( i < MAX_BULLETS ) {
      uword bulletRef = &bulletData + i * FIELD_COUNT
      
      if bulletRef[BD_ON] == false { ; Find first "free" bullet
        bulletRef[BD_ON] = true
        bulletRef[BD_LEFTMOST] = lm
        bulletRef[BD_X] = x
        bulletRef[BD_Y] = y
	draw(i)
        active_bullets++
        return ; No need to check any more
      }
      i++
    }
  }

  sub clear(ubyte bullet_num) {
    uword bulletRef = &bulletData + bullet_num * FIELD_COUNT

    txt.setcc(bulletRef[BD_X], bulletRef[BD_Y], main.CLR, 2)
  }

  ; NB. Bullet might be drawn on top of underlying char without
  ; actually hitting enemy. Could add a merge "function" of sort
  ; to combine bullet+char. Not sure if it visually is necessary yet
  sub draw(ubyte bullet_num) {
    uword bulletRef = &bulletData + bullet_num * FIELD_COUNT

    if bulletRef[BD_LEFTMOST]
      txt.setcc(bulletRef[BD_X], bulletRef[BD_Y], $61, COL)
    else
      txt.setcc(bulletRef[BD_X], bulletRef[BD_Y], $E1, COL)
  }

  sub move() {
    ubyte i = 0
    while ( i < MAX_BULLETS ) {
      uword bulletRef = &bulletData + i * FIELD_COUNT

      if bulletRef[BD_ON] == true { 
        clear(i) ; Clear old position
        if bulletRef[BD_Y] == main.UBORDER {
          bulletRef[BD_ON] = false
          active_bullets--
        } else {
          bulletRef[BD_Y]--;
	  if enemy.check_collision( bulletRef ) {
            bulletRef[BD_ON] = false
	    active_bullets--
	  } else {
            draw(i)
	  }
        }
      }
      i++
    }
  }  
}

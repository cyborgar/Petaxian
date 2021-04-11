;
; Draw and move the gun
;
; Gun drawn using "half character" movement through PETSCII chars so
; movement is either by switching internal chars or by moving position 
; (and switching chars)
;
; This is pretty simple here, look at the "enemy" code for a more general
; sub-char movement description
;
gun {
  ubyte x
  ubyte y

  byte direction = 0
  const ubyte col = 1

  ubyte[] gun_l = [ 254, 251, 123 ]
  ubyte[] gun_r = [ 108, 236, 252 ]

  ubyte leftmost = true;

  ubyte i ; shared loop variable

  sub clear() {
    for i in 0 to 2 {
      txt.setcc( x + i, y, main.CLR, 0 )
    }
  }

  sub draw() {
    if leftmost {
      for i in 0 to 2 {
        txt.setcc( x + i, y, gun_l[i], col )
      }
    } else {
      for i in 0 to 2 {
        txt.setcc( x + i, y, gun_r[i], col )
      }    
    }
  }

  sub set_left() {
    direction = -1
  }

  sub set_right() {
    direction = 1
  }

  sub move() {
    if direction  < 0 {
      move_left()      
    } else {
      if direction > 0 {
        move_right()
      }
    }
  }

  sub move_left() {
    if ( x <= main.GUN_MAX_LEFT and leftmost )
      return
      
    if leftmost {
      clear()
      x--
      leftmost = false;
      draw()
    } else {
      leftmost=true
      draw()
    }
  }

  sub move_right() {
    if ( x >= main.GUN_MAX_RIGHT and not leftmost )
      return

    if leftmost {
      leftmost = false;
      draw()
    } else {
      clear()
      x++
      leftmost=true
      draw()
    }
  }

  sub fire() {
    bullets.trigger(x+1, y-1, leftmost)
  }

}

;
; Draw and move bullets
;
bullets {
  const ubyte MAX_BULLETS = 3
  const ubyte FIELD_COUNT = 4
  ubyte active_bullets = 0

  ubyte i      ; Loop variable for functions
  ubyte offset ; Offset holder
  ubyte indx   ; temp x pos
  ubyte indy   ; temp y pos
 
  ubyte[FIELD_COUNT * MAX_BULLETS] bulletData
  const ubyte FP_ON = 0
  const ubyte FP_LEFTMOST = 1
  const ubyte FP_X = 2
  const ubyte FP_Y = 3

  sub trigger(ubyte x, ubyte y, ubyte lm) {
    if active_bullets == MAX_BULLETS ; All bullets in use
      return

    i = 0
    while ( i < MAX_BULLETS ) {
      offset = i * 4
      if bulletData[offset + FP_ON] == false { ; Find first "free" bullet
        bulletData[offset + FP_ON] = true
        bulletData[offset + FP_LEFTMOST] = lm
        bulletData[offset + FP_X] = x
        bulletData[offset + FP_Y] = y
	draw(i)
        active_bullets++
        return ; No need to check any more
      }
      i++
    }
  }

  sub clear(ubyte bullet_num) {
    offset = bullet_num * 4

    indx = offset + FP_X
    indy = offset + FP_Y
    txt.setcc(bulletData[indx], bulletData[indy], main.CLR, 2)
  }

  ; NB. Bullet might be drawn on top of underlying char without
  ; actually hitting enemy. Could add a merge "function" of sort
  ; to combine bullet+char. Not sure if it visually is necessary yet
  sub draw(ubyte bullet_num) {
    offset = bullet_num * 4

    indx = offset + FP_X
    indy = offset + FP_Y
    if bulletData[offset + FP_LEFTMOST]
      txt.setcc(bulletData[indx], bulletData[indy], 97, 1)
    else
      txt.setcc(bulletData[indx], bulletData[indy], 225, 1)
  }

  sub move() {
    i = 0
    while ( i < MAX_BULLETS ) {
      uword BulletRef = &bulletData + i*4

      if BulletRef[FP_ON] == true { 
        clear(i) ; Clear old position
        BulletRef[FP_Y]--;
        if BulletRef[FP_Y] == main.UBORDER {
          BulletRef[FP_ON] = false
          active_bullets--
        } else {
	  if enemy.check_collision( BulletRef ) {
            BulletRef[FP_ON] = false
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

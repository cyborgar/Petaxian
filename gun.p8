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
    gun_bullets.trigger(x+1, y-1, leftmost)
  }

  sub check_collision(uword BombRef) -> ubyte {
    if BombRef[bombs.BMB_Y] != gun.y
      return 0

    if BombRef[bombs.BMB_X] < gun.x
      return 0
    if BombRef[bombs.BMB_X] > gun.x + 2
      return 0

    ; Save which X line hit (left or right)
    ; need to check
    ;ubyte dx = BombRef[bombs.BMB_] - gun.x
    main.player_lives--
    main.drawLives()
    return 1
  }

}

;
; Draw and move gun_bullets
;
gun_bullets {
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
      ubyte offset = i * FIELD_COUNT
      
      if bulletData[offset + BD_ON] == false { ; Find first "free" bullet
        bulletData[offset + BD_ON] = true
        bulletData[offset + BD_LEFTMOST] = lm
        bulletData[offset + BD_X] = x
        bulletData[offset + BD_Y] = y
	draw(i)
        active_bullets++
        return ; No need to check any more
      }
      i++
    }
  }

  sub clear(ubyte bullet_num) {
    ubyte offset = bullet_num * FIELD_COUNT

    ubyte indx = offset + BD_X
    ubyte indy = offset + BD_Y
    txt.setcc(bulletData[indx], bulletData[indy], main.CLR, 2)
  }

  ; NB. Bullet might be drawn on top of underlying char without
  ; actually hitting enemy. Could add a merge "function" of sort
  ; to combine bullet+char. Not sure if it visually is necessary yet
  sub draw(ubyte bullet_num) {
    ubyte offset = bullet_num * FIELD_COUNT

    ubyte indx = offset + BD_X
    ubyte indy = offset + BD_Y
    if bulletData[offset + BD_LEFTMOST]
      txt.setcc(bulletData[indx], bulletData[indy], 97, 1)
    else
      txt.setcc(bulletData[indx], bulletData[indy], 225, 1)
  }

  sub move() {
    ubyte i = 0
    while ( i < MAX_BULLETS ) {
      uword BulletRef = &bulletData + i * FIELD_COUNT

      if BulletRef[BD_ON] == true { 
        clear(i) ; Clear old position
        BulletRef[BD_Y]--;
        if BulletRef[BD_Y] == main.UBORDER {
          BulletRef[BD_ON] = false
          active_bullets--
        } else {
	  if enemy.check_collision( BulletRef ) {
            BulletRef[BD_ON] = false
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

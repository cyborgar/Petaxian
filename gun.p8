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
  const ubyte COL = 14
  const ubyte GUN_MAX_LEFT = main.LBORDER
  const ubyte GUN_MAX_RIGHT = main.RBORDER - 2

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
        txt.setcc( x + i, y, gun_l[i], COL )
      }
    } else {
      for i in 0 to 2 {
        txt.setcc( x + i, y, gun_r[i], COL )
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
    if ( x <= GUN_MAX_LEFT and leftmost )
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
    if ( x >= GUN_MAX_RIGHT and not leftmost )
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
    main.printLives()
    return 1
  }

}

;
; Draw and move gun_bullets
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
      txt.setcc(bulletRef[BD_X], bulletRef[BD_Y], 97, COL)
    else
      txt.setcc(bulletRef[BD_X], bulletRef[BD_Y], 225, COL)
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

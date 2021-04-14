%target cx16
%import syslib
%import textio

%import splash
%import decor
%import enemy
%import gun

main {
  const ubyte CLR = $20

  const ubyte LBORDER = 0
  const ubyte RBORDER = 28; 58
  const ubyte UBORDER = 0
  const ubyte DBORDER = 24; 58
  const ubyte FBORDER = 39; 79

  const ubyte GUN_MAX_LEFT = LBORDER + 1
  const ubyte GUN_MAX_RIGHT = RBORDER -  3

  uword score = 0

  ; Variable enemy speed
  ubyte enemy_speed = 4
  ubyte enemy_sub_counter

  ; Fixed player speed? Power ups? Split gun/bullet speed?
  ubyte player_speed = 2
  ubyte player_sub_counter

  sub start() {
  void cx16.screen_set_mode(0)

  draw_board()
  splash.draw( LBORDER + 1, UBORDER + 1 )
  splash.write( 3, LBORDER + 4, UBORDER + 15, "press space to start" )
  decor.draw ( RBORDER + 1, DBORDER - 14 )

  wait_space();

  splash.clear( LBORDER + 1, UBORDER + 1 )

  gun.x = ( RBORDER - LBORDER ) / 2
  gun.y = DBORDER - 1
  gun.draw()
    
  enemy.setup()
;  enemy.draw()

gameloop:
    ubyte time_lo = lsb(c64.RDTIM16())

    ; May needed to find a better timer
    if time_lo >= 1 {
      c64.SETTIM(0,0,0)

      ; Player movements
      player_sub_counter++
      if player_sub_counter == player_speed {
        bullets.move()
        gun.move()
	player_sub_counter = 0
      }

      enemy_sub_counter++
      if enemy_sub_counter == enemy_speed {
        ; move enemies
        enemy.move_all()
	enemy_sub_counter = 0
      }

      drawScore()
    }

    ubyte key = c64.GETIN()
    if key == 0 goto gameloop

    keypress(key)

    goto gameloop
  } 

  sub plot(ubyte x, ubyte y, ubyte ch) {
     txt.setcc(x, y, ch, 1 )
  }

  sub draw_board() {
    ubyte x
    ubyte y

    txt.setcc(LBORDER, UBORDER, 112, 1)
    txt.setcc(LBORDER, DBORDER, 109, 1)
    for x in LBORDER+1 to FBORDER {
      txt.setcc(x, UBORDER, 67, 1)
      txt.setcc(x, DBORDER, 67, 1)
    }
    txt.setcc(RBORDER, UBORDER, 114, 1)
    txt.setcc(RBORDER, DBORDER, 113, 1)
    for y in UBORDER+1 to DBORDER-1 {
      txt.setcc(LBORDER, y, 93, 1)
      txt.setcc(RBORDER, y, 93, 1)
      txt.setcc(FBORDER, y, 93, 1)
    }
    txt.setcc(FBORDER, UBORDER, 110, 1)
    txt.setcc(FBORDER, DBORDER, 125, 1)
  }

  sub drawScore() {
    txt.color(1)
    txt.plot( RBORDER + 2, UBORDER + 2 )
    txt.print_uw(score)
    uword move = enemy.move_tick as uword
    txt.plot (RBORDER + 2, UBORDER + 3 )
    txt.print_uw(move)
    txt.print("  ")
  }

  sub wait_space() {
    ubyte key = 0
    while key != 32 {
       key = c64.GETIN()
    }
    return
  }

  sub keypress(ubyte key) {
    when key {
	  157, ',' -> gun.set_left()
	   29, '/' -> gun.set_right()
	   32      -> gun.fire()
    }
  }

}

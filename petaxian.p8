%import syslib
%import textio

%import base_cx16

%import splash
%import decor
%import game_over

%import gun
%import enemy
%import bombs
%import explosion

main {
  const ubyte CLR = $20

  ; Coding two bools in one byte. 
  const ubyte LEFTMOST = 1 
  const ubyte TOPMOST =  2

  ; Game "loop" variables
  uword score = 0
  ubyte cur_stage = 0
  ubyte player_lives

  ; Variable enemy speed
  ubyte enemy_speed = 3
  ubyte enemy_sub_counter

  ; Fixed player speed? Power ups? Split gun/bullet speed?
  ubyte player_speed = 2
  ubyte player_sub_counter

  ; Delay for animation 
  const ubyte ANIMATION_SPEED = 5
  ubyte animation_sub_counter

  sub start() {
    base.platform_setup()
    
    while 1 {
      game_title()
      game_loop()
      game_end()
    }
  }

  sub game_title() {
    base.clear_screen()
    splash.draw()
    splash.write( 3, base.LBORDER + 10, base.DBORDER - 4, "press space to start" )

    wait_key(32);
  }

  sub game_loop() {
    base.clear_screen()
    decor.draw()
    base.draw_extra_border()

    player_lives = 3
    score = 0
    cur_stage = 1 

    enemy.set_data()
    gun.set_data()
    gun_bullets.set_data()
    bombs.set_data()
    enemy.setup_stage(cur_stage - 1)

    printScore()
    printLives()
    printStage()

loop:
    ubyte time_lo = lsb(c64.RDTIM16())

    ; May needed to find a better timer
    if time_lo >= 1 {
      c64.SETTIM(0,0,0)

      ; Player movements
      player_sub_counter++
      if player_sub_counter == player_speed {
        gun_bullets.move()
        gun.move()
	player_sub_counter = 0
      }

      ; Enemy movement
      enemy_sub_counter++
      if enemy_sub_counter == enemy_speed {
        ; move enemies
        enemy.move_all()
	enemy_sub_counter = 0
        bombs.move()
        enemy.spawn_bomb()
      }

      if (enemy.enemies_left == 0) {
        cur_stage++
        if cur_stage > stage.MAX_STAGE
          cur_stage = 1
        enemy.setup_stage(cur_stage - 1)
	printStage()
      }

      ; explosions etc.
      animation_sub_counter++
      if animation_sub_counter == ANIMATION_SPEED {
        animation_sub_counter = 0
        explosion.animate()
      }
    }

    if player_lives == 0
      return

    ubyte key = c64.GETIN()
    if key == 0 goto loop

    keypress(key)

    goto loop
  } 

  sub game_end() {
    ; Let explosion animation finish loop
    ubyte end_counter = 50
endloop:
    ubyte time_lo = lsb(c64.RDTIM16())

    if time_lo >= 1 {
      c64.SETTIM(0,0,0)

      ; explosions etc.
      animation_sub_counter++
      if animation_sub_counter == ANIMATION_SPEED {
        animation_sub_counter = 0
        explosion.animate()
      }
      end_counter--
    }
    
    if end_counter > 0
      goto endloop

    base.clear_screen()
    game_over.draw()

    splash.write( 3, base.LBORDER + 8, base.DBORDER - 2, "press return to continue" )
    wait_key(13);    
  }

  sub wait_key(ubyte key) {
    ubyte inp = 0
    while inp != key {
       inp = c64.GETIN()
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

  sub printScore() {
    uword tmp = main.score

    ubyte var = tmp % 10 as ubyte
    txt.setcc(base.RBORDER + 8, base.UBORDER + 2, var+176, 1)
    tmp /= 10
    var = tmp % 10 as ubyte
    txt.setcc(base.RBORDER + 7, base.UBORDER + 2, var+176, 1)
    tmp /= 10
    var = tmp % 10 as ubyte
    txt.setcc(base.RBORDER + 6, base.UBORDER + 2, var+176, 1)
    tmp /= 10
    var = tmp % 10 as ubyte
    txt.setcc(base.RBORDER + 5, base.UBORDER + 2, var+176, 1)
    var = tmp / 10 as ubyte
    txt.setcc(base.RBORDER + 4, base.UBORDER + 2, var+176, 1)
  }

  sub printLives() {
    txt.setcc(base.RBORDER + 8, base.UBORDER + 4, main.player_lives + 176, 1 )
  }

  sub printStage() {
    txt.setcc(base.RBORDER + 7, base.UBORDER + 6, main.cur_stage / 10 + 176, 1)
    txt.setcc(base.RBORDER + 8, base.UBORDER + 6, main.cur_stage % 10 + 176, 1)
  }

}

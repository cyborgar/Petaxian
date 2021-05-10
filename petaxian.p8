%import syslib
%import textio

;%import base_cx16
%import base_c64

%import splash
%import decor
%import game_over

%import stage

%import gun
%import enemy
%import bombs
%import explosion

main {
  const ubyte CLR = $20

  ubyte[] start_msg_cols = [6, 14, 14, 3, 3, 3, 1, 1, 1, 1,
  	  		    3, 3, 3, 14, 14, 6, 6, 0, 0, 0]

  ubyte[] end_msg_cols = [2, 8, 8, 7, 7, 7, 1, 1, 1, 1,
  	                  7, 7, 7, 8, 8, 2, 2, 0, 0, 0]
  

  ; Coding two bools in one byte. 
  const ubyte LEFTMOST = 1 
  const ubyte TOPMOST =  2

  ; Game "loop" variables
  uword score
  ubyte cur_stage
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

  ; Delay between bullets
  ubyte bullet_delay

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

    ; Add startup delay to prevent "start" button press from
    ; immediately trigger start of game
    wait_dticks(6)

    wait_key(32, ">>> press space to start <<<",
             base.LBORDER + 6, base.DBORDER - 1, &start_msg_cols);
  }

  sub game_loop() {
    base.clear_screen()
    decor.draw()
    base.draw_extra_border()

    player_lives = 3
    score = 0
    cur_stage = 1
    bullet_delay = 0

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

      ; controll sound effects
      sound.check()

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
      
      if player_lives == 0
        return

      ; Check joystick
      base.pull_joystick_info()
      if base.joystick_fire() { 
        if bullet_delay == 0 {
          gun.fire()
          bullet_delay = 3
        } else 
	  bullet_delay--
      }

      if base.joystick_left() {
        gun.set_left()
      } else if base.joystick_right() {
        gun.set_right()
      }
   
      ubyte key = c64.GETIN()
      if key == 0
        goto loop

      when key {
  	  157, ',' -> gun.set_left()
	   29, '/' -> gun.set_right()
	   32      -> gun.fire()
      }
    }    
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

    sound.off()
    base.clear_screen()
    game_over.draw()

    wait_key(13, "press return to continue",
             base.LBORDER + 8, base.DBORDER - 2, &end_msg_cols)
  }

  sub wait_dticks(ubyte dticks) {
    ubyte time_lo = lsb(c64.RDTIM16())
    c64.SETTIM(0,0,0)

wait_loop:
    if time_lo > 10 {
      dticks--
      if dticks == 0
        return
      c64.SETTIM(0,0,0)
    }
    time_lo = lsb(c64.RDTIM16())
    goto wait_loop
  }

  sub wait_key(ubyte key, uword strRef, ubyte x, ubyte y, uword colRef) {
    ubyte time_lo = lsb(c64.RDTIM16())
    ubyte col = 0 

    ubyte inp = 0
    while inp != key {
       inp = c64.GETIN()
       if time_lo >= 2 {
	 c64.SETTIM(0,0,0)
         splash.write( colRef[col], x, y, strRef )
	 col++
	 if col == 20
	   col = 0
       }
       ; Let's also check joystick start
       base.pull_joystick_info()
       if base.joystick_start()
         return

       time_lo = lsb(c64.RDTIM16())
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

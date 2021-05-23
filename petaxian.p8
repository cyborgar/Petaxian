%import syslib
%import textio

%import base_cx16
;%import base_c64

%import title
%import usage
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
  

  ; Used for coding two bool's in one byte
  const ubyte LEFTMOST = 1 
  const ubyte TOPMOST =  2

  ; Game "loop" variables
  uword score
  uword next_new_life
  ubyte cur_stage
  ubyte player_lives
  uword wave_ticks
  ubyte bonus
  ubyte wave_time

  ; This variable is used to allow bullets and explosions to complete at
  ; the end of a stage before starting the next. And prevent new bullets
  ; during this delay
  ubyte stage_start_delay = 0

  ; Variable enemy speed
  ubyte enemy_speed = 3
  ubyte enemy_sub_counter

  ; Fixed player speed? Power ups? Split gun/bullet speed?
  ubyte player_speed = 2
  ubyte player_sub_counter
  ubyte glide_movement = 1;  Keyboard "glide" mechanic for now

  ; Delay for animation 
  const ubyte ANIMATION_SPEED = 5
  ubyte animation_sub_counter

  ; Delay between bullets
  ubyte bullet_delay

  sub start() {
    base.platform_setup()

    repeat {
      game_title()
      game_loop()
      game_end()
    }
  }

  sub game_title() {
    txt.clear_screen()
    title.draw()
    usage.setup()

    ; Add startup delay to prevent "start" button press from
    ; immediately trigger start of game
    sys.wait(50)

    wait_key(32, ">>> press start or space to begin <<<",
             base.LBORDER + 1, base.DBORDER - 1, &start_msg_cols, 1);
  }

  sub game_loop() {
    txt.clear_screen()
    decor.draw()
    base.draw_extra_border() ; Mark unused area on XC16

    player_lives = 3
    score = 0
    next_new_life = 1000
    cur_stage = 0
    bullet_delay = 0

    attack.set_data()
    enemy.set_data()
    gun.set_data()
    gun_bullets.set_data()
    bombs.set_data()

    repeat {
      ubyte time_lo = lsb(c64.RDTIM16())

      ; May needed to find a better timer
      if time_lo >= 1 {
        c64.SETTIM(0,0,0)
	wave_ticks++

        ; controll sound effects
        sound.check()

        ; Player movements
        player_sub_counter++
        if player_sub_counter == player_speed {
          ; Check joystick
          joystick.pull_info()
          if joystick.pushing_fire() { 
            if bullet_delay == 0 {
              gun.fire()
              bullet_delay = 3
            } else 
              bullet_delay--
          }

          if joystick.pushing_left() {
            gun.set_left()
          } else if joystick.pushing_right() {
            gun.set_right()
          }
   
          ubyte key = c64.GETIN()

          when key {
             157, ',' -> gun.set_left()
              29, '/' -> gun.set_right()
                  'z' -> gun.fire()
          }

          gun_bullets.move()
          gun.move()
          if glide_movement == 0  ; If joystic "mode" is set avoid gliding
	    gun.direction = 0

          player_sub_counter = 0
        }

        ; Enemy movement
        enemy_sub_counter++
        if enemy_sub_counter == enemy_speed {
	  enemy.trigger_attack()
          enemy.move_all()
	  enemy_sub_counter = 0
          bombs.move()
          enemy.spawn_bomb()
        }

        if (enemy.enemies_left == 0) {
          if stage_start_delay == 0 {  ; Increase stage at start of counter
	    if cur_stage == 0 
	      stage_start_delay = 150 ; Skip stage bonus display at start
	    else {
              wave_time = wave_ticks / 60 as ubyte
	      if wave_time >= stage.bonus_times[cur_stage-1]
	        bonus = 0
	      else
                bonus = stage.bonus_times[cur_stage-1] - wave_time
	      if bonus < 0 ; Set bonus to 0 if playtime is > bonus time
	        bonus = 0
            }
            cur_stage++
	  }
          stage_start_delay++
	  if stage_start_delay < 150 {
            stage_bonus()
	  } else if stage_start_delay < 250 {
            stage_announce()
          } else {
            if cur_stage > stage.MAX_STAGE    ; Probably should just 
              cur_stage = 1                   ; loop final stage
            enemy.setup_stage(cur_stage - 1)
            printStage()
            stage_start_delay = 0
            wave_ticks = 0
          }
        }

        ; explosions etc.
        animation_sub_counter++
        if animation_sub_counter == ANIMATION_SPEED {
          animation_sub_counter = 0
          explosion.animate()
        }
      
        if player_lives == 0
          return
      }    
    }
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
    txt.clear_screen()
    game_over.draw()

    wait_key(32, "press start or space to continue",
             base.LBORDER + 4, base.DBORDER - 1, &end_msg_cols, 0)
  }

  sub wait_key(ubyte key, uword strRef, ubyte x, ubyte y,
               uword colRef, ubyte do_usage) {
    ubyte time_lo = lsb(c64.RDTIM16())
    ubyte col = 0 

    ubyte inp = 0
    while inp != key {
       inp = c64.GETIN()
       if time_lo >= 2 {
	 c64.SETTIM(0,0,0)
         title.write( colRef[col], x, y, strRef )
	 col++
	 if col == 20 {
	   col = 0
	   if do_usage
             usage.draw()
	 }
       }
       ; Let's also check joystick start
       joystick.pull_info()
       if joystick.pushing_start()
         return

       time_lo = lsb(c64.RDTIM16())
    }
  }

  sub stage_bonus() {
    when stage_start_delay {
      10,35 -> {
        txt.setcc(base.LBORDER + 4, base.UBORDER + 5, bonus / 10 + $30, 1)
        txt.setcc(base.LBORDER + 5, base.UBORDER + 5, bonus % 10 + $30, 1)
        title.write( 3, base.LBORDER + 7, base.UBORDER + 5, "bonus sec" )
      }
      70 -> {
        title.write( 1, base.LBORDER + 17, base.UBORDER + 5, "--0 points" )
	ubyte score_bonus = 5 * bonus ; Doing on tenth as byte to cheat
	add_score(score_bonus as uword * 10)
        txt.setcc(base.LBORDER + 17, base.UBORDER + 5, score_bonus / 10 + $30, 1)
        txt.setcc(base.LBORDER + 18, base.UBORDER + 5, score_bonus % 10 + $30, 1)	
      }
      140 -> {
        title.write( 4, base.LBORDER + 2, base.UBORDER + 5,
	             "                         " )
      }
    }
  }

  sub stage_announce() {
    when stage_start_delay {
      170,200,230 -> {
        title.write( 3, base.LBORDER + 12, base.UBORDER + 5, "stage:" )
        txt.setcc(base.LBORDER + 19, base.UBORDER + 5, cur_stage / 10 + $30, 1)
        txt.setcc(base.LBORDER + 20, base.UBORDER + 5, cur_stage % 10 + $30, 1)
      }
     190,220,249 -> {
        title.write( 3, base.LBORDER + 12, base.UBORDER + 5, "         " )
      }
    }
  }

  sub add_score(uword points) {
    score += points

    if score >= next_new_life {
      player_lives++
      next_new_life += 3000
      printLives()
    }
    printScore()
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
    txt.setcc(base.RBORDER + 8, base.UBORDER + 4, player_lives + 176, 1 )
  }

  sub printStage() {
    txt.setcc(base.RBORDER + 7, base.UBORDER + 6, cur_stage / 10 + 176, 1)
    txt.setcc(base.RBORDER + 8, base.UBORDER + 6, cur_stage % 10 + 176, 1)
  }

  sub printDebug(ubyte line, ubyte val) {
    ubyte var = val % 10
    txt.setcc(base.RBORDER + 8, base.UBORDER + line, var+176, 1)
    val /= 10
    var = val % 10
    txt.setcc(base.RBORDER + 7, base.UBORDER + line, var+176, 1)
    val /= 10
    txt.setcc(base.RBORDER + 6, base.UBORDER + line, val+176, 1)
  }
}

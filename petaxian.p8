%import syslib
%import textio

%import base

%import title
%import roller
%import decor
%import game_over

%import stage

%import gun
%import enemy
%import bombs
%import seeker_bombs
%import cluster_bombs
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
  const ubyte NOT_LEFTMOST = ~1 ; For asm
  const ubyte NOT_TOPMOST = ~2  ; For asm

  ; Game "loop" variables
  uword hiscore
  uword score
  uword bonus_score ; Track score from time bonuses for "stats"
  uword next_new_life
  ubyte cur_stage
  ubyte player_lives
  uword wave_ticks
  ubyte bonus
  ubyte wave_time
  ubyte seeker_delay

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
  ubyte glide_movement = 0;  Keyboard "glide" mechanic for now

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
    roller.setup()

    ; Add startup delay to prevent "start" button press from
    ; immediately trigger start of game
    sys.wait(50)

    wait_key(32, ">>> press fire or start to begin <<<",  2, 23, 
             &start_msg_cols, 1);
  }

  sub game_loop() {
    txt.clear_screen()
    decor.draw()
    base.draw_extra_border() ; Mark unused area on XC16

    player_lives = 3
    score = 0
    bonus_score = 0
    next_new_life = 1000
    cur_stage = 0
    bullet_delay = 0
    seeker_delay = 0

    attack.set_data()
    enemy.set_data()
    gun.set_data()
    gun_bullets.set_data()

    bombs.set_data()
    seeker_bombs.set_data()
    cluster_bombs.set_data()

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
          keyboard.pull_info();

          if joystick.pushing_fire() or keyboard.pushing_fire() { 
            if bullet_delay == 0 {
              gun.fire()
              bullet_delay = 3
            } else 
              bullet_delay--
          }

          if joystick.pushing_left() or keyboard.pushing_left() {
            gun.set_left()
          } else if joystick.pushing_right() or keyboard.pushing_right() {
            gun.set_right()
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
          cluster_bombs.move()

          ; Make seekers slower than other bombs
          if seeker_delay {
            seeker_bombs.move()
            seeker_delay = 0
          } else {
            seeker_delay = 1
          }

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
            }
            cur_stage++
          }
          stage_start_delay++
          if stage_start_delay < 150 {
            stage_bonus()
          } else if stage_start_delay < 250 {
            if cur_stage > stage.MAX_STAGE { ; Game won we return (after bonus)
              stage_start_delay = 0
              return
            }
            stage_announce()
          } else {
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
      sound.check()

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

    txt.clear_screen()
    
    if cur_stage > stage.MAX_STAGE
      game_over.draw_victory()
    else
      game_over.draw_defeat()
    sound.off()

    wait_key(32, ">> press fire or start to continue <<", 1, 23,
            &end_msg_cols, 0)
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
         write( colRef[col], x, y, strRef )
         col++
         if col == 20 {
           col = 0
           if do_usage
             roller.draw()
         }
       }
       ; Let's also check joystick start (push up on c64) or fire
       joystick.pull_info()
       if joystick.pushing_start() or joystick.pushing_fire()
         return

       time_lo = lsb(c64.RDTIM16())
    }
  }

  sub stage_bonus() {
    when stage_start_delay {
      10,35 -> {
        printNumber(4, 5, bonus as uword, 2)
        write( 3, 7, 5, "bonus sec" )
      }
      70 -> {
        write( 1, 17, 5, "--- points" )
        uword score_bonus = bonus as uword * 50
        add_score(score_bonus)
        bonus_score += score_bonus
        printNumber(17, 5, score_bonus, 3)
      }
      140 -> {
        write( 4, 2, 5, "                         " )
      }
    }
  }

  sub stage_announce() {
    when stage_start_delay {
      170,200,230 -> {
        write( 3, 12, 5, "stage:" )
        printNumber(19, 5, cur_stage, 2)
      }
     190,220,249 -> {
        write( 3, 12, 5, "         " )
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

  ; To be replaced when a better solution is found
  sub printHiscore() {
     conv.str_uw0(hiscore)
     write(1, 12, 10, "hiscore:")
     write(1, 21, 10, conv.string_out)
  }

  ; Convert/display uword value as desimal on screen. Uses function
  ; from Prog conv library to convert from uword to decimal string
  sub printNumber(ubyte x, ubyte y, uword val, ubyte digits) {
    ubyte pos_adj = 5 - digits
    ubyte i
    conv.str_uw0(val)
    for i in pos_adj to 4 {
      txt.setcc(base.LBORDER + x + i - pos_adj, base.UBORDER + y,
        conv.string_out[i], 1)
    }
  }

  ; Similar to printNumber but we want the "reversed" number chars
  sub printScore() { 
    conv.str_uw0(main.score)
    ubyte i
    for i in 0 to 4 {
      txt.setcc(base.RBORDER + 4 + i, base.UBORDER + 2,
        conv.string_out[i] + 128, 1)
    }
  }

  sub printLives() {
    txt.setcc(base.RBORDER + 8, base.UBORDER + 4, player_lives + 176, 1 )
  }

  ; Get "reversed" numbers
  sub printStage() {
    txt.setcc(base.RBORDER + 7, base.UBORDER + 6, cur_stage / 10 + 176, 1)
    txt.setcc(base.RBORDER + 8, base.UBORDER + 6, cur_stage % 10 + 176, 1)
  }

  sub write(ubyte col, ubyte x, ubyte y, uword messageptr) {
    txt.color(col)
    txt.plot( base.LBORDER + x, base.UBORDER + y )
    txt.print( messageptr )
  }


}

%import syslib
%import textio

%import splash
%import decor
%import game_over

%import gun
%import enemy
%import bombs
%import explosion

main {
  const ubyte CLR = $20

  ; Define playfield limits
  const ubyte LBORDER = 0
  const ubyte RBORDER = 30;
  const ubyte UBORDER = 0
  const ubyte DBORDER = UBORDER + 24;

  ; Coding two bools in one byte. 
  const ubyte LEFTMOST = 1 
  const ubyte TOPMOST =  2

  ; Game "loop" variables
  uword score = 0
  ubyte cur_wave = 0
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

    ; Set 40 column mode - Remove this line to compile for C64
    void cx16.screen_set_mode(0)

    while 1 {
      game_title()
      game_loop()
      game_end()
    }
  }

  sub game_title() {
    splash.clear()
    splash.draw()
    splash.write( 3, LBORDER + 10, DBORDER - 4, "press space to start" )

    wait_key(32);
  }

  sub game_loop() {
    splash.clear()
    decor.draw()

    player_lives = 3
    score = 0
    cur_wave = 0 

    enemy.set_data()
    gun.set_data()
    gun_bullets.set_data()
    bombs.set_data()
    enemy.setup_wave(cur_wave)

    printScore()
    printLives()
    printWave()

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
        cur_wave++
        if cur_wave > 1 ; only two "waves" right now
          cur_wave = 0
        enemy.setup_wave(cur_wave)
	printWave()
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

    game_over.clear()
    game_over.draw()

    splash.write( 3, LBORDER + 8, DBORDER - 2, "press return to continue" )
    wait_key(13);    
  }

  sub printScore() {
    uword tmp = score

    ubyte var = tmp % 10 as ubyte
    txt.setcc(RBORDER + 8, UBORDER + 2, var+176, 1)
    tmp /= 10
    var = tmp % 10 as ubyte
    txt.setcc(RBORDER + 7, UBORDER + 2, var+176, 1)
    tmp /= 10
    var = tmp % 10 as ubyte
    txt.setcc(RBORDER + 6, UBORDER + 2, var+176, 1)
    tmp /= 10
    var = tmp % 10 as ubyte
    txt.setcc(RBORDER + 5, UBORDER + 2, var+176, 1)
    var = tmp / 10 as ubyte
    txt.setcc(RBORDER + 4, UBORDER + 2, var+176, 1)
  }

  sub printLives() {
    txt.setcc(RBORDER + 8, UBORDER + 4, player_lives + 176, 1 )
  }

  sub printWave() {
    txt.setcc(RBORDER + 7, UBORDER + 6, cur_wave / 10 + 176, 1)
    txt.setcc(RBORDER + 8, UBORDER + 6, cur_wave % 10 + 176, 1)
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

}

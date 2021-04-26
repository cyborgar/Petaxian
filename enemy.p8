;
; Enemy ships are like the "gun" drawn using "half character" movement
; through PETSCII chars so handling this is a bit interesting. I.e movement
; is either just shifting chars in place or a combination of both regular
; movement of char position and internal chars shifting.
;
; "Halfbyte" chars are used to draw stuff and there are 16 chars for
; all possible combinations. We can represent one char with 4 bits (also
; known as a "nibble") We can thus have 2 nibbles in each ubyte 
;
; The initial enemy require 2 x 2 nibbles which then require 2 ubyte.
; (first ubyte represent the 2 upper nibbles and second the 2 lower nibbles.
; Within the 4x4 grid pattern represented here the enemy can have
; 4 different postion so we need 8 ubytes to represent each direction the
; enemy ship can face.
;
; We want enemy ship drawn in all directions, wich require 32 ubytes all
; together
;
; Note that we use a seprate function to extract upper and lower nibbles,
; and then the nibble is used to look up actual PETSCII char for the 4 bit
; "block" chars
;

%import special
%import move_patterns

enemy {
  
  const ubyte DIR_RIGHT = 0 ; Direction indexes into above "structure"
  const ubyte DIR_DOWN  = 8
  const ubyte DIR_LEFT  = 16
  const ubyte DIR_UP    = 24

  ; X
  ;  X 
  ; X 

  ; TopLeft   TopRight  BottomL   BottomR
  ubyte[] raider = [
    $90, $10, $24, $20, $40, $60, $80, $81,  ; Enemy moving right
    $91, $00, $26, $00, $44, $20, $88, $01,  ; Enemy moving down
    $81, $01, $06, $02, $04, $24, $08, $09,  ; Enemy moving left
    $80, $11, $04, $22, $00, $64, $00, $89 ] ; Enemy moving up

  ; X
  ; XX
  ; X
  ubyte[] raider2 = [
    $D0, $10, $A4, $20, $40, $70, $80, $A1,
    $B1, $00, $27, $00, $C4, $20, $8C, $01,
    $85, $01, $0E, $02, $04, $25, $08, $0B,
    $80, $31, $04, $23, $00, $E4, $00, $8D ]

  ; XX
  ;  XX
  ; XX
  ubyte[] raider3 = [
    $B4, $30, $2D, $21, $C0, $E1, $84, $87,
    $D5, $20, $AE, $01, $44, $B1, $88, $27,
    $E1, $21, $87, $03, $84, $B4, $0C, $2F,
    $E4, $11, $8D, $22, $80, $75, $04, $AB ]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Enemy data strcture held in array
  ; Use offsets to "emulate" something like a strcutre
  ;
  const ubyte EN_ACTIVE = 0 ; Placed first for quick checking
  const ubyte EN_PAT    = 1 ; Only one movement pattern so far
  const ubyte EN_DELAY  = 2 ; Deployment delay counter
  const ubyte EN_WAVE_DELAY = 3; Deploy pattern delay
  const ubyte EN_MOVE_CNT = 4 ; Pattern count. Movement in pattern.
  const ubyte EN_X      = 5 ; x char pos
  const ubyte EN_Y      = 6 ; y char pos
  const ubyte EN_SUBPOS = 7 ; leftmost/topmost coded as bits
  const ubyte EN_DIR    = 8 ; 
  const ubyte EN_DURAB  = 9; durability value (thoughness)
  const ubyte EN_FIELDS = 10
  ; Max number of enemies in structure
  const ubyte ENEMY_COUNT = 16
  ; Actual array holding enemies
  ubyte[EN_FIELDS * ENEMY_COUNT] enemyData 

  ; How many enemies left in wave
  ubyte enemies_left
 
  ; Temp variables to hold deltas for movement of enemies
  byte delta_x
  byte delta_y

  ; Temp vars in all the subs
  ubyte cur
  ubyte tmp_x
  ubyte tmp_y

  sub setup_wave(ubyte cur_wave) {
    uword WaveRef = wave.list[cur_wave]

    ubyte i = 0
    ubyte level

    ; Each way have potentially 3 "lines" of enemies 
    for level in 0 to 2 {
      if WaveRef[ 0 ] == true {
        enemies_left += 8
        while( i < enemies_left ) { 
          setup_enemy(i, WaveRef[wave.WV_DEPL_DELAY] + i*4, 
	  	      WaveRef[wave.WV_PAT], WaveRef[wave.WV_WAVE_DELAY],
		      main.LEFTMOST)
          i++
        }
      }
      WaveRef += 4
    }
  }

  ; Initiate one enemy
  sub setup_enemy( ubyte enemy_num, ubyte move_delay, ubyte pattern,
                   ubyte wave_delay, ubyte leftmost ) {
    uword enemyRef = &enemyData + enemy_num * EN_FIELDS

    enemyRef[EN_ACTIVE] = 1 ; All enemies active at deployment
    enemyRef[EN_PAT] = pattern ;
    uword PatternRef = move_patterns.list[pattern]
    enemyRef[EN_DELAY] = move_delay ; Delayed deployment counter
    enemyRef[EN_WAVE_DELAY] = wave_delay
    enemyRef[EN_MOVE_CNT] = 0
    enemyRef[EN_X] = PatternRef[move_patterns.MP_START_X]
    enemyRef[EN_Y] = PatternRef[move_patterns.MP_START_Y]
    enemyRef[EN_SUBPOS] = main.LEFTMOST
    enemyRef[EN_DIR] = PatternRef[move_patterns.MP_DIR];
    enemyRef[EN_DURAB] = 1; Not in use yet
  }

  sub set_deltas(ubyte enemy_num, ubyte mvdir) {
    uword enemyRef = &enemyData + enemy_num * EN_FIELDS
    
    delta_x = 0
    delta_y = 0
    
    if mvdir & 2 {
      delta_y = 1
      enemyRef[EN_DIR] = DIR_DOWN
    }
    if mvdir & 8 {
      delta_y = -1
      enemyRef[EN_DIR] = DIR_UP
    }

    ; left/right direction override up/down
    if mvdir & 1 {
      delta_x = 1
      enemyRef[EN_DIR] = DIR_RIGHT
    }
    if mvdir & 4 {
      delta_x = -1
      enemyRef[EN_DIR] = DIR_LEFT
    }

    ; Awful, need to find some better way than this
    cur = enemyRef[EN_PAT];
    if cur <= 1
      enemyRef[EN_DIR] = DIR_DOWN
  }

  sub move_all() {
    ubyte i = 0
    while( i < ENEMY_COUNT ) { 
      move(i)
      i++
    }
  }

  sub move(ubyte enemy_num) {
    uword enemyRef = &enemyData + enemy_num * EN_FIELDS

    if enemyRef[EN_ACTIVE] == 0
      return

    ; pre-display position
    if enemyRef[EN_MOVE_CNT] <= enemyRef[EN_DELAY] {
      enemyRef[EN_MOVE_CNT]++
      return
    }

    uword PatternRef = move_patterns.list[ enemyRef[EN_PAT] ]

    ; At end of all patterns we go to "baseline" move (pattern 0 or 1)
    ; based on deployment direction. Also reset all counters, movement
    ; is relative after deployment
    if enemyRef[EN_MOVE_CNT] > PatternRef[ move_patterns.MP_MOVE_COUNT ]
      + enemyRef[EN_WAVE_DELAY] {
      ubyte stable = enemyRef[EN_PAT] & 1
      enemyRef[EN_PAT] = stable
      enemyRef[EN_DELAY] = 0
      enemyRef[EN_WAVE_DELAY] = 0
      enemyRef[EN_MOVE_CNT] = 1 ; 
    }

    set_deltas( enemy_num, PatternRef[ move_patterns.MP_MOVE_COUNT
        + enemyRef[EN_MOVE_CNT] - enemyRef[EN_DELAY] ] )

    if delta_x == -1
      move_left(enemy_num)
    if delta_x == 1
      move_right(enemy_num)

    if delta_y == -1
      move_up(enemy_num)
    if delta_y == 1
      move_down(enemy_num)

    enemyRef[EN_MOVE_CNT]++
  }

  sub move_left(ubyte enemy_num) {
    uword enemyRef = &enemyData + enemy_num * EN_FIELDS

    if enemyRef[EN_SUBPOS] & main.LEFTMOST {
      clear(enemy_num)
      enemyRef[EN_X]--
      enemyRef[EN_SUBPOS] &= ~main.LEFTMOST
      draw(enemy_num)
    } else {
      enemyRef[EN_SUBPOS] |= main.LEFTMOST
      draw(enemy_num)
    }
  }

  sub move_right(ubyte enemy_num) {
    uword enemyRef = &enemyData + enemy_num * EN_FIELDS
    
    if enemyRef[EN_SUBPOS] & main.LEFTMOST {
      enemyRef[EN_SUBPOS] &= ~main.LEFTMOST
      draw(enemy_num)
    } else {
      clear(enemy_num)
      enemyRef[EN_X]++
      enemyRef[EN_SUBPOS] |= main.LEFTMOST
      draw(enemy_num)
    }
  }
  
  sub move_up(ubyte enemy_num) {
    uword enemyRef = &enemyData + enemy_num * EN_FIELDS
    
    if enemyRef[EN_SUBPOS] & main.TOPMOST {
      clear(enemy_num)
      enemyRef[EN_Y]--
      enemyRef[EN_SUBPOS] &= ~main.TOPMOST
      draw(enemy_num)
    } else {
      enemyRef[EN_SUBPOS] |= main.TOPMOST
      draw(enemy_num)
    }
  }

  sub move_down(ubyte enemy_num) {
    uword enemyRef = &enemyData + enemy_num * EN_FIELDS
      
    if enemyRef[EN_SUBPOS] & main.TOPMOST {
      enemyRef[EN_SUBPOS] &= ~main.TOPMOST
      draw(enemy_num)
    } else {
      clear(enemy_num)
      enemyRef[EN_Y]++
      enemyRef[EN_SUBPOS] |= main.TOPMOST
      draw(enemy_num)
    }
  }

  sub clear(ubyte enemy_num) {
    uword enemyRef = &enemyData + enemy_num * EN_FIELDS

    tmp_x = enemyRef[EN_X]
    tmp_y = enemyRef[EN_Y]

    txt.setcc2(tmp_x,   tmp_y,   main.CLR, 1)
    txt.setcc2(tmp_x+1, tmp_y,   main.CLR, 1)
    txt.setcc2(tmp_x,   tmp_y+1, main.CLR, 1)
    txt.setcc2(tmp_x+1, tmp_y+1, main.CLR, 1)
  }

  sub draw(ubyte enemy_num) {
    uword enemyRef = &enemyData + enemy_num * EN_FIELDS

    tmp_x = enemyRef[EN_X]
    tmp_y = enemyRef[EN_Y]  
    
    ; Look up sub-byte position
    cur = enemyRef[EN_DIR]
    cur += (not enemyRef[EN_SUBPOS] & main.TOPMOST) * 4
    cur += (not enemyRef[EN_SUBPOS] & main.LEFTMOST) * 2

    ; Convert first byte to two PETSCII chars and draw
    ubyte ship_byte = raider[cur]
    txt.setcc2(tmp_x,   tmp_y, convert.get_high(ship_byte), 5)
    txt.setcc2(tmp_x+1, tmp_y, convert.get_low(ship_byte), 5)
    
    ; Convert second byte and draw
    ship_byte = raider[cur+1]
    txt.setcc2(tmp_x,   tmp_y+1, convert.get_high(ship_byte), 5)
    txt.setcc2(tmp_x+1, tmp_y+1, convert.get_low(ship_byte), 5)
  }

  ; Check for enemy detection. Currently we only allow a single
  ; hit (so we can return on a full hit).
  sub check_collision(uword bulletRef) -> ubyte {
    ubyte i = 0
    while( i < ENEMY_COUNT ) {
      uword enemyRef = &enemyData + i * EN_FIELDS

      if enemyRef[EN_ACTIVE] > 0 {
        ; First check if we have Y position hit

        if bulletRef[gun_bullets.BD_Y] == enemyRef[EN_Y] or
	    bulletRef[gun_bullets.BD_Y] == enemyRef[EN_Y] + 1 {
          ; Save which Y line hit (upper or lower)
	  ubyte dy = bulletRef[gun_bullets.BD_Y] - enemyRef[EN_Y]
          if bulletRef[gun_bullets.BD_X] == enemyRef[EN_X] or
              bulletRef[gun_bullets.BD_X] == enemyRef[EN_X] + 1 {
	    ; Save which X line hit (left or right)
            ubyte dx = bulletRef[gun_bullets.BD_X] - enemyRef[EN_X]

	    ; We may still have a miss, we need to do some "nibble
            ; matching" 
	    if check_detailed_collision(enemyRef, dx, dy,
                  bulletRef[gun_bullets.BD_LEFTMOST]) {
	      enemyRef[EN_ACTIVE] = 0 ; Turn off
	      clear(i)
	      enemies_left--
	      explosion.trigger(enemyRef[EN_X], enemyRef[EN_Y],
	      			enemyRef[EN_SUBPOS])
	      main.score++
	      main.printScore()

	      return 1
            }
          }
        }
      }
      i++
    }

    return 0
  }

  sub check_detailed_collision( uword enemyRef, ubyte dx, ubyte dy,
                                ubyte leftmost ) -> ubyte {

    ubyte bullet_nib
    if leftmost ; Set nibble value for bullet
      bullet_nib = 5
    else
      bullet_nib = 10

    ; Get petscii value at screen pos
    tmp_x = enemyRef[EN_X] + dx
    tmp_y = enemyRef[EN_Y] + dy
           
    ; Get and map to Map from char to nibble ?
    ubyte nibble = convert.to_nibble( txt.getchr(tmp_x,tmp_y))

    if ( nibble & bullet_nib)
      return 1

    return 0
  }

  sub spawn_bomb() {
    ; First check if we are spawning a bomo
    ubyte chance = rnd() % 100
    if chance > 10
      return

    ; Find random enemy
    ubyte enemy_num = rnd() % ENEMY_COUNT

    ; Check if it's active
    uword enemyRef = &enemyData + enemy_num * EN_FIELDS
    if enemyRef[EN_ACTIVE] != 1
      return

    if enemyRef[EN_PAT] > 1 ; Not in stable pattern yet
      return

    bombs.trigger(enemyRef[EN_X], enemyRef[EN_Y], enemyRef[EN_SUBPOS])
  }

}

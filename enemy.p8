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

  ubyte[] raider = [
    $90, $10, $24, $20, $40, $60, $80, $81,  ; --- Moving left
    $91, $00, $26, $00, $44, $20, $88, $01,  ; --- Moving down
    $81, $01, $06, $02, $04, $24, $08, $09,  ; --- Moving right
    $80, $11, $04, $22, $00, $64, $00, $89 ] ; --- Moving up

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Enemy data strcture held in array
  ; Use offsets to "emulate" something like a strcutre
  ;
  const ubyte EN_ACTIVE = 0 ; Placed first for quick checking
  const ubyte EN_PAT    = 1 ; Only one movement pattern so far
  const ubyte EN_DELAY  = 2 ; Deployment delay counter
  const ubyte EN_MOVE_CNT = 3 ; Pattern count. Movement in pattern.
  const ubyte EN_X      = 4 ; x char pos
  const ubyte EN_Y      = 5 ; y char pos
  const ubyte EN_LEFTM  = 6 ; char pos leftomost?
  const ubyte EN_TOPM   = 7 ; char pos teopmost?
  const ubyte EN_DIR    = 8 ; 
  const ubyte EN_DURAB  = 9  ; durability value (thoughness)
  const ubyte EN_FIELDS = 10
  ; Max number of enemies in structure
  const ubyte ENEMY_COUNT = 8
  ; Actual array holding enemies
  ubyte[EN_FIELDS * ENEMY_COUNT] enemyData 

  ; How many enemies left in wave
  ubyte enemies_left
 
  ; Temp variables to hold deltas for movement of enemies
  byte delta_x
  byte delta_y

  ; Temporary debug variable 
  uword move_tick = 0

  ; Temp vars in all the subs
  ubyte en_offset
  ubyte cur
  ubyte tmp_x
  ubyte tmp_y
  ubyte i

  ; Initiate enemies - later include "wave" config here maybe
  sub setup() {
    i = 0
    while( i < ENEMY_COUNT ) { 
      setup_enemy( i, i * 4, 1 )
      i++
    }
    enemies_left = ENEMY_COUNT
  }

  ; Initiate one enemy
  sub setup_enemy( ubyte enemy_num, ubyte move_delay, ubyte pattern ) {
    en_offset = enemy_num * EN_FIELDS

    enemyData[en_offset + EN_ACTIVE] = 1 ; All enemies active at deployment
    enemyData[en_offset + EN_PAT] = pattern ;
    uword PatternRef = move_patterns.list[pattern]
    enemyData[en_offset + EN_DELAY] = move_delay ; Delayed deployment counter
    enemyData[en_offset + EN_MOVE_CNT] = 0  
    enemyData[en_offset + EN_X] = PatternRef[move_patterns.MP_START_X]
    enemyData[en_offset + EN_Y] = PatternRef[move_patterns.MP_START_Y]
    enemyData[en_offset + EN_LEFTM] = true
    enemyData[en_offset + EN_TOPM] = false
    enemyData[en_offset + EN_DIR] = PatternRef[move_patterns.MP_DIR];
    enemyData[en_offset + EN_DURAB] = 1; Not in use yet
  }

  sub set_deltas(ubyte enemy_num, ubyte mvdir) {
    en_offset = enemy_num * EN_FIELDS

    delta_x = 0
    delta_y = 0
    
    if mvdir & 2 {
      delta_y = 1
      enemyData[en_offset + EN_DIR] = DIR_DOWN
    }
    if mvdir & 8 {
      delta_y = -1
      enemyData[en_offset + EN_DIR] = DIR_UP
    }

    ; left/right direction override up/down
    if mvdir & 1 {
      delta_x = 1
      enemyData[en_offset + EN_DIR] = DIR_RIGHT
    }
    if mvdir & 4 {
      delta_x = -1
      enemyData[en_offset + EN_DIR] = DIR_LEFT
    }

    ; Awful, need to find some better way than this
    cur = enemyData[en_offset + EN_PAT];
    if cur == 0
      enemyData[en_offset + EN_DIR] = DIR_DOWN
  }

  sub move_all() {
    move_tick++ ; Test variable priting out "step" count
    i = 0
    while( i < ENEMY_COUNT ) { 
      move(i)
      i++
    }
  }

  sub move(ubyte enemy_num) {
    en_offset = enemy_num * EN_FIELDS

    if enemyData[en_offset + EN_ACTIVE] == 0
      return

    ; Need this variable a few times so this should be more efficent
    uword EnemyMoveCnt = & enemyData + en_offset + EN_MOVE_CNT

    @(EnemyMoveCnt)++

    if @(EnemyMoveCnt) <= enemyData[en_offset + EN_DELAY] ; pre-display position
      return

    uword PatternRef = move_patterns.list[ enemyData[en_offset + EN_PAT] ]

    ; At end of all patterns we go to "baseline" move (pattern 0)
    ; reset all counters, movement is relative after deployment
    if @(EnemyMoveCnt) == PatternRef[ move_patterns.MP_MOVE_COUNT ] {
      enemyData[en_offset + EN_PAT] = 0
      enemyData[en_offset + EN_DELAY] = 0
      @(EnemyMoveCnt) = 1
    }

    set_deltas( enemy_num, PatternRef[ move_patterns.MP_MOVE_COUNT + @(EnemyMoveCnt)
      - enemyData[en_offset + EN_DELAY] ] )

    if delta_x == -1
      move_left(enemy_num)
    if delta_x == 1
      move_right(enemy_num)

    if delta_y == -1
      move_up(enemy_num)
    if delta_y == 1
      move_down(enemy_num)
  }

  sub move_left(ubyte enemy_num) {
    en_offset = enemy_num * EN_FIELDS

    if enemyData[en_offset + EN_LEFTM] {
      clear(enemy_num)
      enemyData[en_offset + EN_X]--
      enemyData[en_offset + EN_LEFTM] = false
      draw(enemy_num)
    } else {
      enemyData[en_offset + EN_LEFTM] = true
      draw(enemy_num)
    }
  }

  sub move_right(ubyte enemy_num) {
    en_offset = enemy_num * EN_FIELDS
    
    if enemyData[en_offset + EN_LEFTM] {
      enemyData[en_offset + EN_LEFTM] = false
      draw(enemy_num)
    } else {
      clear(enemy_num)
      enemyData[en_offset + EN_X]++
      enemyData[en_offset + EN_LEFTM] = true
      draw(enemy_num)
    }
  }
  
  sub move_up(ubyte enemy_num) {
    en_offset = enemy_num * EN_FIELDS
    
    if enemyData[en_offset + EN_TOPM] {
      clear(enemy_num)
      enemyData[en_offset + EN_Y]--
      enemyData[en_offset + EN_TOPM] = false
      draw(enemy_num)
    } else {
      enemyData[en_offset + EN_TOPM] = true
      draw(enemy_num)
    }
  }

  sub move_down(ubyte enemy_num) {
    en_offset = enemy_num * EN_FIELDS
      
    if enemyData[en_offset + EN_TOPM] {
      enemyData[en_offset + EN_TOPM] = false
      draw(enemy_num)
    } else {
      clear(enemy_num)
      enemyData[en_offset + EN_Y]++
      enemyData[en_offset + EN_TOPM] = true
      draw(enemy_num)
    }
  }

  sub clear(ubyte enemy_num) {
    en_offset = enemy_num * EN_FIELDS

    tmp_x = enemyData[en_offset + EN_X]
    tmp_y = enemyData[en_offset + EN_Y]

    txt.setcc(tmp_x,   tmp_y,   main.CLR, 1)
    txt.setcc(tmp_x+1, tmp_y,   main.CLR, 1)
    txt.setcc(tmp_x,   tmp_y+1, main.CLR, 1)
    txt.setcc(tmp_x+1, tmp_y+1, main.CLR, 1)
  }

  sub draw(ubyte enemy_num) {
    en_offset = enemy_num * EN_FIELDS

    tmp_x = enemyData[en_offset + EN_X]
    tmp_y = enemyData[en_offset + EN_Y]  
    
    ; Look up sub-byte position
    cur = enemyData[en_offset + EN_DIR]
    cur += (not enemyData[en_offset + EN_TOPM]) * 4
    cur += (not enemyData[en_offset + EN_LEFTM]) * 2

    ; Convert first byte to two PETSCII chars and draw
    ubyte ship_byte = raider[cur]
    txt.setcc(tmp_x,   tmp_y, convert.get_high(ship_byte) , 1)
    txt.setcc(tmp_x+1, tmp_y, convert.get_low(ship_byte), 1)
    
    ; Convert second byte and draw
    ship_byte = raider[cur+1]
    txt.setcc(tmp_x,   tmp_y+1, convert.get_high(ship_byte), 1)
    txt.setcc(tmp_x+1, tmp_y+1, convert.get_low(ship_byte), 1)
  }

  ; Check for enemy detection. Currently we only allow a single
  ; hit (so we can return on a full hit).
  sub check_collision(uword BulletRef) -> ubyte {
    i = 0
    while( i < ENEMY_COUNT ) {
      uword EnemyRef = &enemyData + i * EN_FIELDS

      if EnemyRef[EN_ACTIVE] > 0 {
        ; First check if we have Y position hit

        if BulletRef[bullets.BD_Y] == EnemyRef[EN_Y] or
	    BulletRef[bullets.BD_Y] == EnemyRef[EN_Y] + 1 {
          ; Save which Y line hit (upper or lower)
	  ubyte dy = BulletRef[bullets.BD_Y] - EnemyRef[EN_Y]
          if BulletRef[bullets.BD_X] == EnemyRef[EN_X] or
              BulletRef[bullets.BD_X] == EnemyRef[EN_X] + 1 {
	    ; Save which X line hit (left or right)
            ubyte dx = BulletRef[bullets.BD_X] - EnemyRef[EN_X]

	    ; We may still have a miss, we need to do some "nibble
            ; matching" 
	    if check_detailed_collision(EnemyRef, dx, dy) {
	      EnemyRef[EN_ACTIVE] = 0 ; Turn off
	      clear(i)
	      enemies_left--
	      main.score++

	      return 1
            }
          }
        }
      }
      i++
    }

    return 0
  }

  sub check_detailed_collision( uword EnemyRef, ubyte dx, ubyte dy) -> ubyte {

    ubyte bullet_nib
    if EnemyRef[bullets.BD_LEFTMOST] ; Find char for bullet
      bullet_nib = 5
    else
      bullet_nib = 25

    ; Get petscii value at screen pos
    tmp_x = EnemyRef[EN_X] + dx
    tmp_y = EnemyRef[EN_Y] + dy
           
    ; Get and map to Map from char to nibble ?
    ubyte nibble = convert.to_nibble( txt.getchr(tmp_x,tmp_y))

    if ( nibble & bullet_nib)
      return 1

    return 0
  }

}

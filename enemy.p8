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
; 4 different postion so we need 8 ubytes to represent all positions the
; enemy ship can have on the 4x4 grid.
;
; We also want enemy ship drawn facing all directions, so all together we
; require 32 ubytes per "enemy" 
;
; Note that we use a seprate function to extract upper and lower nibbles,
; and then the nibble is used to look up actual PETSCII char for the 4 bit
; "block" chars
;

%import convert
%import move_patterns
%import attack

enemy {
  
  const ubyte DIR_RIGHT = 0 ; Direction indexes into enemy "structure"
  const ubyte DIR_DOWN  = 8
  const ubyte DIR_LEFT  = 16
  const ubyte DIR_UP    = 24

  ; Maps to get from move pattern to x and y deltas for movement
  ; Direction  12 8 9
  ;   pattern   4 0 1  was made for different bit for each direction used
  ;             6 2 3  in delta function, but can now be reduced to 8+1
  byte[] TO_X = [ 1, 1, 0, -1, -1, -1, 0, 1 ]
  byte[] TO_Y = [ 0, 1, 1, 1, 0, -1, -1, -1 ]
  ; Direction left/right have precende over up/down
  ubyte[] TO_DIR = [ DIR_RIGHT, DIR_RIGHT, DIR_DOWN, DIR_LEFT, DIR_LEFT, 
                     DIR_LEFT, DIR_UP, DIR_RIGHT ]

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
    $E1, $21, $87, $03, $84, $B4, $0C, $2D,
    $E4, $11, $8D, $22, $80, $75, $04, $AB ]

  uword[] enemy_types = [ &raider, &raider2, &raider3 ]

  const ubyte RAIDER1 = 0
  const ubyte RAIDER2 = 1
  const ubyte RAIDER3 = 2

  ; Durability array (based on positions above)
  ubyte[] enemy_durability = [ 1, 2, 3 ]
  ; Score value
  ubyte[] enemy_score = [ 5, 10, 15 ]
  ; Color for enemies based on current durability (lookup start at 1)  
  ubyte[] enemy_color = [ 0, 5, 13, 3 ]

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ; Enemy data strcture held in array
  ; Use offsets to "emulate" something like a strcutre
  ;
  const ubyte EN_ACTIVE = 0 ; Placed first for quick checking
  const ubyte EN_PAT    = 1 ; Movement pattern
  const ubyte EN_DELAY  = 2 ; Deployment delay counter
  const ubyte EN_WAVE_DELAY = 3; Deploy pattern delay
  const ubyte EN_MOVE_CNT = 4 ; Pattern count. Movement in pattern.
  const ubyte EN_X      = 5 ; x char pos
  const ubyte EN_Y      = 6 ; y char pos
  const ubyte EN_SUBPOS = 7 ; leftmost/topmost coded as bits
  const ubyte EN_DIR    = 8 ; 
  const ubyte EN_DURAB  = 9 ; durability value (thoughness)
  const ubyte EN_TYPE   = 10; enemy type
  const ubyte EN_ATTACK = 11; Attack recover index
  const ubyte FIELD_COUNT = 12
  ; Max number of enemies in structure
  const ubyte ENEMY_COUNT = 16
  ; Actual array holding enemies
  ubyte[FIELD_COUNT * ENEMY_COUNT] enemyData 

  ; How many enemies left in stage
  ubyte enemies_left

  ; Module variables used to avoid passing to subs as args
  byte delta_x
  byte delta_y
  uword @requirezp enemyRef; Point to data for current enemy

  sub set_data() {
    enemies_left = 0
    sys.memset(&enemyData, FIELD_COUNT * ENEMY_COUNT, 0)
  }

  sub setup_stage(ubyte cur_stage) {
    uword StageRef = stage.list[cur_stage]

    ubyte i = 0
    ubyte wave

    enemyRef = &enemyData

    ; Each stage has 2 waves of 8 enemies
    for wave in 0 to 1 {
      if StageRef[ stage.STG_LINE_ACTIVE ] == true {
        enemies_left += 8
        while i < enemies_left {
          ubyte type_idx = stage.STG_ENEMY_TYPE + i - 8*wave
          setup_enemy(StageRef[stage.STG_DEPL_DELAY] + i*4,
            StageRef[stage.STG_PAT], StageRef[stage.STG_WAVE_DELAY],
          StageRef[type_idx])
          i++
          enemyRef += FIELD_COUNT
        }
      }
      StageRef += stage.FIELD_COUNT
    }
  }

  ; Initiate one enemy
  sub setup_enemy( ubyte move_delay, ubyte pattern,
                   ubyte stage_delay, ubyte enemy_type ) {

    enemyRef[EN_ACTIVE] = 1 ; All enemies active at deployment
    enemyRef[EN_PAT] = pattern ;
    uword PatternRef = move_patterns.list[pattern]
    enemyRef[EN_DELAY] = move_delay - stage_delay ; Delayed deployment counter
    enemyRef[EN_WAVE_DELAY] = stage_delay         ;   relative from wave start
    enemyRef[EN_MOVE_CNT] = 0
    enemyRef[EN_X] = PatternRef[move_patterns.MP_START_X]
    enemyRef[EN_Y] = PatternRef[move_patterns.MP_START_Y]
    if pattern % 2 == 0 
      enemyRef[EN_SUBPOS] = main.LEFTMOST
    else 
      enemyRef[EN_SUBPOS] = 0
    enemyRef[EN_DIR] = PatternRef[move_patterns.MP_DIR];
    enemyRef[EN_DURAB] = enemy_durability[ enemy_type ]
    enemyRef[EN_TYPE] = enemy_type
  }

  ; Convert from single byte direction to x/y deltas
  sub set_deltas(ubyte mvdir) {
    delta_x = TO_X[mvdir]
    delta_y = TO_Y[mvdir]

    ; Lock downward after depolyment
    if enemyRef[EN_PAT] <= move_patterns.LAST_ATTACK {
      enemyRef[EN_DIR] = DIR_DOWN
      return
    }
    enemyRef[EN_DIR] = TO_DIR[mvdir]
  }

  sub move_all() {
    enemyRef = &enemyData
    ubyte i = 0
    while i < ENEMY_COUNT { 
      move()
      i++
      enemyRef += FIELD_COUNT
    }
  }

  sub move() {
    if enemyRef[EN_ACTIVE] == 0
      return

    ; wave delay
    if enemyRef[EN_WAVE_DELAY] {
      enemyRef[EN_WAVE_DELAY]--
      return
    }

    ; pre-display position
    if enemyRef[EN_MOVE_CNT] <= enemyRef[EN_DELAY] {
      enemyRef[EN_MOVE_CNT]++
      return
    }

    ; At end of all patterns we go to "baseline" move (pattern 0 or 1)
    ; (deployment or attacks) based on deployment direction. Also
    ; reset all counters
    uword PatternRef = move_patterns.list[ enemyRef[EN_PAT] ]
    if enemyRef[EN_MOVE_CNT] > PatternRef[ move_patterns.MP_MOVE_COUNT ] {
      if enemyRef[EN_PAT] > 1 and
        enemyRef[EN_PAT] <= move_patterns.LAST_ATTACK {
        attack.end(enemyRef)
      } else { ; Switch from deployment to baseline
        ubyte stable = enemyRef[EN_PAT] & 1
        enemyRef[EN_PAT] = stable
        enemyRef[EN_DELAY] = 0
        enemyRef[EN_WAVE_DELAY] = 0
        enemyRef[EN_MOVE_CNT] = 1
      }
      ; Since we have switch pattern we need to reset the reference
      PatternRef = move_patterns.list[ enemyRef[EN_PAT] ]
    }
    
    ubyte offset = enemyRef[EN_MOVE_CNT] - enemyRef[EN_DELAY]
    set_deltas( PatternRef[move_patterns.MP_MOVE_COUNT + offset] )

    clear()
      
    if delta_x == -1
      move_left()
    else if delta_x == 1
      move_right()

    if delta_y == -1
      move_up()
    else if delta_y == 1
      move_down()

    draw()

    enemyRef[EN_MOVE_CNT]++
  }

  asmsub move_left() clobbers(Y) {
    ; if enemyRef[EN_SUBPOS] & main.LEFTMOST {
    ;   enemyRef[EN_SUBPOS] &= ~main.LEFTMOST
    ;   enemyRef[EN_X]--
    ; } else {
    ;   enemyRef[EN_SUBPOS] |= main.LEFTMOST
    ; }
    %asm {{
      lda #main.LEFTMOST  ; check LEFTMOST (=1) is set
      ldy #enemy.EN_SUBPOS
      and (enemyRef),y    ; AND with EN_SUBPOS
      beq _move_left_else ;   and branch
      lda (enemyRef),y    ; Get EN_SUBPOS
      and #main.NOT_LEFTMOST ; AND with ~main.LEFTMOST
      sta (enemyRef),y     
      sec
      ldy #enemy.EN_X
      lda (enemyRef),y
      sbc #1
      sta (enemyRef),y
      rts
_move_left_else
      lda (enemyRef),y    ; Get EN_SUBPOS
      ora #main.LEFTMOST  ; OR with main.LEFTMOST
      sta (enemyRef),y
      rts
    }}
  }

  asmsub move_right() clobbers(Y) {
    ; if enemyRef[EN_SUBPOS] & main.LEFTMOST {
    ;   enemyRef[EN_SUBPOS] &= ~main.LEFTMOST
    ; } else {
    ;   enemyRef[EN_SUBPOS] |= main.LEFTMOST
    ;   enemyRef[EN_X]++
    ; }
    %asm {{
      lda #main.LEFTMOST  ; check LEFTMOST (=1) is set
      ldy #enemy.EN_SUBPOS
      and (enemyRef),y    ; AND with EN_SUBPOS
      beq _move_right_else;   and branch
      lda (enemyRef),y    ; Get EN_SUBPOS
      and #main.NOT_LEFTMOST ; AND with ~main.LEFTMOST
      sta (enemyRef),y     
      rts
_move_right_else
      lda (enemyRef),y    ; Get EN_SUBPOS
      ora #main.LEFTMOST  ; OR with main.LEFTMOST
      sta (enemyRef),y
      clc
      ldy #enemy.EN_X
      lda (enemyRef),y
      adc #1
      sta (enemyRef),y
      rts
    }}
  }

  asmsub move_up() clobbers(Y) {
    ; if enemyRef[EN_SUBPOS] & main.TOPMOST {
    ;   enemyRef[EN_SUBPOS] &= ~main.TOPMOST
    ;   enemyRef[EN_Y]--
    ; } else {
    ;   enemyRef[EN_SUBPOS] |= main.TOPMOST
    ; }
    %asm {{
      lda #main.TOPMOST   ; check TOPMOST (=2) is set
      ldy #enemy.EN_SUBPOS
      and (enemyRef),y    ; AND with EN_SUBPOS
      beq _move_up_else   ;   and branch
      lda (enemyRef),y    ; Get EN_SUBPOS
      and #main.NOT_TOPMOST ; AND with ~main.TOPMOST
      sta (enemyRef),y     
      sec
      ldy #enemy.EN_Y
      lda (enemyRef),y
      sbc #1
      sta (enemyRef),y
      rts
_move_up_else
      lda (enemyRef),y    ; Get EN_SUBPOS
      ora #main.TOPMOST   ; OR with main.TOPMOST
      sta (enemyRef),y
      rts
    }}
  }

  asmsub move_down() clobbers(Y) {
    ; if enemyRef[EN_SUBPOS] & main.TOPMOST {
    ;   enemyRef[EN_SUBPOS] &= ~main.TOPMOST
    ; } else {
    ;   enemyRef[EN_SUBPOS] |= main.TOPMOST
    ;   enemyRef[EN_Y]++
    ; }
    %asm {{
      lda #main.TOPMOST   ; check TOPMOST (=2) is set
      ldy #enemy.EN_SUBPOS
      and (enemyRef),y    ; AND with EN_SUBPOS
      beq _move_down_else ;   and branch
      lda (enemyRef),y    ; Get EN_SUBPOS
      and #main.NOT_TOPMOST ; AND with ~main.TOPMOST
      sta (enemyRef),y     
      rts
_move_down_else
      lda (enemyRef),y    ; Get EN_SUBPOS
      ora #main.TOPMOST   ; OR with main.TOPMOST
      sta (enemyRef),y
      clc
      ldy #enemy.EN_Y
      lda (enemyRef),y
      adc #1
      sta (enemyRef),y
      rts
    }}
  }

  asmsub clear() clobbers (A, Y) {
    ; ubyte tmp_x = enemyRef[EN_X]
    ; ubyte tmp_y = enemyRef[EN_Y]
    ;
    ; txt.setcc(tmp_x,   tmp_y,   main.CLR, 1)
    ; txt.setcc(tmp_x+1, tmp_y,   main.CLR, 1)
    ; txt.setcc(tmp_x+1, tmp_y+1, main.CLR, 1)
    ; txt.setcc(tmp_x,   tmp_y+1, main.CLR, 1)
   %asm {{
      ldy #enemy.EN_X
      lda (enemyRef),y
      sta txt.setcc.column
      ldy #enemy.EN_Y
      lda (enemyRef),y
      sta txt.setcc.row
      lda #$20
      sta txt.setcc.char
      lda #$01
      sta txt.setcc.charcolor
      jsr txt.setcc
      inc txt.setcc.column
      jsr txt.setcc
      inc txt.setcc.row
      jsr txt.setcc
      dec txt.setcc.column
      jsr txt.setcc
    }}
  }

  sub draw() {
    ; Look up sub-byte position
    ubyte cur = enemyRef[EN_DIR]
       + (not enemyRef[EN_SUBPOS] & main.TOPMOST) * 4
       + (not enemyRef[EN_SUBPOS] & main.LEFTMOST) * 2

    ubyte tmp_x = enemyRef[EN_X]
    ubyte tmp_y = enemyRef[EN_Y]

    ubyte col = enemy_color[ enemyRef[EN_DURAB] ]

    uword shipRef = enemy_types[ enemyRef[EN_TYPE] ]

    ; Convert first byte to two PETSCII chars and draw
    ubyte ship_byte = shipRef[cur] as ubyte
    txt.setcc(tmp_x,   tmp_y, convert.get_high(ship_byte), col)
    txt.setcc(tmp_x+1, tmp_y, convert.get_low(ship_byte), col)
    
    ; Convert second byte and draw
    ship_byte = shipRef[cur+1] as ubyte
    txt.setcc(tmp_x,   tmp_y+1, convert.get_high(ship_byte), col)
    txt.setcc(tmp_x+1, tmp_y+1, convert.get_low(ship_byte), col)
  }

  ; Check for enemy detection. Currently we only allow a single
  ; hit (so we can return on a full hit).
  sub check_collision(uword bulletRef) -> ubyte {
    ubyte i = 0
    enemyRef = &enemyData
    while i < ENEMY_COUNT {
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
          if check_detailed_collision(dx, dy,
                bulletRef[gun_bullets.BD_LEFTMOST]) {
            ; More "Hitpoints?"
            if enemyRef[EN_DURAB] == 1 {
              enemyRef[EN_ACTIVE] = 0 ; Turn off
              sound.small_explosion()
              clear()
              enemies_left--
              ; Check if it's in attack
              if enemyRef[EN_PAT] > move_patterns.LAST_BASE
                  and enemyRef[EN_PAT] <= move_patterns.LAST_ATTACK
                attack.remove(enemyRef[EN_ATTACK])
  
              explosion.trigger(enemyRef[EN_X], enemyRef[EN_Y],
              enemyRef[EN_SUBPOS])

              ; Score based on type and pattern
              ubyte add_scr
              add_scr = enemy_score[ enemyRef[EN_TYPE] ]
              ; Bonus for flight
              if enemyRef[EN_PAT] > 1 ; Double score when not at base line
                add_scr <<= 1       

                main.add_score(add_scr)
                return 1
              } else {
                enemyRef[EN_DURAB]--
                sound.hit()
                return 1
              }
            }
          }
        }
      }
      enemyRef += FIELD_COUNT
      i++
    }

    return 0
  }

  sub check_detailed_collision( ubyte dx, ubyte dy,
                                ubyte leftmost ) -> ubyte {
    ubyte bullet_nib
    if leftmost ; Set nibble value for bullet
      bullet_nib = 5
    else
      bullet_nib = 10

    ; Get petscii value at screen pos
    ubyte tmp_x = enemyRef[EN_X] + dx
    ubyte tmp_y = enemyRef[EN_Y] + dy
           
    ; Get and map to Map from char to nibble ?
    ubyte nibble = convert.to_nibble( txt.getchr(tmp_x, tmp_y))

    if ( nibble & bullet_nib)
      return 1

    return 0
  }

  ; Random chance of dropping bomb per active enemy
  ;   Note that this seem to be spawn way to much even with 
  ;   a low percentage. rnd() fucnction may not distribute
  ;   well for this use.
  sub spawn_bomb_new() {
    ubyte enemy_num
    uword enemyRef = &enemyData
    while enemy_num < ENEMY_COUNT {
      if enemyRef[EN_ACTIVE] == 1 { 
        if enemyRef[EN_PAT] <= 1 { ; No bombs at deployment
          ; Check if we drop bomb
          ubyte chance = rnd() % 100
          if chance < 1 
            bombs.trigger(enemyRef[EN_X], enemyRef[EN_Y],
                          enemyRef[EN_SUBPOS])
        }
      }
      enemyRef += FIELD_COUNT
      enemy_num++
    }
  }

  ; Random chance of one enemy dropping a bomb
  ;   Bomb frequency increas when the count of enemies
  ;   drop so there are bombs even when there just a few
  ;   enemies left
  ;   This routine is a bit wonkey in that we randomly try
  ;   to pick an active enemy first (and just return at a
  ;   miss
  sub spawn_bomb() {
    ; Find random enemy
    ubyte enemy_num = rnd() % ENEMY_COUNT

    ; Check if it's active
    uword eRef = &enemyData + enemy_num * FIELD_COUNT
    if eRef[EN_ACTIVE] != 1
      return

    ; May allow bombs at deployments later
    if eRef[EN_PAT] > move_patterns.LAST_ATTACK ; No bombs in deploy
      return
  
    ; First check if we are spawning a bomb
    ubyte chance = rnd() % 100

    ; Stage base freqency
    ubyte stage_factor = 4 + main.cur_stage / 2

    ; Increase bomb frequency with less enemies
    ubyte enemy_count_factor = 1 + (ENEMY_COUNT - enemies_left) / 4
    
    if chance > stage_factor * enemy_count_factor
      return

    ; Advanced enemies may drop seekers instead of regular bombs
    if eRef[EN_TYPE] and chance < (eRef[EN_TYPE] << 1) {
      seekers.trigger(eRef[EN_X], eRef[EN_Y], eRef[EN_SUBPOS])
      return
    }
    
    bombs.trigger(eRef[EN_X], eRef[EN_Y], eRef[EN_SUBPOS])
  }

  ; Add random attack of enemies. These only happen from the "line".
  ; Frequency increase by level. May want to "up" bombing as well.
  sub trigger_attack() {
    if attack.full()
      return

    ; Find random enemy
    ubyte enemy_num = rnd() % ENEMY_COUNT

    ; Check if it's active
    uword eRef = &enemyData + enemy_num * FIELD_COUNT
    if eRef[EN_ACTIVE] != 1
      return

    ; No attack during deployment or existing attack
    if eRef[EN_PAT] > 1
      return

    ; First check if we are attacking
    ubyte chance = rnd() % 100

    ; Stage base freqency for attack
    ubyte stage_factor = 1 + main.cur_stage / 3

    ; Increase attack frequency with less enemies
    ubyte enemy_count_factor = 1 + (ENEMY_COUNT - enemies_left) / 4

    ; Are we attacking?
    if chance > stage_factor * enemy_count_factor
      return

    attack.begin(eRef)
  }

}

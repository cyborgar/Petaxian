;
; Small module (name space) for enemy attack
;
attack {
  ; Variables for enemy attacks (separate arrays this time)
  const ubyte AT_ACTIVE = 0
  const ubyte AT_SAVE_PAT = 1
  const ubyte AT_SAVE_MVCNT = 2
  const ubyte FIELD_COUNT = 3
  
  ; Max 3 attacking enemies for now
  const ubyte MAX_ATTACKS = 3

  ; Simple lookup table based on X position to determine which attack
  ; pattern to use
  ubyte[] attack_matrix = [
    0,0,0,0,0,0,0,2,2,2,
    2,2,3,2,3,2,3,2,3,3,
    3,3,3,1,1,1,1,1,1,1 ]
  
  const ubyte pattern_divisor = ( base.RBORDER - base.LBORDER ) / 2

  ; Data array
  ubyte[FIELD_COUNT * MAX_ATTACKS] attackData ; 

  ; To be obsoleted
  ubyte active
  ubyte save_pat
  ubyte save_move

  ; Make sure attack data is clear at game start
  sub clear_data() {
    uword attackRef = &attackData
    ubyte i = 0
    while i < MAX_ATTACKS {
      attackRef[AT_ACTIVE] = false
      attackRef += FIELD_COUNT
      i++
    }
  }

  sub set(uword eRef) {
    ; We need to save line pattern and current move counter so we can switch
    ; back later
    save_pat = eRef[enemy.EN_PAT]
    save_move = eRef[enemy.EN_MOVE_CNT]

    ; Determine attack type (using table)
    eRef[enemy.EN_PAT] = attack_matrix[eRef[enemy.EN_X]]
    		         + move_patterns.FIRST_ATTACK

    main.printDebug(10, eRef[enemy.EN_X])
    main.printDebug(11, attack_matrix[eRef[enemy.EN_X]])

    eRef[enemy.EN_MOVE_CNT] = 1 ;
    active = true
  }

  sub recover(uword eRef) {
    ; Return from attack
    eRef[enemy.EN_PAT] = save_pat
    eRef[enemy.EN_MOVE_CNT] = save_move
    active = false
  }

  sub full() -> ubyte {
    if active == true
      return 1
    return 0
  }
  
  sub clear() {
    active = false
  }
}

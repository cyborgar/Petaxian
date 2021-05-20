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

    ; Set attack pattern based on position left or right of middle
    ; Should have more than 1 (mirrored) pattern and also a different
    ; pattern in the middle
    if eRef[enemy.EN_X] < pattern_divisor
      eRef[enemy.EN_PAT] = 2
    else
      eRef[enemy.EN_PAT] = 3
    eRef[enemy.EN_MOVE_CNT] = 1 ;
    active = true
  }

  sub recover(uword eRef) {
    ; Return from attack
    eRef[enemy.EN_PAT] = save_pat
    uword patternRef = move_patterns.list[ eRef[enemy.EN_PAT] ]
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

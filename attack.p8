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

  ; Data array
  ubyte[FIELD_COUNT * MAX_ATTACKS] attackData ; 
  ubyte active_attacks

  ; Use global variable to reduce number of variables
  uword attackRef

  ; Simple lookup table based on X position to determine which attack
  ; pattern to use
  ; Note that though width of playfield 31 we will never see the last
  ; byte size enemies are 2 chars wide
  ubyte[] attack_matrix = [
    0,0,0,0,0,0,0,2,2,2,
    2,2,3,2,3,2,3,2,3,3,
    3,3,3,1,1,1,1,1,1,1 ]
  
  ; Make sure attack data is clear at game start
  sub set_data() {
    active_attacks = 0
    sys.memset(&attackData, MAX_ATTACKS * FIELD_COUNT, 0)
  }

  ; Check if we have used all attack slots.
  sub full() -> ubyte {
    if active_attacks == MAX_ATTACKS
      return 1
    return 0
  }

  ; Find free attack slot and start attack run
  sub begin(uword eRef) {
    ; Find first free attack
    attackRef = &attackData
    ubyte i = 0
    while i < MAX_ATTACKS {
      if attackRef[AT_ACTIVE] == false {
        ; We need to save line pattern and current move counter so we can
        ; switch back later
        attackRef[AT_ACTIVE] = 1
        attackRef[AT_SAVE_PAT] = eRef[enemy.EN_PAT]
        attackRef[AT_SAVE_MVCNT] = eRef[enemy.EN_MOVE_CNT]
        eRef[enemy.EN_ATTACK] = i

        ; Determine attack type (using table)
        eRef[enemy.EN_PAT] = attack_matrix[eRef[enemy.EN_X]]
            + move_patterns.FIRST_ATTACK

        eRef[enemy.EN_MOVE_CNT] = 1 ;
        active_attacks++
        return
      }
      attackRef += FIELD_COUNT
      i++
    }
  }

  ; Set back base move pattern after attack is done
  sub end(uword eRef) {
    ubyte attack_num = eRef[enemy.EN_ATTACK]
    
    attackRef = &attackData + FIELD_COUNT * attack_num
    eRef[enemy.EN_PAT] = attackRef[AT_SAVE_PAT]
    eRef[enemy.EN_MOVE_CNT] = attackRef[AT_SAVE_MVCNT]
    eRef[enemy.EN_ATTACK] = 0

    remove(attack_num)
  }

  ; Clear attack if enemy has been killed or is finished
  sub remove(ubyte attack_num) {
    attackRef = &attackData + FIELD_COUNT * attack_num 
    attackRef[AT_ACTIVE] = false
    active_attacks--
  }
}

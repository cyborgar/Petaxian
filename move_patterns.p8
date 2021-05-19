; Attempting to define movement pattern for the enemy, currently this
; is a
;    initial facing, position x, position,y, count of moves
; and then a list of moves as directions.
; Movement is using a simple list of direction which we just look 
; up using tables. The directions are start with 0 as right and then
; clockwise for each direction
;         5  6  7  
;         4     0
;         3  2  1
; Enemies first get startet in a deployment pattern and when this
; is done we switch to the "stable" (pre-attack) patterns. Currently
; all patterns have a "from the left" and "from the right" version.
; including the "stable" patterns
;
; I expect that attacks will be similar. Move from stable and try to end
; end up in the same position (that will require attacks to be 28 or 56 
; moves)
move_patterns {
  const ubyte TOP_FROM_LEFT_1 =  4
  const ubyte TOP_FROM_RIGHT_1 = 5
  const ubyte MID_FROM_LEFT_1 =  6
  const ubyte MID_FROM_RIGHT_1 = 7
  const ubyte TOP_FROM_LEFT_2 =  8
  const ubyte TOP_FROM_RIGHT_2 = 9
  const ubyte MID_FROM_LEFT_2 =  10
  const ubyte MID_FROM_RIGHT_2 = 11
  
  const ubyte MP_DIR = 0
  const ubyte MP_START_X = 1
  const ubyte MP_START_Y = 2
  const ubyte MP_MOVE_COUNT = 3

  ubyte[] stable_left = [
    enemy.DIR_DOWN, 0, 0, 36,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4 ]

  ; Stable right - movement pattern on top after right side deployment
  ubyte[] stable_right = [
    enemy.DIR_DOWN, 0, 0, 36,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0 ]

  ; Entry pattern 1 - high
  ;   May consider eventually convering into nibbles to save space
  ubyte[] deploy_left_1 = [
    enemy.DIR_RIGHT, base.LBORDER, base.DBORDER-5, 117,
    $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $0,
    $7, $0, $7, $7, $6, $7, $6, $6, $6, $5, $6, $5, $5, $4, $5, $4,   
    $4, $4, $3, $4, $3, $3, $2, $3, $2, $2, $2, $1, $2, $1, $1, $0,   
    $1, $0, $0, $7, $7, $0, $7, $7, $0, $7, $7, $0, $7, $7, $0, $7,   
    $7, $0, $7, $7, $0, $7, $7, $7, $7, $7, $7, $7, $6, $6, $4, $4,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,   
    $4, $4, $4, $4, $4 ]

  ; Entry pattern 1 reverse - high
  ubyte[] deploy_right_1 = [
    enemy.DIR_LEFT, base.RBORDER-1, base.DBORDER-5, 117,
    $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $4,
    $5, $4, $5, $5, $6, $5, $6, $6, $6, $7, $6, $7, $7, $0, $7, $0,   
    $0, $0, $1, $0, $1, $1, $2, $1, $2, $2, $2, $3, $2, $3, $3, $4,   
    $3, $4, $4, $5, $5, $4, $5, $5, $4, $5, $5, $4, $5, $5, $4, $5,   
    $5, $4, $5, $5, $4, $5, $5, $5, $5, $5, $5, $5, $6, $6, $0, $0, 
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,
    $0, $0, $0, $0, $0, $0 ]

  ; Entry pattern 2 - low
  ubyte[] deploy_left_2 = [
    enemy.DIR_RIGHT, base.LBORDER, base.DBORDER-9, 137,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $7, $0, $7, $6, $7, $6, $6, $5,   
    $6, $5, $4, $5, $4, $4, $3, $4, $3, $2, $3, $2, $2, $1, $2, $1,   
    $0, $1, $0, $0, $7, $0, $7, $6, $7, $6, $6, $6, $6, $6, $6, $6,   
    $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $4, $4,   
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,   
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,   
    $4, $4, $4, $4, $4, $4, $4, $4, $4 ]

  ; Entry pattern 2 reverse - low
  ubyte[] deploy_right_2 = [
    enemy.DIR_LEFT, base.RBORDER-1, base.DBORDER-9, 137,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,   
    $4, $4, $4, $4, $4, $4, $4, $4, $5, $4, $5, $6, $5, $6, $6, $7,   
    $6, $7, $0, $7, $0, $0, $1, $0, $1, $2, $1, $2, $2, $3, $2, $3,   
    $4, $3, $4, $4, $5, $4, $5, $6, $5, $6, $6, $6, $6, $6, $6, $6,   
    $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $0 ]

  ; Entry pattern 3 - high
  ubyte[] deploy_left_3 = [
    enemy.DIR_DOWN, base.LBORDER+6, base.UBORDER, 106,
    $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $3, $3, $4, $3, $2,
    $3, $2, $2, $1, $2, $1, $0, $1, $0, $0, $7, $0, $7, $6, $7, $7,
    $7, $7, $7, $7, $7, $7, $7, $7, $7, $0, $0, $0, $0, $0, $0, $0,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $7, $7, $6, $6, $6, $6, $5,
    $5, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4 ]

  ; Entry pattern 3 reverse - high
  ubyte[] deploy_right_3 = [
    enemy.DIR_DOWN, base.RBORDER-7, base.UBORDER, 106,
    $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $1, $1, $0, $1, $2,   
    $1, $2, $2, $3, $2, $3, $4, $3, $4, $4, $5, $4, $5, $6, $5, $5,   
    $5, $5, $5, $5, $5, $5, $5, $5, $5, $4, $4, $4, $4, $4, $4, $4,   
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $5, $5, $6, $6, $6, $6, $7,   
    $7, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0 ]

  ; Entry pattern 4 - low
  ubyte[] deploy_left_4 = [
    enemy.DIR_DOWN, base.LBORDER+4, base.UBORDER, 79,
    $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2,   
    $2, $2, $2, $2, $2, $2, $2, $1, $1, $0, $0, $0, $0, $0, $7, $7,   
    $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $6,   
    $6, $5, $5, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,   
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4 ]

  ; Entry pattern 4 reverse - low
  ubyte[] deploy_right_4 = [
    enemy.DIR_DOWN, base.RBORDER-5, base.UBORDER, 79,
    $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2, $2,
    $2, $2, $2, $2, $2, $2, $2, $3, $3, $4, $4, $4, $4, $4, $5, $5,
    $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $6,
    $6, $7, $7, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0 ]

  ;
  ; Attack patterns need to use a multiple of steps from the stable
  ; move (36 currently) to end up in the same position.
  ;

  ubyte[] attack_1 = [
    enemy.DIR_DOWN, 0, 0, 72,
    $3, $3, $3, $3, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1,
    $7, $7, $7, $7, $1, $1, $1, $1, $3, $3, $3, $3, $3, $3, $3, $3,
    $5, $5, $5, $5, $3, $3, $3, $3, $5, $5, $5, $5, $7, $7, $7, $7,
    $5, $5, $5, $5, $7, $7, $7, $7, $1, $1, $1, $1, $7, $7, $7, $7,
    $5, $5, $5, $5, $5, $5, $5, $5 ]

  ubyte[] attack_2 = [
    enemy.DIR_DOWN, 0, 0, 72,
    $1, $1, $1, $1, $3, $3, $3, $3, $3, $3, $3, $3, $3, $3, $3, $3,   
    $5, $5, $5, $5, $3, $3, $3, $3, $1, $1, $1, $1, $1, $1, $1, $1,   
    $7, $7, $7, $7, $1, $1, $1, $1, $7, $7, $7, $7, $5, $5, $5, $5,   
    $7, $7, $7, $7, $5, $5, $5, $5, $3, $3, $3, $3, $5, $5, $5, $5,   
    $7, $7, $7, $7, $7, $7, $7, $7 ]

;DL  $3, $3, $3, $3,
;DR  $1, $1, $1, $1,
;UL  $5, $5, $5, $5,
;UR  $7, $7, $7, $7,

  ; Put patterns in array of address refs?
  uword[] list = [ &stable_left, &stable_right,
  	       	   &attack_1, &attack_2,
                   &deploy_left_1, &deploy_right_1,
                   &deploy_left_2, &deploy_right_2,
		   &deploy_left_3, &deploy_right_3,
		   &deploy_left_4, &deploy_right_4 ]

}

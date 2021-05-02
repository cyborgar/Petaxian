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
  const ubyte TOP_FROM_LEFT_1 =  2
  const ubyte TOP_FROM_RIGHT_1 = 3
  const ubyte MID_FROM_LEFT_1 =  4
  const ubyte MID_FROM_RIGHT_1 = 5
  
  const ubyte MP_DIR = 1
  const ubyte MP_START_X = 2
  const ubyte MP_START_Y = 3
  const ubyte MP_MOVE_COUNT = 4

  ; Stable left - movement pattern on top after left side deployment
  ubyte[] stable_left = [
    0, enemy.DIR_DOWN, 0, 0, 36,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4 ]

  ; Stable right - movement pattern on top after right side deployment
  ubyte[] stable_right = [
    0, enemy.DIR_DOWN, 0, 0, 36,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0 ]

  ; Entry pattern 1
  ;   May consider eventually convering into nibbles to save space
  ubyte[] deploy_left_1 = [
    0, enemy.DIR_RIGHT, base.LBORDER, base.DBORDER-5, 117,
    $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $7, $0,
    $7, $0, $7, $7, $6, $7, $6, $6, $6, $5, $6, $5, $5, $4, $5, $4,   
    $4, $4, $3, $4, $3, $3, $2, $3, $2, $2, $2, $1, $2, $1, $1, $0,   
    $1, $0, $0, $7, $7, $0, $7, $7, $0, $7, $7, $0, $7, $7, $0, $7,   
    $7, $0, $7, $7, $0, $7, $7, $7, $7, $7, $7, $7, $6, $6, $4, $4,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,   
    $4, $4, $4, $4, $4 ]

  ; Same pattern (almost) from the right
  ubyte[] deploy_right_1 = [
    0, enemy.DIR_LEFT, base.RBORDER-1, base.DBORDER-5, 117,
    $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $5, $4,
    $5, $4, $5, $5, $6, $5, $6, $6, $6, $7, $6, $7, $7, $0, $7, $0,   
    $0, $0, $1, $0, $1, $1, $2, $1, $2, $2, $2, $3, $2, $3, $3, $4,   
    $3, $4, $4, $5, $5, $4, $5, $5, $4, $5, $5, $4, $5, $5, $4, $5,   
    $5, $4, $5, $5, $4, $5, $5, $5, $5, $5, $5, $5, $6, $6, $0, $0, 
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,
    $0, $0, $0, $0, $0, $0 ]

  ubyte[] deploy_left_2 = [
    0, enemy.DIR_RIGHT, base.LBORDER, base.DBORDER-9, 137,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $7, $0, $7, $6, $7, $6, $6, $5,   
    $6, $5, $4, $5, $4, $4, $3, $4, $3, $2, $3, $2, $2, $1, $2, $1,   
    $0, $1, $0, $0, $7, $0, $7, $6, $7, $6, $6, $6, $6, $6, $6, $6,   
    $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $4, $4,   
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,   
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,   
    $4, $4, $4, $4, $4, $4, $4, $4, $4 ]

  ubyte[] deploy_right_2 = [
    0, enemy.DIR_LEFT, base.RBORDER-1, base.DBORDER-9, 137,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,   
    $4, $4, $4, $4, $4, $4, $4, $4, $5, $4, $5, $6, $5, $6, $6, $7,   
    $6, $7, $0, $7, $0, $0, $1, $0, $1, $2, $1, $2, $2, $3, $2, $3,   
    $4, $3, $4, $4, $5, $4, $5, $6, $5, $6, $6, $6, $6, $6, $6, $6,   
    $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $6, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0, $0,   
    $0, $0, $0, $0, $0, $0, $0, $0, $0 ]

  ; Put patterns in array of address refs?
  uword[] list = [ &stable_left, &stable_right,
                   &deploy_left_1, &deploy_right_1,
                   &deploy_left_2, &deploy_right_2 ]

}

;
; Set up
;
stage {
  ; Each stage consists of 2 "waves" of deployment 
  ; each sub sub patter conists of 
  const ubyte STG_LINE_ACTIVE = 0 ; Is this line in use 
  const ubyte STG_PAT =  1        ; Deployment patter
  const ubyte STG_DEPL_DELAY = 2  ; Delay from sub stage start before depolyment starts
  const ubyte STG_WAVE_DELAY = 3  ; Delay from stage start
  const ubyte STG_ENEMY_TYPE = 4 
  const ubyte STG_FIELDS = 5

  ubyte[] stage1 = [
    true, move_patterns.TOP_FROM_LEFT_1, 0, 0,
    true, move_patterns.MID_FROM_RIGHT_1, 38, 70 ]

  ubyte[] stage2 = [
    true, move_patterns.TOP_FROM_RIGHT_1, 0, 0,
    true, move_patterns.MID_FROM_LEFT_1, 38, 70 ]

  uword[] list = [ &stage1, &stage2 ]
}

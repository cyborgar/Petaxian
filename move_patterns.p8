; Attempting to define movement pattern for the enemy, currently this
; is a
;    initial facing, position x, position,y, count of moves
; and then a list of moves as directions.
; Note that movement is defined using 4 bit (one for each direction)
; as a "clever" way to use bit checking to find deltas (also for enemy
; "facing" handling. This may turn out to not be so clever and removed
; later, the values map like this :
;        12  8  9  
;         4  0  1
;         6  2  3
; (e.g 8 is up, 1 is right and 9 is then both). 0 is no movement
; ----- Some old description that may be re-introduced later -----
; Note that the last two movement positions are repeated (When we we are
; done with the last stage we loop the last two over and over

move_patterns {
  const ubyte TOP_FROM_LEFT_1 = 1
  const ubyte TOP_FROM_RIGHT_1 = 2

  const ubyte MP_DIR = 1
  const ubyte MP_START_X = 2
  const ubyte MP_START_Y = 3
  const ubyte MP_MOVE_COUNT = 4

  ; Stable pattern - start relative
  ubyte[] mv_stable = [
    0, enemy.DIR_DOWN, 0, 0, 28,
    $1, $1, $1, $1, $1, $1, $1, $4, $4, $4, $4, $4, $4, $4,
    $4, $4, $4, $4, $4, $4, $4, $1, $1, $1, $1, $1, $1, $1 ]

  ; Entry pattern 1
  ;   May consider eventually convering into nibbles to save space 
  ubyte[] mv_deploy_1_left = [
    0, enemy.DIR_RIGHT, main.LBORDER+1, main.DBORDER-3, 109,
    $0, $9, $9, $9, $9, $9, $9, $9, $9, $9, $9, $9, $9, $9, $9, $1,
    $9, $1, $9, $9, $8, $9, $8, $8, $8, $c, $8, $c, $c, $4, $c, $4,
    $4, $4, $6, $4, $6, $6, $2, $6, $2, $2, $2, $3, $2, $3, $3, $1,
    $3, $1, $1, $9, $9, $1, $9, $9, $1, $9, $9, $1, $9, $9, $1, $9,
    $9, $1, $9, $9, $1, $9, $9, $9, $9, $9, $9, $9, $9, $9, $8, $8,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4,
    $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4, $4 ]

  ; Same pattern (almost) from the right
  ubyte[] mv_deploy_1_right = [
    0, enemy.DIR_LEFT, main.RBORDER-2, main.DBORDER-3, 107,
    $0, $c, $c, $c, $c, $c, $c, $c, $c, $c, $c, $c, $c, $c, $c, $4,
    $c, $4, $c, $c, $8, $c, $8, $8, $8, $9, $8, $9, $9, $1, $9, $1,
    $1, $1, $3, $1, $3, $3, $2, $3, $2, $2, $2, $6, $2, $6, $6, $4,
    $6, $4, $4, $c, $c, $4, $c, $c, $4, $c, $c, $4, $c, $c, $4, $c,
    $c, $c, $c, $c, $c, $c, $c, $c, $c, $c, $c, $c, $8, $8, $1, $1,
    $1, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1,
    $1, $1, $1, $1, $1, $1, $1, $1, $1, $1, $1 ]

  ; Put patterns in array of address refs?
  uword[] list = [ &mv_stable, &mv_deploy_1_left, &mv_deploy_1_right ]

}

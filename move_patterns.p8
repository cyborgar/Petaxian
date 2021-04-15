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

  const ubyte MP_DIR = 1
  const ubyte MP_START_X = 2
  const ubyte MP_START_Y = 3
  const ubyte MP_MOVE_COUNT = 4

  ; Stable pattern - start relative
  ubyte[] mv_stable = [
    0, enemy.DIR_DOWN, 0, 0, 29,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ]

  ; Entry pattern 1 -
  ;   NB! Will eventually convert into nibbles to save space 
  ubyte[] mv_pattern_deploy_1_left = [
    0, enemy.DIR_RIGHT, main.LBORDER+1, main.DBORDER-3, 106,
    0, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, 9, ; Init (1) + pre loop (13 diag)
    9, 1, 9, 1, 9, 9, 8, 9, 8,             ; Circle start
    8, 8, 12, 8, 12, 12, 4, 12, 4,
    4, 4, 6, 4, 6, 6, 2, 6, 2,
    2, 2, 3, 2, 3, 3, 1, 3, 1,             ; Circle complete (36)
    1, 9, 9, 9, 9, 9, 9, 9, 9,             ; Finish cross upward
    9, 9, 9, 9, 9, 9, 9,
    9, 9, 9, 9, 9, 9, 8, 8,                ; (24 inkl 2 up)
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, ; Move to left  (31)
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ]

  ubyte[] mv_test = [
    0, enemy.DIR_RIGHT, main.LBORDER+1, main.DBORDER-4, 56,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4,
    1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4 ]

  ; Put patterns in array of address refs?
  uword[] list = [ &mv_stable, &mv_pattern_deploy_1_left, &mv_test ]

}

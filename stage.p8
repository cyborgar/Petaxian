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
  const ubyte FIELD_COUNT = 5

  const ubyte MAX_STAGE = 8

  ubyte[] stage1 = [
    true, move_patterns.TOP_FROM_LEFT_1, 0, 0, enemy.RAIDER1,
    true, move_patterns.MID_FROM_RIGHT_1, 38, 70, enemy.RAIDER1 ]

  ubyte[] stage2 = [
    true, move_patterns.TOP_FROM_RIGHT_1, 0, 0, enemy.RAIDER1,
    true, move_patterns.MID_FROM_LEFT_1, 38, 70, enemy.RAIDER1 ]

  ubyte[] stage3 = [
    true, move_patterns.TOP_FROM_LEFT_1, 0, 0, enemy.RAIDER2,
    true, move_patterns.MID_FROM_RIGHT_1, 38, 70, enemy.RAIDER1 ]

  ubyte[] stage4 = [
    true, move_patterns.TOP_FROM_RIGHT_1, 0, 0, enemy.RAIDER2,
    true, move_patterns.MID_FROM_LEFT_1, 38, 70, enemy.RAIDER1 ]

  ubyte[] stage5 = [
    true, move_patterns.TOP_FROM_LEFT_1, 0, 0, enemy.RAIDER2,
    true, move_patterns.MID_FROM_RIGHT_1, 38, 70, enemy.RAIDER2 ]

  ubyte[] stage6 = [
    true, move_patterns.TOP_FROM_RIGHT_1, 0, 0, enemy.RAIDER2,
    true, move_patterns.MID_FROM_LEFT_1, 38, 70, enemy.RAIDER2 ]

  ubyte[] stage7 = [
    true, move_patterns.TOP_FROM_LEFT_1, 0, 0, enemy.RAIDER3,
    true, move_patterns.MID_FROM_RIGHT_1, 38, 70, enemy.RAIDER2 ]

  ubyte[] stage8 = [
    true, move_patterns.TOP_FROM_RIGHT_1, 0, 0, enemy.RAIDER3,
    true, move_patterns.MID_FROM_LEFT_1, 38, 70, enemy.RAIDER2 ]

  uword[] list = [ &stage1, &stage2, &stage3, &stage4,
                   &stage5, &stage6, &stage7, &stage8 ]

}

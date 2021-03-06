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
  const ubyte STG_ENEMY_TYPE = 4  ; from 4 - 11 are the enemy types on the line 
  const ubyte FIELD_COUNT = 12

  const ubyte MAX_STAGE = 20

  ubyte[] bonus_times = [ 20, 20, 23, 23, 26, 26, 29, 29, 32, 32, 35, 35,
                          38, 38, 41, 41, 44, 44, 47, 47 ]

  ubyte[] stage1 = [
    true, move_patterns.TOP_FROM_LEFT_1, 0, 0,
    enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1,
    enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1,
    true, move_patterns.MID_FROM_RIGHT_1, 38, 70,
    enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1,
    enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1 ]

  ubyte[] stage2 = [
    true, move_patterns.TOP_FROM_RIGHT_1, 0, 0,
    enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1,
    enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1,
    true, move_patterns.MID_FROM_LEFT_1, 38, 70,
    enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1,
    enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1, enemy.RAIDER1 ]

  ubyte[] stage3 = [
    true, move_patterns.TOP_FROM_LEFT_2, 0, 0,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER1, enemy.RAIDER2,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER1, enemy.RAIDER2,
    true, move_patterns.MID_FROM_RIGHT_1, 38, 70,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER1, enemy.RAIDER2,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER1, enemy.RAIDER2 ]

  ubyte[] stage4 = [
    true, move_patterns.TOP_FROM_RIGHT_2, 0, 0,
    enemy.RAIDER2, enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER1,
    enemy.RAIDER2, enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER1,
    true, move_patterns.MID_FROM_LEFT_1, 38, 70,
    enemy.RAIDER2, enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER1,
    enemy.RAIDER2, enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER1 ]

  ubyte[] stage5 = [
    true, move_patterns.TOP_FROM_LEFT_1, 0, 0,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER5,
    enemy.RAIDER5, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER1,
    true, move_patterns.MID_FROM_RIGHT_2, 38, 70,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER1 ]

  ubyte[] stage6 = [
    true, move_patterns.TOP_FROM_RIGHT_1, 0, 0,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER5,
    enemy.RAIDER5, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER1,
    true, move_patterns.MID_FROM_LEFT_2, 38, 70,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER1 ]

  ubyte[] stage7 = [
    true, move_patterns.TOP_FROM_LEFT_2, 0, 0,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER5,
    enemy.RAIDER5, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2,
    true, move_patterns.MID_FROM_RIGHT_2, 38, 70,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER5,
    enemy.RAIDER5, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2 ]

  ubyte[] stage8 = [
    true, move_patterns.TOP_FROM_RIGHT_2, 0, 0,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER5,
    enemy.RAIDER5, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2,
    true, move_patterns.MID_FROM_LEFT_2, 38, 70,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER5,
    enemy.RAIDER5, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER2 ]

  ubyte[] stage9 = [
    true, move_patterns.TOP_FROM_LEFT_1, 0, 0,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER3,
    enemy.RAIDER3, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER1,
    true, move_patterns.MID_FROM_RIGHT_2, 38, 70,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER3,
    enemy.RAIDER3, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER1 ]

  ubyte[] stage10 = [
    true, move_patterns.TOP_FROM_RIGHT_1, 0, 0,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER3,
    enemy.RAIDER3, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER1,
    true, move_patterns.MID_FROM_LEFT_2, 38, 70,
    enemy.RAIDER1, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER3,
    enemy.RAIDER3, enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER1 ]

  ubyte[] stage11 = [
    true, move_patterns.TOP_FROM_LEFT_2, 0, 0,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER3, enemy.RAIDER3,
    enemy.RAIDER3, enemy.RAIDER3, enemy.RAIDER2, enemy.RAIDER2,
    true, move_patterns.MID_FROM_RIGHT_1, 38, 70,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER3, enemy.RAIDER3,
    enemy.RAIDER3, enemy.RAIDER3, enemy.RAIDER2, enemy.RAIDER2 ]

  ubyte[] stage12 = [
    true, move_patterns.TOP_FROM_RIGHT_2, 0, 0,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER3, enemy.RAIDER3,
    enemy.RAIDER3, enemy.RAIDER3, enemy.RAIDER2, enemy.RAIDER2,
    true, move_patterns.MID_FROM_LEFT_1, 38, 70,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER3, enemy.RAIDER3,
    enemy.RAIDER3, enemy.RAIDER3, enemy.RAIDER2, enemy.RAIDER2 ]

  ubyte[] stage13 = [
    true, move_patterns.TOP_FROM_LEFT_1, 0, 0,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER5, enemy.RAIDER5,
    enemy.RAIDER5, enemy.RAIDER5, enemy.RAIDER2, enemy.RAIDER2,
    true, move_patterns.MID_FROM_RIGHT_1, 38, 70,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER3, enemy.RAIDER3,
    enemy.RAIDER3, enemy.RAIDER3, enemy.RAIDER2, enemy.RAIDER2 ]

  ubyte[] stage14 = [
    true, move_patterns.TOP_FROM_RIGHT_1, 0, 0,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER5, enemy.RAIDER5,
    enemy.RAIDER5, enemy.RAIDER5, enemy.RAIDER2, enemy.RAIDER2,
    true, move_patterns.MID_FROM_LEFT_1, 38, 70,
    enemy.RAIDER2, enemy.RAIDER2, enemy.RAIDER3, enemy.RAIDER3,
    enemy.RAIDER3, enemy.RAIDER3, enemy.RAIDER2, enemy.RAIDER2 ]

  ubyte[] stage15 = [
    true, move_patterns.TOP_FROM_LEFT_2, 0, 0,
    enemy.RAIDER2, enemy.RAIDER4, enemy.RAIDER5, enemy.RAIDER5,
    enemy.RAIDER5, enemy.RAIDER5, enemy.RAIDER4, enemy.RAIDER2,
    true, move_patterns.MID_FROM_RIGHT_1, 38, 70,
    enemy.RAIDER2, enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER6,
    enemy.RAIDER6, enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER2 ]

  ubyte[] stage16 = [
    true, move_patterns.TOP_FROM_RIGHT_2, 0, 0,
    enemy.RAIDER2, enemy.RAIDER4, enemy.RAIDER5, enemy.RAIDER5,
    enemy.RAIDER5, enemy.RAIDER5, enemy.RAIDER4, enemy.RAIDER2,
    true, move_patterns.MID_FROM_LEFT_1, 38, 70,
    enemy.RAIDER2, enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER6,
    enemy.RAIDER6, enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER2 ]

  ubyte[] stage17 = [
    true, move_patterns.TOP_FROM_LEFT_1, 0, 0,
    enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER6, enemy.RAIDER6,
    enemy.RAIDER6, enemy.RAIDER6, enemy.RAIDER4, enemy.RAIDER4,
    true, move_patterns.MID_FROM_RIGHT_2, 38, 70,
    enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER4,
    enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER4 ]

  ubyte[] stage18 = [
    true, move_patterns.TOP_FROM_RIGHT_1, 0, 0,
    enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER6, enemy.RAIDER6,
    enemy.RAIDER6, enemy.RAIDER6, enemy.RAIDER4, enemy.RAIDER4,
    true, move_patterns.MID_FROM_LEFT_2, 38, 70,
    enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER4,
    enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER4 ]

  ubyte[] stage19 = [
    true, move_patterns.TOP_FROM_LEFT_2, 0, 0,
    enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER6, enemy.RAIDER6,
    enemy.RAIDER6, enemy.RAIDER6, enemy.RAIDER4, enemy.RAIDER4,
    true, move_patterns.MID_FROM_RIGHT_2, 38, 70,
    enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER6, enemy.RAIDER6,
    enemy.RAIDER6, enemy.RAIDER6, enemy.RAIDER4, enemy.RAIDER4 ]

  ubyte[] stage20 = [
    true, move_patterns.TOP_FROM_RIGHT_2, 0, 0,
    enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER6, enemy.RAIDER6,
    enemy.RAIDER6, enemy.RAIDER6, enemy.RAIDER4, enemy.RAIDER4,
    true, move_patterns.MID_FROM_LEFT_2, 38, 70,
    enemy.RAIDER4, enemy.RAIDER4, enemy.RAIDER6, enemy.RAIDER6,
    enemy.RAIDER6, enemy.RAIDER6, enemy.RAIDER4, enemy.RAIDER4 ]

  uword[] list = [ &stage1, &stage2, &stage3, &stage4,
                   &stage5, &stage6, &stage7, &stage8,
                   &stage9, &stage10, &stage11, &stage12,
                   &stage13, &stage14, &stage15, &stage16,
                   &stage17, &stage18, &stage19, &stage20 ]

}

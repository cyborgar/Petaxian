; Game over graphics
;  Split in two to fit in array limits

game_over {

  ubyte[] game = [
    $20,$E9,$A0,$A0,$DF,$20,$20,$20,$E9,$A0,$A0,$DF,$20,$20,$DF,$20,$20,$20,$20,$E9,$20,$E9,$A0,$A0,$A0,$A0,
    $E9,$A0,$A0,$A0,$A0,$DF,$20,$E9,$A0,$A0,$A0,$A0,$DF,$20,$A0,$DF,$20,$20,$E9,$A0,$20,$A0,$A0,$A0,$A0,$A0,
    $A0,$A0,$20,$20,$20,$20,$20,$A0,$A0,$20,$20,$A0,$A0,$20,$A0,$A0,$DF,$E9,$A0,$A0,$20,$A0,$A0,$20,$20,$20,
    $FF,$FE,$20,$A0,$A0,$A0,$20,$A0,$FB,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$20,$FC,$6C,$A0,$A0,$20,
    $A0,$A0,$20,$A0,$A0,$A0,$20,$A0,$6C,$A0,$FC,$A0,$FC,$20,$A0,$A0,$5F,$69,$A0,$EC,$20,$A0,$A0,$A0,$A0,$20,
    $EC,$A0,$20,$20,$A0,$A0,$20,$A0,$A0,$20,$20,$A0,$A0,$20,$A0,$A0,$20,$20,$A0,$FF,$20,$A0,$FE,$20,$20,$20,
    $5F,$A0,$A0,$A0,$A0,$69,$20,$A0,$A0,$20,$20,$A0,$A0,$20,$A0,$A0,$20,$20,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,
    $20,$20,$62,$62,$20,$20,$20,$62,$62,$20,$20,$62,$62,$20,$62,$62,$20,$20,$62,$62,$20,$6C,$62,$62,$62,$62 ]

  ubyte[] over = [
    $20, $E9,$A0,$A0,$DF,$20,$20,$A0,$A0,$20,$20,$A0,$A0,$20,$E9,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$DF,
    $E9,$A0,$A0,$A0,$A0,$DF,$20,$A0,$A0,$20,$20,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$E1,$A0,$A0,$A0,$A0,
    $A0,$A0,$20,$20,$FC,$7F,$20,$EC,$FB,$20,$20,$A0,$A0,$20,$A0,$A0,$20,$20,$20,$20,$A0,$A0,$20,$20,$A0,$A0,
    $A0,$A0,$20,$20,$A0,$A0,$20,$EC,$6C,$20,$20,$A0,$FE,$20,$A0,$FE,$A0,$A0,$20,$20,$A0,$A0,$A0,$A0,$A0,$69,
    $A0,$A0,$20,$20,$A0,$FB,$20,$A0,$A0,$20,$20,$A0,$A0,$20,$A0,$A0,$A0,$A0,$20,$20,$7E,$7B,$FB,$A0,$A0,$DF,
    $A0,$A0,$20,$20,$A0,$A0,$20,$5F,$A0,$DF,$E9,$A0,$69,$20,$A0,$A0,$20,$20,$20,$20,$A0,$A0,$20,$5F,$A0,$A0,
    $5F,$A0,$A0,$A0,$A0,$69,$20,$20,$5F,$A0,$A0,$69,$20,$20,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0,$20,$20,$A0,$A0,
    $20,$20,$62,$62,$20,$20,$20,$20,$20,$6C,$7B,$20,$20,$20,$6C,$62,$62,$62,$62,$20,$62,$62,$20,$20,$62,$62
  ]

  ubyte[] game_colors = [
    $01,$0A,$0A,$02,$02,$0E,$0E,$0E,$0A,$0A,$02,$02,$02,$0E,$01,$0A,$0E,$0E,$02,$09,$0E,$01,$0A,$0A,$02,$02,
    $01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$02,$02,$09,$09,$01,$0A,$0E,$0E,$02,$09,$0E,$01,$0A,$0A,$02,$02,
    $01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$0E,$02,$09,$0E,$01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$02,$02,
    $01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$02,$02,
    $01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$02,$02,
    $01,$0A,$0A,$02,$02,$09,$09,$01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$0E,$02,$09,$0E,$01,$0A,$0A,$02,$02,
    $01,$0A,$0A,$02,$02,$09,$09,$01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$0E,$02,$09,$0E,$01,$0A,$0A,$02,$02,
    $01,$0A,$0A,$02,$02,$09,$09,$01,$0A,$0A,$02,$02,$09,$0E,$01,$0A,$0A,$0E,$02,$09,$0E,$01,$0A,$0A,$02,$02 ]

  ubyte[] over_colors = [
    $01,$03,$03,$0E,$0E,$06,$0E,$01,$03,$0E,$0E,$0E,$06,$0E,$01,$03,$03,$0E,$0E,$0E,$01,$03,$03,$0E,$0E,$06,
    $01,$03,$03,$0E,$0E,$06,$0E,$01,$03,$0E,$0E,$0E,$06,$0E,$01,$03,$03,$0E,$0E,$0E,$01,$03,$03,$0E,$0E,$06,
    $01,$03,$03,$0E,$0E,$06,$0E,$01,$03,$0E,$0E,$0E,$06,$0E,$01,$03,$03,$0E,$0E,$0E,$01,$03,$03,$0E,$0E,$06,
    $01,$03,$03,$0E,$0E,$06,$0E,$01,$03,$03,$0E,$0E,$06,$0E,$01,$03,$03,$0E,$0E,$0E,$01,$03,$03,$0E,$0E,$06,
    $01,$03,$03,$0E,$0E,$06,$0E,$01,$03,$03,$0E,$0E,$06,$0E,$01,$03,$03,$0E,$0E,$0E,$01,$03,$03,$0E,$0E,$06,
    $01,$03,$03,$0E,$0E,$06,$0E,$01,$03,$03,$0E,$0E,$06,$0F,$01,$03,$03,$0E,$0E,$0E,$01,$03,$03,$0E,$0E,$06,
    $01,$03,$03,$0E,$0E,$06,$0E,$01,$03,$03,$0E,$0E,$06,$0F,$01,$03,$03,$0E,$0E,$0E,$01,$03,$03,$0E,$0E,$06,
    $01,$03,$03,$0E,$0E,$06,$0E,$01,$03,$03,$0E,$0E,$06,$0F,$01,$03,$03,$0E,$0E,$0E,$01,$03,$03,$0E,$0E,$06 ]

 ubyte[] victory = [
    $20,$20,$20,$20,$20,$E9,$20,$20,$E9,$20,$E9,$20,$E9,$A0,$DF,$20,$E9,$A0,$A0,$A0,$69,$E9,$A0,$A0,$DF,$20,$E9,$A0,$A0,$DF,$20,$E9,$20,$20,$E9,$20,$20,$20,$20,$20,
    $43,$43,$43,$43,$72,$C9,$20,$70,$D5,$70,$A0,$70,$F0,$43,$5F,$20,$43,$6E,$D5,$20,$70,$A0,$43,$49,$F0,$70,$C9,$43,$49,$A0,$70,$C3,$20,$70,$A0,$43,$43,$43,$43,$43,
    $20,$20,$20,$20,$42,$CA,$20,$5D,$F1,$5D,$C9,$42,$EB,$20,$4A,$20,$20,$5D,$F3,$20,$5D,$F2,$20,$5D,$F1,$42,$CA,$F1,$FD,$69,$4A,$5F,$ED,$F3,$69,$20,$20,$20,$20,$20,
    $20,$20,$20,$20,$4A,$5F,$DF,$E9,$69,$5D,$F1,$42,$CB,$20,$20,$E9,$20,$5D,$FD,$20,$5D,$CA,$20,$E9,$69,$42,$A0,$20,$5F,$DF,$20,$4A,$6E,$CA,$20,$20,$20,$20,$20,$20,
    $20,$20,$20,$20,$20,$4A,$5F,$69,$20,$5D,$69,$4A,$5F,$A0,$A0,$69,$20,$5D,$69,$20,$4A,$5F,$A0,$69,$20,$42,$69,$20,$4A,$5F,$20,$20,$42,$69,$20,$20,$20,$20,$20,$20,
    $20,$20,$20,$20,$20,$20,$4A,$20,$20,$4A,$20,$20,$4A,$43,$43,$20,$20,$4A,$20,$20,$20,$4A,$20,$20,$20,$4A,$20,$20,$20,$4A,$20,$20,$4A,$20,$20,$20,$20,$20,$20,$20 ]

  ubyte[] defeat = [
    $20,$20,$20,$20,$20,$20,$E9,$A0,$DF,$20,$20,$E9,$A0,$69,$20,$20,$E9,$A0,$A0,$69,$E9,$A0,$69,$20,$20,$E9,$A0,$A0,$DF,$E9,$A0,$A0,$A0,$69,$20,$20,$20,$20,$20,$20,
    $43,$43,$43,$43,$43,$72,$EE,$43,$5F,$DF,$70,$C9,$43,$49,$20,$70,$A0,$43,$49,$70,$C9,$43,$49,$20,$70,$EE,$43,$49,$A0,$43,$6E,$C9,$43,$43,$43,$43,$43,$43,$43,$43,
    $20,$20,$20,$20,$20,$5D,$EB,$20,$5D,$C9,$5D,$EB,$EE,$69,$20,$5D,$F2,$CB,$69,$5D,$F1,$EE,$69,$20,$5D,$EB,$CB,$69,$A0,$20,$5D,$F3,$20,$20,$20,$20,$20,$20,$20,$20,
    $71,$71,$71,$71,$71,$5D,$CA,$20,$5D,$F1,$5D,$FD,$43,$20,$E9,$5D,$CB,$43,$20,$5D,$A0,$43,$20,$E9,$5D,$CB,$20,$5D,$A0,$20,$5D,$ED,$20,$20,$20,$20,$20,$20,$20,$20,
    $20,$20,$20,$20,$20,$4A,$5F,$A0,$A0,$69,$4A,$5F,$A0,$A0,$69,$5D,$69,$20,$20,$4A,$5F,$A0,$A0,$69,$42,$69,$20,$5D,$69,$20,$5D,$69,$20,$20,$20,$20,$20,$20,$20,$20,
    $20,$20,$20,$20,$20,$20,$4A,$43,$43,$20,$20,$4A,$43,$43,$20,$4A,$20,$20,$20,$20,$4A,$43,$43,$20,$4A,$20,$20,$4A,$20,$20,$4A,$20,$20,$20,$20,$20,$20,$20,$20,$20 ]

 ubyte[] victory_col = [
    $00,$00,$00,$00,$08,$07,$00,$00,$07,$00,$07,$00,$07,$07,$07,$08,$07,$07,$07,$07,$07,$07,$07,$07,$07,$00,$07,$07,$07,$07,$00,$07,$00,$00,$07,$00,$00,$00,$00,$00,
    $0A,$0A,$0A,$0A,$0A,$07,$00,$0A,$07,$0A,$07,$0A,$07,$0A,$07,$08,$0A,$0A,$07,$00,$0A,$07,$0A,$0A,$07,$0A,$07,$0A,$0A,$07,$0A,$07,$00,$0A,$07,$0A,$0A,$0A,$0A,$0A,
    $00,$00,$00,$00,$02,$07,$00,$02,$07,$02,$07,$02,$07,$00,$02,$00,$00,$02,$07,$00,$02,$07,$00,$02,$07,$02,$07,$07,$07,$07,$02,$07,$07,$07,$07,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$02,$08,$08,$08,$08,$02,$08,$02,$08,$00,$00,$08,$08,$02,$08,$00,$02,$08,$00,$08,$08,$02,$08,$08,$08,$08,$00,$02,$02,$08,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00,$09,$08,$08,$00,$09,$08,$09,$08,$08,$08,$08,$08,$09,$08,$00,$09,$08,$08,$08,$08,$09,$08,$00,$09,$08,$00,$00,$09,$08,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00,$00,$09,$00,$00,$09,$00,$00,$09,$09,$09,$02,$00,$09,$00,$00,$00,$09,$00,$00,$00,$09,$00,$00,$00,$09,$00,$00,$09,$00,$00,$00,$00,$00,$00,$00 ]

 ubyte[] defeat_col = [
    $00,$00,$00,$00,$00,$00,$0E,$0E,$0E,$00,$00,$0E,$0E,$0E,$00,$00,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$00,$00,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$0E,$00,$00,$00,$00,$00,$00,
    $0F,$0F,$0F,$0F,$0F,$0F,$0E,$0F,$0E,$0E,$0F,$0E,$0F,$0F,$07,$0F,$0E,$0F,$0F,$0F,$0E,$0F,$0F,$07,$0F,$0E,$0F,$0F,$0E,$0F,$0F,$0E,$0F,$0F,$0F,$0F,$0F,$0F,$0F,$0F,
    $00,$00,$00,$00,$00,$0C,$0E,$00,$0C,$0E,$0C,$0E,$0E,$0E,$00,$0C,$0E,$0E,$0E,$0C,$0E,$0E,$0E,$00,$0C,$0E,$0E,$0E,$0E,$00,$0C,$0E,$00,$00,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00,$0C,$06,$00,$0C,$06,$0C,$06,$0C,$00,$06,$0C,$06,$0C,$00,$0C,$06,$0C,$00,$06,$0C,$06,$00,$0C,$06,$08,$0C,$06,$00,$00,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00,$0B,$06,$06,$06,$06,$0B,$06,$06,$06,$06,$0B,$06,$00,$00,$0B,$06,$06,$06,$06,$0B,$06,$07,$0B,$06,$08,$0B,$06,$00,$00,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00,$00,$0B,$0B,$0B,$00,$00,$0B,$0B,$0B,$00,$0B,$00,$00,$00,$00,$0B,$0B,$0B,$00,$0B,$0B,$00,$0B,$00,$00,$0B,$00,$00,$00,$00,$00,$00,$00,$00,$00 ]


  const ubyte WDT = 40
  const ubyte HGT = 6

  sub draw_victory() {
    ubyte i
    for i in 0 to (WDT*HGT - 1) {
      txt.setcc( base.LBORDER + (i % WDT), base.UBORDER + 1 + (i/WDT),
                 victory[i], victory_col[i] )
    }

    main.write(1, 3, 10, "       congratulations!")
    main.write(3, 3, 12, "you have defeated the petaxian")
    main.write(3, 3, 13, "invasion force.")

    score(1)
  }

  sub draw_defeat() {
    ubyte i
    for i in 0 to (WDT*HGT - 1) {
      txt.setcc( base.LBORDER + (i % WDT), base.UBORDER + 1 + (i/WDT),
                 defeat[i], defeat_col[i] )
    }

    main.write(3, 3, 10, "the petaxians have defeated earths")
    main.write(3, 3, 11, "defence force and the invasion has")
    main.write(3, 3, 12, "left the planet in ruins.")

    score(0)
  }

  sub score(ubyte win) {
    sys.wait(100)

    main.write(14, 5, 16, "enemy kill points  :")
    main.printNumber(27, 16, main.score - main.bonus_score, 5)
    sound.score_sound_and_delay()
    
    main.write(14, 5, 17, "stage bonus points :")
    main.printNumber(27, 17, main.bonus_score, 5)
    sound.score_sound_and_delay()

    if win {
      uword lives_score = main.player_lives * 500
      str lives_left = "N"
      lives_left[0] = $30 + main.player_lives
      main.write(1, 5, 18, lives_left)
      main.write(14, 7, 18, "lives left bonus :")
      main.printNumber(27, 18, lives_score, 5)
      main.score += lives_score
      sound.score_sound_and_delay()
    }
    
    main.write(14, 5, 19, "total              :")
    main.printNumber(27, 19, main.score, 5)
    sound.score_sound_and_delay()

    if main.score > main.hiscore {
      main.write(1, 5, 21, "congratulation! new higscore")
      main.hiscore = main.score
    }
  }
}

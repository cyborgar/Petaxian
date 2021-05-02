base {

  ; Define playfield limits
  const ubyte LBORDER = 0
  const ubyte RBORDER = 30;
  const ubyte UBORDER = 0
  const ubyte DBORDER = UBORDER + 24;

  ; Not needed on C64
  sub platform_setup() {
  }

  sub clear_screen() {
    ubyte x
    ubyte y
    for x in 0 to 39 
      for y in 0 to 24 
        txt.setcc( x, y, main.CLR, 0 )
  }

  ; Not needed on C64
  sub draw_extra_border() {
  }
}

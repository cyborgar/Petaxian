%import sound
%import joystick
%import keyboard

base {

  ; Define playfield limits
  const ubyte LBORDER = 0
  const ubyte RBORDER = 30;
  const ubyte UBORDER = 0
  const ubyte DBORDER = UBORDER + 24;

  ; Not needed on C64
  sub platform_setup() {
    c64.EXTCOL = $c
    sound.init()
  }

  ; Not needed on C64
  sub draw_extra_border() {
  }

}

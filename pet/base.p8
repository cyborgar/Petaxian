%import sound
%import joystick
%import keyboard

base {

  ; Define playfield limits
  const ubyte LBORDER = 0
  const ubyte RBORDER = 30;
  const ubyte UBORDER = 0
  const ubyte DBORDER = UBORDER + 24;

  ; Not needed on PET
  sub platform_setup() {
  }

  ; Not needed on PET
  sub draw_extra_border() {
  }

}

;
; Contains functions/setup that differes by platform (C64/CX16)
;

%import sound
%import textio
%import joystick
%import keyboard

base {

  ; Define playfield limits
  const ubyte LBORDER = 0
  const ubyte RBORDER = 30;
  const ubyte UBORDER = 2
  const ubyte DBORDER = UBORDER + 24;

  sub platform_setup() {
    ; Set 40 column mode 
    void cx16.screen_mode(3, false)
    txt.color2(1,0)
    txt.clear_screen()
    ; Init sound
    sound.init()
    ; Init joystick 
    joystick.init()
  }

  ; This simple additional decor is only for the X16
  sub draw_extra_border() {
    ubyte i
    for i in 0 to 39 {
      txt.setcc( i, UBORDER-1, $62, 12 )
      txt.setcc( i, DBORDER+1, $E2, 12 )
    }
  }

}

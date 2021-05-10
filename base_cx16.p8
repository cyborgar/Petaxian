%import sound_cx16

base {

  ; Define playfield limits
  const ubyte LBORDER = 0
  const ubyte RBORDER = 30;
  const ubyte UBORDER = 2
  const ubyte DBORDER = UBORDER + 24;

  ; Joystick info
  ubyte joy_info
  ubyte joy_info2
  ubyte joy_info3

  sub platform_setup() {
    ; Set 40 column mode 
    void cx16.screen_set_mode(0)
    ; Init sound
    sound.init()

    ; Need to set here to prevent removal as unused (only set in assmbly)
    joy_info = 0
    joy_info2 = 0
    joy_info3 = 0
  }

  ; Clear 40 line screen
  sub clear_screen() {
    ubyte x
    ubyte y
    for x in 0 to 39 
      for y in 0 to 29 
        txt.setcc( x, y, main.CLR, 0 )
  }

  ; This simple additional decor is only for the X16
  sub draw_extra_border() {
    ubyte i
    for i in 0 to 39 {
      txt.setcc( i, UBORDER-1, $62, 12 )
      txt.setcc( i, DBORDER+1, $E2, 12 )
    }
  }


  ; NES/SNES joystick support
  sub get_joystick_info() {
    get_raw_joystick(0)
  }
  
  ; Fetch joystick 
  asmsub get_raw_joystick(ubyte value @A) clobbers(X, Y) {
    %asm {{
      jsr cx16.joystick_get
      sta joy_info
      stx joy_info2
      sty joy_info3
      rts
    }}
  }

  sub joystick_start() -> ubyte {
    if joy_info ^ 255 == 32
      return 1
    return 0
  }

  sub joystick_fire() -> ubyte {
    if joy_info ^ 255 == 192 ; A or B on NES, Y or X on SNES
      return 1
    return 0
  }

  sub joystick_left() -> ubyte {
    return 0
  }

  sub joystick_right() -> ubyte{
    return 0
  }

}

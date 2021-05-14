; C64 joystic support through
;   c64.CIA1PRA (port 2)
; a second joystick would use c64.CIA1PRB (port 1)
;
; Reverse bit pattern set, so we use EOR 255 to reverse
;
; Bit	  Function
;  0	    Up
;  1        Down
;  2        Left
;  3        Right
;  4	    Fire
;
joystick {

  ubyte joy_info

  sub init() {
    joy_info = 0
  }

  sub pull_info() {
    joy_info = c64.CIA1PRA ^ 255  
  }

  sub pushing_start() -> ubyte {
    if joy_info & 1
      return 1
    return 0
  }

  sub pushing_fire() -> ubyte {
    if joy_info & 16
      return 1
    return 0
  }

  sub pushing_left() -> ubyte {
    if joy_info & 4
      return 1
    return 0
  }

  sub pushing_right() -> ubyte{
    if joy_info & 8
      return 1
    return 0
  }

}

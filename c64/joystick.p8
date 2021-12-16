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
    return joy_info & 1
  }

  sub pushing_fire() -> ubyte {
    return joy_info & 16
  }

  sub pushing_left() -> ubyte {
    return joy_info & 4
  }

  sub pushing_right() -> ubyte{
    return joy_info & 8
  }

}

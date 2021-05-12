;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; NES/SNES joystick support
;
; Note that all joystic bits are reversed (i.e 1 when not in use so
; any check need to XOR to get be able to compare with &

joystick {

  ; Joystick info
  ubyte joy_info
  ubyte joy_info2
  ubyte joy_info3

  ; Need to set here to prevent removal as unused (only set in assmbly)
  sub init() {
    joy_info = 0
    joy_info2 = 0
    joy_info3 = 0
  }

  ; Get joystick info from kernal to variables
  asmsub pull_info() clobbers(A, X, Y) {
    %asm {{
      lda #0                 ; Joystick 0
      jsr cx16.joystick_get
      sta joy_info
      stx joy_info2
      sty joy_info3
      stp
      rts
    }}
  }

  sub pushing_start() -> ubyte {
    ubyte pushed = joy_info ^ 255    
    if pushed & 16
      return 1
    return 0
  }

  sub pushing_fire() -> ubyte {
    ubyte pushed = joy_info ^ 255
    if pushed & 192    ; A or B on NES, B or Y on SNES
      return 1
    return 0
  }

  sub pushing_left() -> ubyte {
    ubyte pushed = joy_info ^ 255
    if pushed & 2
      return 1

    return 0
  }

  sub pushing_right() -> ubyte{
    ubyte pushed = joy_info ^ 255
    if pushed & 1
      return 1
    return 0
  }

}

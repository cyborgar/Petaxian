;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; NES/SNES joystick support
;
; Note that all joystic bits are reversed (i.e 1 when not in use so
; any check need to XOR to get be able to compare with &

joystick {

  ; Joystick info
  ubyte @shared joy_info
  ubyte @shared joy_info2
  ubyte @shared joy_info3

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
      eor #$ff               ; reverse bit pattern for easier testing
      cmp #$ff               ; Hack around NES keybord emulator issue
      beq skip_store         ; if all bits set assume skip setting joy_info
      sta joy_info
skip_store:
      stx joy_info2
      sty joy_info3
      rts
    }}
  }

  sub pushing_start() -> ubyte {
    return joy_info & 16
  }

  sub pushing_fire() -> ubyte {
    return joy_info & 192    ; A or B on NES, B or Y on SNES
  }

  sub pushing_left() -> ubyte {
    return joy_info & 2
  }

  sub pushing_right() -> ubyte{
    return joy_info & 1
  }

}

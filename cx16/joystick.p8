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
      eor #$ff               ; reverse bit pattern for easier testing
      cmp #$ff		     ; Hack around NES keybord emulator issue
      beq skip_store         ; if all bits set assume skip setting joy_info
      sta joy_info
skip_store:
      stx joy_info2
      sty joy_info3
      rts
    }}
  }

  sub pushing_start() -> ubyte {
    if joy_info & 16
      return 1
    return 0
  }

  sub pushing_fire() -> ubyte {
    if joy_info & 192    ; A or B on NES, B or Y on SNES
      return 1
    return 0
  }

  sub pushing_left() -> ubyte {
    if joy_info & 2
      return 1

    return 0
  }

  sub pushing_right() -> ubyte{
    if joy_info & 1
      return 1
    return 0
  }

}

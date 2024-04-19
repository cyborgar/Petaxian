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
  ubyte selected_joystick

  ; Need to set here to prevent removal as unused (only set in assmbly)
  sub init() {
    joy_info = 0
    joy_info2 = 0
    joy_info3 = 0
    selected_joystick = 128
  }

  ; Get joystick info from kernal to variables
  asmsub pull_info() clobbers(A, X, Y) {
    %asm {{
      lda p8v_selected_joystick
      and #7
      jsr cx16.joystick_get
      eor #$ff               ; reverse bit pattern for easier testing
      cmp #$ff               ; Hack around NES keybord emulator issue
      beq skip_store         ; if all bits set assume skip setting joy_info
      sta p8v_joy_info
skip_store:
      stx p8v_joy_info2
      sty p8v_joy_info3
      rts
    }}
  }

  sub pushing_start() -> bool {
    if joy_info & 16 > 0
      return true
    if selected_joystick == 128 {
      ; scan all joysticks to see if any presses start, then choose that one
      for cx16.r0L in 4 downto 0 {
        cx16.r1, void = cx16.joystick_get(cx16.r0L)
        if cx16.r1 & 16 == 0 {
           selected_joystick = cx16.r0L
           return true
        }
      }
    }
    return false
  }

  sub pushing_fire() -> bool {
    if joy_info & 192 > 0    ; A or B on NES, B or Y on SNES
      return true
    if selected_joystick==128 {
      ; scan all joysticks to see if any presses fire, then choose that one
      for cx16.r0L in 4 downto 0 {
        cx16.r1, void = cx16.joystick_get(cx16.r0L)
        if cx16.r1L & 192 != 192 {
           selected_joystick = cx16.r0L
           return true
        }
      }
    }
    return false
  }

  sub pushing_left() -> bool {
    return joy_info & 2 > 0
  }

  sub pushing_right() -> bool {
    return joy_info & 1 > 0
  }

}

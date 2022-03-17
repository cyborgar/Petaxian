; Custom keyboard input handler to allow for smooth movement with keyboard 
; control. Need to be able to
;  a) see if movement a key is kept pressed down and
;  b) allow fire key be pressed together with one of the movement keys
;
; Assembly function returs a bit pattern where 
;  - bit 0 = L_SHIFT pressed (fire)
;  - bit 1 = K pressed (left)
;  - bit 2 = L pressed (right)
;
; Note that K takes presedence over L so if K is pressed, we don't check for L.
;

keyboard {

  ubyte key

  sub pull_info() {
    key = c64.GETIN()
  }

  sub pushing_fire() -> ubyte {
    return key == 'z'
  }

  sub pushing_left() -> ubyte {
    return key == 'k' or key == 157
  }

  sub pushing_right() -> ubyte {
    return key == 'l' or key == 29
  }

}
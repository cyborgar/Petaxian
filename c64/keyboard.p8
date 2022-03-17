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

  asmsub pull_info() clobbers(A, X) {
    %asm {{
      ; Clear for reading
      lda #%11111111
      sta c64.CIA1DDRA 
      lda #%00000000
      sta c64.CIA1DDRB 

      ; Check for LEFT SHIFT
      lda #%11111101 ; Row 1 (PA1)
      sta c64.CIA1PRA
      lda c64.CIA1PRB
      and #%10000000 ; Col 7 (PB7)

      bne no_shift
      lda #$1         ; Set LEFT SHIFT in key
      jmp check_k

no_shift              ; otherwise clear key
      lda #$0

check_k
      sta key

      ; Check for K
      lda #%11101111 ; Row 4 (PA4)
      sta c64.CIA1PRA
      lda c64.CIA1PRB
      and #%00100000 ; Col 5 (PB5)

      bne check_l
      lda key
      ora #$02
      sta key

      rts ; Return, we don't check for L
      
check_l
      ; Check for L
      lda #%11011111 ; Row 5 (PA5)
      sta c64.CIA1PRA
      lda c64.CIA1PRB
      and #%00000100 ; Col 2 (PB2)

      bne return
      lda key
      ora #$04
      sta key

return
      rts

    }}
  }

  sub pushing_fire() -> ubyte {
    return key & 1
  }

  sub pushing_left() -> ubyte {
    return key & 2
  }

  sub pushing_right() -> ubyte {
    return key & 4
  }

}
;
; C64 sound effects
; 
; Currently just using one voice and give different effects some priorites
; for some limited control of effecst.
;
; Possibly consider a rewrite to use more vocies.
;
sound {
  ubyte sound_priority = 0

  sub init() {
    c64.MVOL = 15
  }

  sub check() {
    if sound_priority > 0 {
      sound_priority--
    }
  }

  sub fire() {
   if sound_priority > 4 { ; Prioritize explosions
      return
    }

    c64.MVOL = 8
    c64.AD1 = %01010111
    c64.SR1 = %00000000
    c64.FREQ1 = 2500
    c64.CR1 = %00010000
    c64.CR1 = %00010001

    sound_priority = 4
  }

  sub hit() {
    if sound_priority > 2 { ; Prioritize explosions
      return
    }

    c64.MVOL = 8
    c64.AD1 = %01010111
    c64.SR1 = %00000000
    c64.FREQ1 =10500
    c64.CR1 = %00010000
    c64.CR1 = %00010001

    sound_priority = 2
  }

  sub bomb() {
    if sound_priority > 6 { ; Prioritize explosions
      return
    }

    c64.MVOL = 5
    c64.AD1 = %01010111
    c64.SR1 = %00000000
    c64.FREQ1 = 4600
    c64.CR1 = %10000000
    c64.CR1 = %10000001
    
    sound_priority = 6
  }

  sub small_explosion() {
    if sound_priority > 8 { ; Prioritize large explosions
      return
    }

    c64.MVOL = 15
    c64.AD1 = %01100110
    c64.SR1 = %00000000
    c64.FREQ1 = 2600
    c64.CR1 = %10000000
    c64.CR1 = %10000001
    
    sound_priority = 8
  }

  sub large_explosion() {
    c64.MVOL = 15
    c64.AD1 = %01101010
    c64.SR1 = %00000000
    c64.FREQ1 = 1600
    c64.CR1 = %10000000
    c64.CR1 = %10000001

    sound_priority = 30
  }
  
  sub score_sound_and_delay() {
    ; short "burst" sound and a delay
    sound.small_explosion()
    sys.wait(50)
  }
}

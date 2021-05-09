sound {
  ubyte sound_cutoff = 0

  sub init() {
    c64.MVOL = 15
  }

  sub check() {
    if sound_cutoff {
      if sound_cutoff == 1
        off()
      sound_cutoff--
    }
  }

  sub fire() {
   if (sound_cutoff > 4) { ; Prioritize explosions
      return
    }

    c64.MVOL = 8
    c64.AD1 = %01010111
    c64.SR1 = %00000000
    c64.FREQ1 = 5500
    c64.CR1 = %00010000
    c64.CR1 = %00010001

    sound_cutoff = 4
  }

  sub hit() {
    if (sound_cutoff > 2) { ; Prioritize explosions
      return
    }

    c64.MVOL = 8
    c64.AD1 = %01010111
    c64.SR1 = %00000000
    c64.FREQ1 =10500
    c64.CR1 = %00010000
    c64.CR1 = %00010001

    sound_cutoff = 2
  }

  sub bomb() {
    if (sound_cutoff > 6) { ; Prioritize explosions
      return
    }

    c64.MVOL = 5
    c64.AD1 = %01010111
    c64.SR1 = %00000000
    c64.FREQ1 = 4600
    c64.CR1 = %10000000
    c64.CR1 = %10000001
    
    sound_cutoff = 6
  }

  sub small_explosion() {
    if (sound_cutoff > 8) { ; Prioritize large explosions
      return
    }

    c64.MVOL = 15
    c64.AD1 = %01100110
    c64.SR1 = %00000000
    c64.FREQ1 = 1600
    c64.CR1 = %10000000
    c64.CR1 = %10000001
    
    sound_cutoff = 8
  }

  sub large_explosion() {
    c64.MVOL = 15
    c64.AD1 = %01101010
    c64.SR1 = %00000000
    c64.FREQ1 = 2600
    c64.CR1 = %10000000
    c64.CR1 = %10000001

    sound_cutoff = 30
  }

  sub off() {
  }
}

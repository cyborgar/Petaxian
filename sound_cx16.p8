;
; This "system" can only play one sound so I have given "loader" sounds
; priority, I.e don't play gun fire if we already have an explosion under
; way.
; 

sound {
  ubyte sound_cutoff = 0

  sub init() {
      cx16.vpoke(1, $f9c2, %00111111)     ; volume max, no channels
  }

  ; Check if we need to turn off sound
  sub check() {
    if sound_cutoff {
      if sound_cutoff == 1
        off()
      sound_cutoff--
    }
  }

  sub fire() {
    if sound_cutoff > 4 { ; Prioritize explosions
      return
    }

    uword freq = 800
    cx16.vpoke(1, $f9c0, lsb(freq))
    cx16.vpoke(1, $f9c1, msb(freq))
    cx16.vpoke(1, $f9c2, %11110000)     ; volume
    cx16.vpoke(1, $f9c3, %01000000)     ; Sawtooth
    sound_cutoff = 4
  }

  sub hit() {
    if sound_cutoff > 2 { ; Prioritize explosions
      return
    }

    uword freq = 5000
    cx16.vpoke(1, $f9c0, lsb(freq))
    cx16.vpoke(1, $f9c1, msb(freq))
    cx16.vpoke(1, $f9c2, %11110000)     ; volume
    cx16.vpoke(1, $f9c3, %01000000)     ; noise waveform
    sound_cutoff = 2
  }

  sub bomb() {
    ; swish
    if sound_cutoff > 6 { ; Prioritize explosions
      return
    }

    uword freq = 2600
    cx16.vpoke(1, $f9c0, lsb(freq))
    cx16.vpoke(1, $f9c1, msb(freq))
    cx16.vpoke(1, $f9c2, %11110000)     ; half volume
    cx16.vpoke(1, $f9c3, %11000000)     ; noise waveform
    sound_cutoff = 6
  }

  sub small_explosion() {
    ; explosion
    if sound_cutoff > 8 { ; Prioritize large explosions
      return
    }

    uword freq = 400
    cx16.vpoke(1, $f9c0, lsb(freq))
    cx16.vpoke(1, $f9c1, msb(freq))
    cx16.vpoke(1, $f9c2, %11111111)     ; max volume
    cx16.vpoke(1, $f9c3, %11000000)     ; noise waveform
    sound_cutoff = 8
  }

  sub large_explosion() {
    ; big explosion
    uword freq = 800
    cx16.vpoke(1, $f9c0, lsb(freq))
    cx16.vpoke(1, $f9c1, msb(freq))
    cx16.vpoke(1, $f9c2, %11111111)     ; max volume
    cx16.vpoke(1, $f9c3, %11000000)     ; noise waveform
    sound_cutoff = 30
  }

  sub off() {
    cx16.vpoke(1, $f9c2, 0)     ; shut off
  }

}

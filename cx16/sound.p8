;
; Use different voice for each sound. Still won't allow two explosions at
; once (roate over multiple voices?)
; 

%import psg

sound {
  sub init() {
    psg.silent()
    cx16.set_irq(psg.envelopes_irq, true)
  }

  sub check() { ; Dummy function used on C64 only
  }

  sub fire() {
    psg.freq(0, 800)
    psg.voice(0, psg.LEFT| psg.RIGHT, 63, psg.SAWTOOTH, 0)
    psg.envelope(0, 45, 240, 3, 50)
  }

  sub hit() {
    psg.freq(1, 5000)
    psg.voice(1, psg.LEFT| psg.RIGHT, 63, psg.SAWTOOTH, 0)
    psg.envelope(1, 32, 100, 2, 10)
  }

  sub bomb() {
    psg.freq(2, 2600)
    psg.voice(2, psg.LEFT| psg.RIGHT, 63, psg.NOISE, 0)
    psg.envelope(2, 63, 100, 6, 10)
  }

  sub small_explosion() {
    psg.freq(3, 400)
    psg.voice(3, psg.LEFT| psg.RIGHT, 127, psg.NOISE, 0)
    psg.envelope(3, 63, 128, 8, 100)
  }

  sub large_explosion() {
    psg.freq(4, 450)
    psg.voice(4, psg.LEFT| psg.RIGHT, 127, psg.NOISE, 0)
    psg.envelope(4, 63, 100, 30, 50)
  }

  sub score_sound_and_delay() {
    ; short "burst" sound and a delay
    sound.small_explosion()
    sys.wait(50)
  }

}

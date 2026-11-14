;
; Use different voice for each sound. Still won't allow two explosions at
; once (roate over multiple voices?)
; 
; Note on the ADSR parameters: the old psg.envelope(voice, maxvolume, attack,
; sustain, release) API is gone. In the new API the maxvolume is passed to
; voice(), and its envelope timing differs:
;  - the old attack was effectively instant (voice() had already put the voice
;    at its maximum volume before the envelope started), so attack is 255,
;    which makes the new envelope jump to max volume immediately as well.
;  - release speeds are scaled to produce the same release time as before
;    (the old rate depended on maxvolume, the new one does not).
;  - the old voice() wrote full volume (63) to the PSG right away, before the
;    envelope brought it down to maxvolume on the next vsync. start() below
;    reproduces that initial full-volume transient, which gives the sounds
;    their sharp attack.

%import psg

sound {
  sub init() {
    psg.init()
    psg.off()
    sys.set_irq(&psg.update)
  }

  sub check() { ; Dummy function used on C64 only
  }

  sub apply() {
    ; Apply the changed voice parameters immediately instead of waiting for the
    ; next vsync interrupt. Interrupts are disabled so the vsync handler cannot
    ; call update() in the middle of this one (they share the same VERA context
    ; save buffer).
    sys.irqsafe_set_irqd()
    void psg.update()
    sys.irqsafe_clear_irqd()
  }

  sub start(ubyte voice_num, ubyte maxvol, ubyte waveform, uword freq, ubyte sustain, ubyte release) {
    ; Start a sound with the old library's attack transient: write full volume
    ; (63) to the PSG right away, then let the first update() bring the volume
    ; down to maxvol and continue with the envelope.
    psg.frequency(voice_num, freq)
    psg.voice(voice_num, psg.BOTH, 63, waveform, 0)
    sound.apply()
    psg.volume(voice_num, maxvol)
    ; the first update() after the envelope was set performs the attack tick,
    ; so the old sustain duration needs one tick less
    ubyte s = sustain
    if s > 0
      s--
    psg.envelope(voice_num, 255, s, release)
  }

  sub fire() {
    sound.start(0, 45, psg.SAWTOOTH, 800, 3, 71)
  }

  sub hit() {
    sound.start(1, 32, psg.SAWTOOTH, 5000, 2, 20)
  }

  sub bomb() {
    sound.start(2, 63, psg.NOISE, 2600, 6, 10)
  }

  sub small_explosion() {
    sound.start(3, 63, psg.NOISE, 400, 8, 101)
  }

  sub large_explosion() {
    sound.start(4, 63, psg.NOISE, 450, 30, 50)
  }

  sub score_sound_and_delay() {
    ; short "burst" sound and a delay
    sound.small_explosion()
    sys.wait(50)
  }

}

; No PET joystick support yet
;
joystick {

  ubyte joy_info

  sub init() {
    joy_info = 0
  }

  sub pull_info() {
    joy_info = 0
  }

  sub pushing_start() -> ubyte {
    return joy_info
  }

  sub pushing_fire() -> ubyte {
    return joy_info
  }

  sub pushing_left() -> ubyte {
    return joy_info
  }

  sub pushing_right() -> ubyte{
    return joy_info
  }

}

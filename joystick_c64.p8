; No support yet
;
joystick {

  ubyte joy_info

  sub init() {
    joy_info = 0
  }

  sub pull_info() {
    joy_info = c64.CIA1PRA ^ 255  
  }

  sub pushing_start() -> ubyte {
    if joy_info & 1
      return 1
    return 0
  }

  sub pushing_fire() -> ubyte {
    if joy_info & 16
      return 1
    return 0
  }

  sub pushing_left() -> ubyte {
    if joy_info & 4
      return 1
    return 0
  }

  sub pushing_right() -> ubyte{
    if joy_info & 8
      return 1
    return 0
  }

}

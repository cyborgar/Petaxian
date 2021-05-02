# Petaxian

This is a small project started to scrach muliple itches

- Doing something with the Commander X16 emulator (without having to work inside the emulator)
- Writing something low level without having to write things in assembly (at least for now)
- Test a new language (Prog8) found on the X16 pages

I fairly recently saw some good demos using C64 emulator and just PETSCII graphics and then
I remebered the old Galaga game on the C64. The one using just character graphics and thought
it would be interesting to test how difficult it would be to make something similar.

This is written in Prog8, see

- https://github.com/irmen/prog8
- https://prog8.readthedocs.io/en/latest/

and this is mostly a fun test project (it may never reach a finished state)

Though I have been working with the X16 emulator so far, the code compiles fine for the C64,
just replace line
```
%import base_cx16
```
with
```
%import base_c64
```

in the main file (```petaxian.p8```)

Note that the game runs a bit too slow on the C64).

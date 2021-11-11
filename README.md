# Petaxian

![Start](screens/start.png)

This is a small project started to scrach muliple itches

- Doing something with the Commander X16 emulator (without having to work inside the emulator)
- Writing something low level without having to write things in assembly (at least for now)
- Test a new language (Prog8) found on the X16 pages

During the Covid lockdown I saw some good demos using C64 emulator and just PETSCII graphics and then
I remebered the old Galaga game on the C64. The one using just character graphics and thought
it would be interesting to test how difficult it would be to make something similar.

![Start](screens/in_game.png)

This is written in Prog8, see

- https://github.com/irmen/prog8
- https://prog8.readthedocs.io/en/latest/

and is mostly a test project that may never reach a completely "finished" state. It's reach
a point where most of what I consider the fun stuff have been done so there is a good chance there
will not be a lot of actual changes to the game going forward. Though I do have a short list of 
features which may eventually be added.

Though I have worked mostly with the X16 emulator so far, the code compiles and runs for the C64
as well.

Compile/run for Commander X16 with something like this
```
%JAVA_PATH% -jar prog8compiler-7.2-all.jar -srcdirs cx16 -target cx16 petaxian.p8

%X16EMU_PATH%\x16emu.exe -joy1 SNES -run -prg petaxian.prg
```
and for C64 with e.g.
```
%JAVA_PATH% -jar prog8compiler-7.2-all.jar -srcdirs c64 -target c64 petaxian.p8

%VICE_PATH%\x64sc.exe petaxian.prg
```

Note that the game runs a bit too slow on the C64.

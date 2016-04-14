DWM process handler
========================================================================
The DWM process handler allowing to restart dwm without closing all windows.

Usage:
------

1. compile and add "exec dwmguard" to .xinitrc
1. configure a shortcut in dwm that would exit dwm with exit code != 0

The dwm guard will exit if dwm exited with exit code 0 or restart dwm
otherwise.

Function to exit with exist code:
---------------------------------
```c
static void exit_code(const Arg *args)
{
        exit(args->i);
}
```

Shortcut in DWM configh.h
-------------------------
```c
    { MODKEY|ShiftMask,        XK_r,            exit_code,      {.i = 1} },
```

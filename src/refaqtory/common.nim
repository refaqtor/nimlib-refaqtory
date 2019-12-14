#common.nim

#--- DISPLAY LEVEL

var displayLevel: int
# error = 0, state = 1, activity = 2, debug = 3
proc setDisplay*(display = 1) =
    displayLevel=display

proc see*(level = 0, message: string) =
    if level <= displayLevel:
        echo message
display $st0
display $st1
display $st2
display $st3
display $st4
display $st5
display $st6
display $st7

define x87env
    printf "fctrl = 0x%04x\n", $fctrl
    printf "  IM=%d DM=%d ZM=%d OM=%d UM=%d PM=%d PC=%d RC=%d\n", \
        ($fctrl >> 0) & 1, \
        ($fctrl >> 1) & 1, \
        ($fctrl >> 2) & 1, \
        ($fctrl >> 3) & 1, \
        ($fctrl >> 4) & 1, \
        ($fctrl >> 5) & 1, \
        ($fctrl >> 8) & 3, \
        ($fctrl >> 10) & 3

    printf "fstat = 0x%04x\n", $fstat
    printf "  IE=%d DE=%d ZE=%d OE=%d UE=%d PE=%d SF=%d ES=%d\n", \
        ($fstat >> 0) & 1, \
        ($fstat >> 1) & 1, \
        ($fstat >> 2) & 1, \
        ($fstat >> 3) & 1, \
        ($fstat >> 4) & 1, \
        ($fstat >> 5) & 1, \
        ($fstat >> 6) & 1, \
        ($fstat >> 7) & 1

    printf "  C0=%d C1=%d C2=%d C3=%d TOP=%d\n", \
        ($fstat >> 8) & 1, \
        ($fstat >> 9) & 1, \
        ($fstat >> 10) & 1, \
        ($fstat >> 14) & 1, \
        ($fstat >> 11) & 7

    printf "ftag  = 0x%04x\n", $ftag
    printf "  T0=%d T1=%d T2=%d T3=%d T4=%d T5=%d T6=%d T7=%d\n", \
        ($ftag >> 0) & 3, \
        ($ftag >> 2) & 3, \
        ($ftag >> 4) & 3, \
        ($ftag >> 6) & 3, \
        ($ftag >> 8) & 3, \
        ($ftag >> 10) & 3, \
        ($ftag >> 12) & 3, \
        ($ftag >> 14) & 3
end

start
record full
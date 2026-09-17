#!/bin/bash
# USB HID Keystroke Decoder
# Usage: ./decode <file.pcap>
# Requires: tshark

if [ -z "$1" ]; then
    echo "Usage: $0 <file.pcap>"
    exit 1
fi

PCAP="$1"

if [ ! -f "$PCAP" ]; then
    echo "Error: file '$PCAP' not found"
    exit 1
fi

tshark -r "$PCAP" -Y "usb.capdata" -T fields -e usb.capdata 2>/dev/null | awk '
BEGIN {
    # Keycode -> lowercase char mapping (USB HID Usage Table)
    map["04"]="a"; map["05"]="b"; map["06"]="c"; map["07"]="d";
    map["08"]="e"; map["09"]="f"; map["0a"]="g"; map["0b"]="h";
    map["0c"]="i"; map["0d"]="j"; map["0e"]="k"; map["0f"]="l";
    map["10"]="m"; map["11"]="n"; map["12"]="o"; map["13"]="p";
    map["14"]="q"; map["15"]="r"; map["16"]="s"; map["17"]="t";
    map["18"]="u"; map["19"]="v"; map["1a"]="w"; map["1b"]="x";
    map["1c"]="y"; map["1d"]="z";
    map["1e"]="1"; map["1f"]="2"; map["20"]="3"; map["21"]="4";
    map["22"]="5"; map["23"]="6"; map["24"]="7"; map["25"]="8";
    map["26"]="9"; map["27"]="0";
    map["28"]="\n"; map["2c"]=" "; map["2d"]="-"; map["2e"]="=";
    map["36"]=","; map["37"]=".";

    # Shifted versions
    shiftmap["1e"]="!"; shiftmap["1f"]="@"; shiftmap["20"]="#";
    shiftmap["21"]="$"; shiftmap["22"]="%"; shiftmap["23"]="^";
    shiftmap["24"]="&"; shiftmap["25"]="*"; shiftmap["26"]="(";
    shiftmap["27"]=")"; shiftmap["2d"]="_"; shiftmap["2e"]="+";
    shiftmap["36"]="<"; shiftmap["37"]=">";
}
{
    # each line = 16 hex chars = 8 bytes, colon or plain hex depending on tshark version
    gsub(":", "", $0)
    line = tolower($0)
    if (length(line) < 16) next

    modifier = substr(line, 1, 2)
    keycode  = substr(line, 5, 2)

    if (keycode == "00") next   # key-up event, skip

    shift = (modifier == "02" || modifier == "20")

    if (keycode in map) {
        ch = map[keycode]
        if (shift) {
            if (keycode in shiftmap) {
                ch = shiftmap[keycode]
            } else {
                ch = toupper(ch)
            }
        }
        printf "%s", ch
    }
}
END { print "" }
'

#!/usr/bin/env bash
#============================================================================
#
#        Title:  convertatemp
#
#        Usage:  $0 temperature[K|C|F|Ra|Ro|N|D|Re]
#
#  Description:  Convertatemp - Temperature conversion script that lets the
#                user enter a temperature in Fahrenheit, Celsius, or Kelvin
#                and receive the equivalent temperature in the other two
#                units as the output
#
#      Options:  ---
# Requirements:  ---
#         Bugs:  ---
#        Notes:  ---
#       Author:
#      Company:
#      Version:
#      Created:
#     Revision:  ---
#============================================================================

#============================================================================
# History
#============================================================================
#
#
#============================================================================

#                                _        _
#   ___ ___  _ ____   _____ _ __| |_ __ _| |_ ___ _ __ ___  _ __
#  / __/ _ \| '_ \ \ / / _ | '__| __/ _` | __/ _ | '_ ` _ \| '_ \
# | (_| (_) | | | \ V |  __| |  | || (_| | ||  __| | | | | | |_) |
#  \___\___/|_| |_|\_/ \___|_|   \__\__,_|\__\___|_| |_| |_| .__/
#                                                          |_|

# "$?" is the exit state of a process.  0 = success  If $? -ne (is not equal
# to) 0, something went wrong

#############################################################################
## MAIN SCRIPT                                                             ##
#############################################################################

if [ $# -eq 0 ]
then
    echo "Usage: $0 temperature[K|C|F|R|Ro|N|De|Re]
Where the suffix:
   K    indicates input is in °Kelvin
   C    indicates input is in °Celsius
   F    indicates input is in °Fahrenheit (default) 
   R    indicates input is in °Rankine
   Ro   indicates input is in °Rømer
   N    indicates input is in °Newton
   De   indicates input is in °Delisle
   Re   indicates input is in °Réaumur"
    exit 0
fi

unit="$(echo "$1" | sed -e 's/[-[[:digit:]]*//g' | tr '[:lower:]' '[:upper:]')"
tempTemp="$(echo "$1" | sed -e 's/[^[:digit:]\.]*//g')"
temp=$(echo "scale=2; $tempTemp" | bc -l)

case ${unit:=F}
in
    F)  
        # Fahrenheit to Celsius formula:   C = (F - 32) / 1.8
        # Fahrenheit to Kelvin formula:    K = (F - 32) * 5 / 9 + 273.15
        # Fahrenheit to Rankine formula:   R = F + 459.67
        # Fahrenheit to Newton formula:    N = F - 32 * 0.18
        # Fahrenheit to Rømer formula:    Ro = (F - 32) * 0.29 + 7.50
        # Fahrenheit to Delisle formula:  De = (F - 32) * 0.83 - 100
        # Fahrenheit to Réaumur formula:  Re = (F - 32) * 0.44
        fahr="$temp"
        cels="$(echo "scale=2;($fahr - 32) / 1.8" | bc)"
        kelv="$(echo "scale=2;($fahr + 273.15) * 5/9" | bc)"
        rank="$(echo "scale=2;$fahr + 459.67" | bc)"
        newt="$(echo "scale=2;($fahr - 32) * 0.18" | bc)"
        rome="$(echo "scale=2;($fahr - 32) * 0.29 + 7.50" | bc)"
        deli="$(echo "scale=2;($fahr - 32) * 0.83 - 100" | bc)"
        reau="$(echo "scale=2;($fahr - 32) * 0.44" | bc)"
    ;;
    C)  
        # Celsius to Fahrenheit formula:   F = (C * 9/5) + 32
        # Celsius to Kelvin formula:       K = C + 273.15
        # Celsius to Rankine formula:      R = C * 9/5 + 491.67
        # Celsius to Newton formula:       N = C * 0.33
        # Celsius to Rømer formula:       Ro = C * 0.52 + 7.50
        # Celsius to Delisle formula:     De = C * 1.50 - 100
        # Celsius to Réaumur formula:     Re = C * 0.80
        cels="$temp"
        kelv="$(echo "scale=2;$cels + 273.15" | bc)"
        rank="$(echo "scale=2;((9/5) * $cels) + 491.67" | bc)"
        fahr="$(echo "scale=1;((9/5) * $cels) + 32" | bc)"
        newt="$(echo "scale=2;$cels * 0.33" | bc)"
        rome="$(echo "scale=2;$cels * 0.52 + 7.50" | bc)"
        deli="$(echo "scale=2;$cels * 1.50 -100" | bc)"
        reau="$(echo "scale=2;$cels * 0.80" | bc)"
    ;;
    K)  
        # Kelvin to Celsius Formula:       C = K - 273.15
        # Kelvin to Fahrenheit formula:    F = K * 9/5 - 459.67
        # Kelvin to Rankine formula:       R = K * 9/5
        # Kelvin to Newton formula:        N = K - 273.15 * 0.33
        # Kelvin to Rømer formula:        Ro = (K -273.15) * 0.52 + 7.50
        # Kelvin to Delisle formula:      De = (K - 273.15) * 1.50 - 100.00
        # Kelvin to Réaumur formula:      Re = (K - 273.15) * 0.80
        kelv="$temp"
        rank="$(echo "scale=2;(9/5) * $kelv" | bc)"
        fahr="$(echo "scale=1; ((9/5) * $kelv) - 459.67" | bc)"
        cels="$(echo "scale=2;$kelv - 273.15" | bc)"
        newt="$(echo "scale=2;($kelv - 273.15) * 0.33" | bc)"
        rome="$(echo "scale=2;($kelv - 273.15) * 0.52 + 7.50" | bc)"
        deli="$(echo "scale=2;($kelv - 273.15) * 1.50 - 100" | bc)"
        reau="$(echo "scale=2;($kelv - 273.15) * 0.80" | bc)"
    ;;
    R)  
        # Rankine to Fahrenheit formula:   F = R - 459.67
        # Rankine to Celsius formula:      C = R * 5/9 - 273.15
        # Rankine to Kelvin formula:       K = R * 5/9
        # Rankine to Newton formula:       N = R - 491.67 * 0.18
        # Rankine to Rømer formula:       Ro = (R - 491.67) * 0.29 + 7.50
        # Rankine to Delisle formula:     De = (R - 491.67) * 0.83 - 100
        # Rankine to Réaumur formula:     Rè = (R - 491.67) * 0.44
        rank="$temp"
        fahr="$(echo "scale=1;$rank - 459.67" | bc)"
        cels="$(echo "scale=2;((5/9) * $rank) - 273.15" | bc)"
        kelv="$(echo "scale=2;(5/9) * $rank" | bc)";
        newt="$(echo "scale=2;($rank - 491.67) * 0.18" | bc)"
        rome="$(echo "scale=2;($rank - 491.67) * 0.29 + 7.50" | bc)"
        deli="$(echo "scale=2;($rank - 491.67) * 0.83 - 100" | bc)"
        reau="$(echo "scale=2;($rank - 491.67) * 0.44" | bc)"
    ;;
    N)
        # Newton to Fahrenheit formula:    F = N - 459.67
        # Newton to Celsius formula:       C = N * 5/9 - 273.15
        # Newton to Kelvin formula:        K = N / 0.33 + 273.15
        # Newton to Rankine formula:       R = N * 5.45 + 491.67
        # Newton to Rømer formula:        Ro = N * 1.59 + 7.50
        # Newton to Delisle formula:      De = N * 4.54 - 100
        # Newton to Réaumur formula:      Rè = N * 2.42
        newt="$temp"
        fahr="$(echo "scale=1;($newt * 5.45) + 32" | bc)"
        cels="$(echo "scale=2;($newt / 0.33)" | bc)"
        kelv="$(echo "scale=2;($newt / 0.33) + 273.15" | bc)"
        rank="$(echo "scale=2;($newt * 5.45) + 491.67" | bc)"
        rome="$(echo "scale=2;$newt * 1.59 + 7.50" | bc)"
        deli="$(echo "scale=2;$newt * 4.54 - 100" | bc)"
        reau="$(echo "scale=2;$newt * 2.42" | bc)"
    ;;
    RO)
        # Rømer to Fahrenheit formula:    F = (Ro - 7.5) * 3.42 + 32
        # Rømer to Celsius formula:       C = (Ro - 7.5) / 0.52
        # Rømer to Kelvin formula:        K = (Ro - 7.5) + 273.15
        # Rømer to Rankine formula:       R = ((Ro -7.5) * 3.42) - 491.67
        # Rømer to Newton formula:        N = (Ro -7.5) * 0.02
        # Rømer to Delisle formula:      De = (Ro - 7.5) * 2.85 - 100
        # Rømer to Réaumur formula:      Re = (Ro - 7.5) * 1.52
        rome="$temp"
        fahr="$(echo "scale=1;($rome - 7.50) * 3.42 + 32" | bc)"
        cels="$(echo "scale=2;($rome - 7.50) / 0.52" | bc)"
        kelv="$(echo "scale=2;($rome - 7.50) + 273.15" | bc)"
        rank="$(echo "scale=2;($rome - 7.50) * 3.42 + 491.67" | bc)"
        newt="$(echo "scale=2;($rome - 7.50) * 0.02" | bc)"
        deli="$(echo "scale=2;($rome - 7.50) * 2.85 - 100" | bc)"
        reau="$(echo "scale=2;($rome - 7.50) * 1.52" | bc)"
    ;;
    DE)
        # Delisle to Fahrenheit formula:  F = (De + 100) * 1.20 + 32
        # Delisle to Celsius formula:     C = (De + 100) / 1.50
        # Delisle to Kelvin formula:      K = (De + 100) / 1.50 + 273.15
        # Delisle to Rankine formula:     R = (De + 100) * 1.20 + 491.67
        # Delisle to Newton formula:      N = (De + 100) * 0.22
        # Delisle to Rømer formula:      Ro = (De + 100) * 0.35 + 7.50
        # Delisle to Réaumur formula:    Re = (De + 100) * 0.53
        deli="$temp"
        fahr="$(echo "scale=1;($deli + 100) * 1.20 + 32" | bc)"
        cels="$(echo "scale=2;($deli + 100) / 1.50" | bc)"
        kelv="$(echo "scale=2;($deli + 100) / 1.50 + 273.15" | bc)"
        rank="$(echo "scale=2;($deli + 100) * 1.20 + 491.67" | bc)"
        newt="$(echo "scale=2;($deli + 100) * 0.22" | bc)"
        rome="$(echo "scale=2;($deli + 100) * 0.35 + 7.50" | bc)"
        reau="$(echo "scale=2;($deli + 100) * 0.53" | bc)"
    ;;
    RE)
        # Réaumur to Fahrenheit formula:  F = Ré * 2.25 + 32
        # Réaumur to Celsius formula:     C = Re / 0.80
        # Réaumur to Kelvin formula:      K = (Re / 0.80) + 273.15
        # Réaumur to Rankine formula:     R = Ré * 2.25 + 491.67
        # Réaumur to Newton formula:      N = Ré * 0.41
        # Réaumur to Rømer formula:      Ro = Ré * 0.65 + 7.50
        # Réaumur to Delisle formula:    De = Ré * 1.87 - 100
        reau="$temp"
        fahr="$(echo "scale=1;$reau * 2.25 + 32" | bc)"
        cels="$(echo "scale=2;$reau / 0.80" | bc)"
        kelv="$(echo "scale=2;($reau / 0.80) + 273.15" | bc)"
        rank="$(echo "scale=2;$reau * 2.25 + 491.67" | bc)"
        newt="$(echo "scale=2;$reau * 0.41" | bc)"
        rome="$(echo "scale=2;$reau * 0.65 + 7.50" | bc)"
        deli="$(echo "scale=2;$reau * 1.87 - 100" | bc)"
    ;;
esac

echo "Kelvin     = $kelv°K"
echo "Celsius    = $cels°C"
echo "Fahrenheit = $fahr°F"
echo "Rankine    = $rank°R"
echo "Rømer      = $rome°Rø"
echo "Newton     = $newt°N"
echo "Delisle    = $deli°De"
echo "Rèaumur    = $reau°Ré"

exit 0


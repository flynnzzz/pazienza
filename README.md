# pazienza.lua

 Simulation of a popular italian card game that goes by many names, one of which
 is "Solitario della pazienza" (Solitaire of patience).

## 1. requirements

- Lua 5.4+

## 2. usage

```
Usage:
    lua pazienza.lua <action> <deck-type> [options]

Actions:
    play       Play games [-n N] times.
    simulate   Play games until victory.
    binomial   Run 2^20 trials (equivalent to `play -n 1048576`).

Valid deck types:
    italian   Denare, Coppe, Spade, Bastoni
    poker     Hearts, Diamonds, Clubs, Spades
    mahjong   Dots, Bamboo, Characters, Winds, Dragon

Options:
    -h        Verbose output (HIGH)
    -m        Medium verbosity
    -l        Low verbosity
    -z        Minimal verbosity
    -n N      Number of games to play (applies only to 'play')

Notes:
    • Default verbosity for 'play' is HIGH.
    • Default verbosity for 'simulate' is MEDIUM.
    • The 'binomial' action caps at MEDIUM verbosity;
      using the '-h' flag with this action has no effect.
```

## 3. rules

...


# pazienza.lua

 Simulation of a popular italian card game that goes by many names, one of which
 is "Solitario della pazienza" (Solitaire of patience).

## 1. requirements

- Lua 5.4+

## 2. usage

```
Usage:
  lua pazienza.lua <ACTION> <SEEDTYPE> [OPTIONS]

Actions:
  play              Play one game
  simulate          Play games until victory
  average           Calculate the average win rate

Seedtypes:
  italian           Denare, Coppe, Spade, Bastoni
  poker             Hearts, Diamonds, Clubs, Spades
  mahjong           Dots, Bamboo, Characters, Winds, Dragon

Options:
  -z                Set verbosity to LOWEST
  -l                Set verbosity to LOW
  -m                Set verbosity to MEDIUM
  -h                Set verbosity to HIGH

Default verbosity values:
  play: HIGH
  simulate: MEDIUM
  average: LOWEST
```

## 3. rules

...


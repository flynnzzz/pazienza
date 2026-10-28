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

## 3. notes

- My first multiple files lua project, this helped me greatly in familiarizing
with the language
- ~Implementing the game solver using recursion was very stimulating~
- Finding flaws and fixing the game solver's logic was very stimulating
- Digitalizing this card game and "achieving victory" this way was quite
satisfying (considering the unlikeliness of winning with actual physical cards).

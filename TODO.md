- Add a progress bar to action `average`
- Add game rules to `README.md`
- Remake seedtypes definition method to allow for more versatility 
(cards with custom names and values)

```lua
-- prototype
UNO_MODEL = {
  name = "Uno Model",

  -- if only one of them is absent, throw error;
  -- if both are absent, continue (no numbered cards).
  number_start = 0,
  number_end = 9,

  -- default = 1
  multiplicity = 4,

  -- special cards belonging to a particular seed
  specials = {
    -- `unique_name` is false by default
    BLOCK = { name = "Block", value = 10, unique_name = false },
    INVERT = { name = "Invert", value = 11, unique_name = false },
    ...
  },
  ...
}

-- auxiliary function from somewhere
RED = from_model(MODEL, "Red")
GREEN = from_model(MODEL, "Green")
...

Uno:
{
  RED,
  GREEN,

  -- to keep things simple, if you want to define a
  -- special card that doesn't belong to any seed,
  -- you can just create an unique seed with only one card
  SPECIAL_CARD_SET = {
    name = "Special card's set",
    specials = {
      SUPER_JOLLY = { name = "+100 cards", value = 999, unique_name = true }
    }
  },
  ...
}
```

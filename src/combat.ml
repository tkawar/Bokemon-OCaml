open Types

let effectiveness attacker defender =
  match attacker, defender with
  | Fire, Grass -> SE
  | Grass, Water -> SE
  | Water, Fire -> SE

  | Fire, Fire -> Normal
  | Grass, Grass -> Normal
  | Water, Water -> Normal

  | _ -> NVE

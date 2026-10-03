type bty =
  | Fire
  | Grass
  | Water

type effectiveness =
  | SE
  | NVE
  | Normal

type bmon = {
  name : string;
  ty : bty;
  hp : int;
  max_hp : int;
  strength : int;
  defense : int;
}

let string_of_bty ty =
  match ty with
  | Fire -> "Fire"
  | Grass -> "Grass"
  | Water -> "Water"

let string_of_effectiveness rating =
  match rating with
  | SE -> "Super Effective"
  | NVE -> "Not Very Effective"
  | Normal -> "Normal"

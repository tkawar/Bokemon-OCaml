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


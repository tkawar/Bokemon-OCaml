open Types

let emberimp =
  {
    name = "Emberimp";
    ty = Fire;
    hp = 75;
    max_hp = 75;
    strength = 20;
    defense = 10;
    level = 1;
    xp = 0;
  }

let dewfin =
  {
    name = "Dewfin";
    ty = Water;
    hp = 80;
    max_hp = 80;
    strength = 19;
    defense = 11;
    level = 1;
    xp = 0;
  }

let thornlet =
  {
    name = "Thornlet";
    ty = Grass;
    hp = 95;
    max_hp = 95;
    strength = 23;
    defense = 14;
    level = 2;
    xp = 0;
  }

let cinderfang =
  {
    name = "Cinderfang";
    ty = Fire;
    hp = 90;
    max_hp = 90;
    strength = 25;
    defense = 13;
    level = 2;
    xp = 0;
  }

let riptide =
  {
    name = "Riptide";
    ty = Water;
    hp = 110;
    max_hp = 110;
    strength = 28;
    defense = 16;
    level = 3;
    xp = 0;
  }

let bramblehorn =
  {
    name = "Bramblehorn";
    ty = Grass;
    hp = 120;
    max_hp = 120;
    strength = 27;
    defense = 18;
    level = 3;
    xp = 0;
  }

let pyroclaw =
  {
    name = "Pyroclaw";
    ty = Fire;
    hp = 130;
    max_hp = 130;
    strength = 31;
    defense = 20;
    level = 4;
    xp = 0;
  }

type trainer = {
  trainer_name : string;
  team : bmon list;
}

let rookie_nia =
  {
    trainer_name = "Rookie Nia";
    team =
      [
        emberimp;
        dewfin;
      ];
  }

let ranger_finn =
  {
    trainer_name = "Ranger Finn";
    team =
      [
        thornlet;
        cinderfang;
      ];
  }

let captain_mira =
  {
    trainer_name = "Captain Mira";
    team =
      [
        riptide;
        bramblehorn;
        pyroclaw;
      ];
  }

let trainers =
  [
    rookie_nia;
    ranger_finn;
    captain_mira;
  ]

let rec trainer_at_position
    (trainers : trainer list)
    position =
  match trainers, position with
  | [], _ ->
      None

  | trainer :: _, 1 ->
      Some trainer

  | _ :: remaining, n when n > 1 ->
      trainer_at_position remaining (n - 1)

  | _ ->
      None
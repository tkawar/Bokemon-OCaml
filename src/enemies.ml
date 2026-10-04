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

let solarfang =
  {
    name = "Solarfang";
    ty = Fire;
    hp = 130;
    max_hp = 130;
    strength = 30;
    defense = 20;
    level = 6;
    xp = 0;
  }

let tidewarden =
  {
    name = "Tidewarden";
    ty = Water;
    hp = 140;
    max_hp = 140;
    strength = 29;
    defense = 22;
    level = 6;
    xp = 0;
  }

let verdantusk =
  {
    name = "Verdantusk";
    ty = Grass;
    hp = 150;
    max_hp = 150;
    strength = 30;
    defense = 23;
    level = 7;
    xp = 0;
  }

let blazewing =
  {
    name = "Blazewing";
    ty = Fire;
    hp = 145;
    max_hp = 145;
    strength = 33;
    defense = 22;
    level = 7;
    xp = 0;
  }

let abyssfin =
  {
    name = "Abyssfin";
    ty = Water;
    hp = 160;
    max_hp = 160;
    strength = 34;
    defense = 24;
    level = 8;
    xp = 0;
  }

let crownthorn =
  {
    name = "Crownthorn";
    ty = Grass;
    hp = 175;
    max_hp = 175;
    strength = 36;
    defense = 27;
    level = 9;
    xp = 0;
  }

type trainer = {
  trainer_name : string;
  team : bmon list;
  trainer_xp_reward : int;
  unlock_level : int;
}

let rookie_nia =
  {
    trainer_name = "Rookie Nia";
    team =
      [
        emberimp;
        dewfin;
      ];
    trainer_xp_reward = 100;
    unlock_level = 1;
  }

let ranger_finn =
  {
    trainer_name = "Ranger Finn";
    team =
      [
        thornlet;
        cinderfang;
      ];
    trainer_xp_reward = 200;
    unlock_level = 3;
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
    trainer_xp_reward = 300;
    unlock_level = 7; 
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



let champion =
  {
    trainer_name = "Champion Cassian";
    team =
      [
        solarfang;
        tidewarden;
        verdantusk;
        blazewing;
        abyssfin;
        crownthorn;
      ];
    trainer_xp_reward = 0;
    unlock_level = 0;
  }


  
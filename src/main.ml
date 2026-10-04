open Types

let flarecub =
  {
    name = "Flarecub";
    ty = Fire;
    hp = 80;
    max_hp = 80;
    strength = 24;
    defense = 12;
    level = 1;
    xp = 0;
  }

let mossling =
  {
    name = "Mossling";
    ty = Grass;
    hp = 95;
    max_hp = 95;
    strength = 18;
    defense = 18;
    level = 1;
    xp = 0;
  }

let aquaphin =
  {
    name = "Aquaphin";
    ty = Water;
    hp = 85;
    max_hp = 85;
    strength = 21;
    defense = 15;
    level = 1;
    xp = 0;
  }

let starting_team =
  [
    flarecub;
    mossling;
    aquaphin;
  ]

let () =
  let player =
    Player.create_player
      "Husam"
      starting_team
  in

  Game.main_menu player 
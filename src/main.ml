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
    Player.create_player "Husam" starting_team
  in

  Printf.printf
    "Trainer: %s\n"
    player.Player.name;

  Printf.printf
    "Starting B-Bucks: %d\n"
    player.Player.bbucks;

  let player =
    Player.spend_bbucks player 10
  in

  Printf.printf
    "After normal attack: %d B-Bucks\n"
    player.Player.bbucks;

  let player =
    Player.add_bbucks player 1000
  in

  Printf.printf
    "After victory reward: %d B-Bucks\n"
    player.Player.bbucks;

  let player =
    Player.add_win player
  in

  Printf.printf
    "Wins: %d\n"
    player.Player.wins


let () =
  let poor_player =
    Player.create_player "Test" starting_team
  in

  try
    let _ =
      Player.spend_bbucks poor_player 200
    in
    print_endline "Purchase succeeded."
  with
  | Player.BuyMoreBBucks ->
      print_endline "Not enough B-Bucks!"
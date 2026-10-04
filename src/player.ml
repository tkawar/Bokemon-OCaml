open Types

type player = {
  name : string;
  bbucks : int;
  team : bmon list;
  wins : int;
}

exception BuyMoreBBucks

let create_player name team =
  {
    name = name;
    bbucks = 100;
    team = team;
    wins = 0;
  }

let add_bbucks player amount =
  {
    player with
    bbucks = player.bbucks + amount;
  }

let spend_bbucks player amount =
  if player.bbucks < amount then
    raise BuyMoreBBucks
  else
    {
      player with
      bbucks = player.bbucks - amount;
    }

let add_win player =
  {
    player with
    wins = player.wins + 1;
  }


let rec replace_bokemon
    (team : bmon list)
    (updated_bokemon : bmon) =
  match team with
  | [] ->
      []

  | bokemon :: remaining ->
      if bokemon.name = updated_bokemon.name then
        updated_bokemon :: remaining
      else
        bokemon :: replace_bokemon remaining updated_bokemon

let update_bokemon
    (player : player)
    (updated_bokemon : bmon) =
  {
    player with
    team = replace_bokemon player.team updated_bokemon;
  }

  let rec bokemon_at_position
    (team : bmon list)
    position =
  match team, position with
  | [], _ ->
      None

  | bokemon :: _, 1 ->
      Some bokemon

  | _ :: remaining, n when n > 1 ->
      bokemon_at_position remaining (n - 1)

  | _ ->
      None



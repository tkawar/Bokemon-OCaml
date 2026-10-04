open Types

type player = {
  name : string;
  bbucks : int;
  team : bmon list;
  wins : int;
  trainer_level : int;
  trainer_xp : int;
}

exception BuyMoreBBucks

let create_player name team =
  {
    name = name;
    bbucks = 100;
    team = team;
    wins = 0;
    trainer_level = 1;
    trainer_xp = 0
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

let rec has_available_bokemon (team : bmon list) =
  match team with
  | [] ->
      false

  | bokemon :: remaining ->
      if bokemon.hp > 0 then
        true
      else
        has_available_bokemon remaining

let half_heal (bokemon : bmon) =
  let heal_amount =
    (bokemon.max_hp + 1) / 2
  in

  let new_hp =
    bokemon.hp + heal_amount
  in

  let final_hp =
    if new_hp > bokemon.max_hp then
      bokemon.max_hp
    else
      new_hp
  in

  {
    bokemon with
    hp = final_hp;
  }

let full_heal (bokemon : bmon) =
  {
    bokemon with
    hp = bokemon.max_hp;
  }

let trainer_xp_required (player : player) =
  player.trainer_level * 100

let rec add_trainer_xp (player : player) amount =
  let total_xp =
    player.trainer_xp + amount
  in

  let required =
    trainer_xp_required player
  in

  if total_xp >= required then
    let remaining_xp =
      total_xp - required
    in

    let leveled_player =
      {
        player with
        trainer_level = player.trainer_level + 1;
        trainer_xp = 0;
      }
    in

    add_trainer_xp
      leveled_player
      remaining_xp
  else
    {
      player with
      trainer_xp = total_xp;
    }

let rec team_contains_name
    (team : bmon list)
    target_name =
  match team with
  | [] ->
      false

  | bokemon :: remaining ->
      if bokemon.name = target_name then
        true
      else
        team_contains_name
          remaining
          target_name

let rec append_bokemon
    (team : bmon list)
    (new_bokemon : bmon) =
  match team with
  | [] ->
      [new_bokemon]

  | bokemon :: remaining ->
      bokemon
      :: append_bokemon
           remaining
           new_bokemon

let add_bokemon
    (player : player)
    (new_bokemon : bmon) =
  {
    player with
    team =
      append_bokemon
        player.team
        new_bokemon;
  }

let replace_team
    (player : player)
    (team : bmon list) =
  {
    player with
    team = team;
  }



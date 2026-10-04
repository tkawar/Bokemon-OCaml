open Types

let xp_required bokemon =
  bokemon.level * 100

let level_up bokemon =
  let new_max_hp =
    bokemon.max_hp + 10
  in

  {
    bokemon with
    level = bokemon.level + 1;
    xp = 0;
    strength = bokemon.strength + 1;
    defense = bokemon.defense + 1;
    max_hp = new_max_hp;
    hp = new_max_hp;
  }

let rec add_xp bokemon amount =
  let total_xp =
    bokemon.xp + amount
  in

  let required =
    xp_required bokemon
  in

  if total_xp >= required then
    let remaining_xp =
      total_xp - required
    in

    let leveled_bokemon =
      level_up bokemon
    in

    add_xp leveled_bokemon remaining_xp
  else
    {
      bokemon with
      xp = total_xp;
    }


let xp_reward winner defeated =
  let required =
    xp_required winner
  in

  let level_difference =
    defeated.level - winner.level
  in

  if level_difference >= 2 then
    required

  else if level_difference = 1 then
    (required * 3) / 4

  else if level_difference = 0 then
    required / 2

  else if level_difference = -1 then
    required / 4

  else
    required / 10
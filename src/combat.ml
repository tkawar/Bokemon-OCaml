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

let damage_with_rating attacker defender rating =
  let modified_strength =
    match rating with
    | SE -> attacker.strength * 2
    | Normal -> attacker.strength
    | NVE -> attacker.strength / 2
  in

  let raw_damage =
    modified_strength - defender.defense
  in

  if raw_damage < 0 then
    0
  else
    raw_damage

let damage attacker defender =
  let rating =
    effectiveness attacker.ty defender.ty
  in

  damage_with_rating attacker defender rating

let take_damage bokemon amount =
  let new_hp =
    bokemon.hp - amount
  in

  let final_hp =
    if new_hp < 0 then
      0
    else
      new_hp
  in

  {
    bokemon with
    hp = final_hp;
  }

let attack attacker defender =
  let amount =
    damage attacker defender
  in

  let updated_defender =
    take_damage defender amount
  in

  (amount, updated_defender)

let is_defeated bokemon =
  bokemon.hp <= 0
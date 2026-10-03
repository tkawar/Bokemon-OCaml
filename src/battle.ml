open Types

type attack_mode =
  | Regular
  | Pay2Win

let attack_cost mode =
  match mode with
  | Regular -> 10
  | Pay2Win -> 20

let attack_damage attacker defender mode =
  match mode with
  | Regular ->
      Combat.damage attacker defender

  | Pay2Win ->
      Combat.damage_with_rating attacker defender SE

let perform_attack player attacker defender mode =
  let cost =
    attack_cost mode
  in

  let player_after_payment =
    Player.spend_bbucks player cost
  in

  let amount =
    attack_damage attacker defender mode
  in

  let updated_defender =
    Combat.take_damage defender amount
  in

  let updated_player =
    if Combat.is_defeated updated_defender then
      Player.add_bbucks player_after_payment 1000
    else
      player_after_payment
  in

  (updated_player, updated_defender, amount)
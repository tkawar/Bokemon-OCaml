open Types

type bokemon_unlock = {
  required_level : int;
  bokemon : bmon;
}

let bokemon_unlocks =
  [
    {
      required_level = 5;
      bokemon = Bokemon_data.stormfin;
    };

    {
      required_level = 10;
      bokemon = Bokemon_data.pyrelion;
    };

    {
      required_level = 15;
      bokemon = Bokemon_data.ironbloom;
    };
  ]

let rec apply_bokemon_unlocks
    player
    unlocks =
  match unlocks with
  | [] ->
      (player, [])

  | unlock :: remaining ->
      let already_owned =
        Player.team_contains_name
          player.Player.team
          unlock.bokemon.name
      in

      if
        player.Player.trainer_level
        >= unlock.required_level
        &&
        not already_owned
      then
        let updated_player =
          Player.add_bokemon
            player
            unlock.bokemon
        in

        let final_player, later_unlocks =
          apply_bokemon_unlocks
            updated_player
            remaining
        in

        (
          final_player,
          unlock.bokemon :: later_unlocks
        )

      else
        apply_bokemon_unlocks
          player
          remaining

let apply_unlocks player =
  apply_bokemon_unlocks
    player
    bokemon_unlocks

let trainer_unlocked player trainer =
  player.Player.trainer_level
  >= trainer.Enemies.unlock_level

let rec owns_all_bokemon
    team
    required_bokemon =
  match required_bokemon with
  | [] ->
      true

  | bokemon :: remaining ->
      if
        Player.team_contains_name
          team
          bokemon.name
      then
        owns_all_bokemon
          team
          remaining
      else
        false

let championship_unlocked player =
  owns_all_bokemon
    player.Player.team
    Bokemon_data.all_bokemon

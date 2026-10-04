open Types

type battle_result =
  | Victory of Player.player * bmon
  | Defeat of Player.player * bmon
  | Quit of Player.player * bmon

let print_status player active enemy =
  print_endline "";
  print_endline "========================================";
  print_endline "                BATTLE";
  print_endline "========================================";

  Printf.printf
    "You:   %s [%s]\n"
    active.name
    (string_of_bty active.ty);

  Printf.printf
    "HP:    %d/%d\n"
    active.hp
    active.max_hp;

  print_endline "";

  Printf.printf
    "Enemy: %s [%s]\n"
    enemy.name
    (string_of_bty enemy.ty);

  Printf.printf
    "HP:    %d/%d\n"
    enemy.hp
    enemy.max_hp;

  print_endline "";
  Printf.printf "B-Bucks: %d\n" player.Player.bbucks;
  print_endline "========================================";
  print_endline "";
  print_endline "1. Attack          [10 B-Bucks]";
  print_endline "2. Pay2Win Attack  [20 B-Bucks]";
  print_endline "3. Switch Bokemon ";
  print_endline "4. Buy B-Bucks";
  print_endline "5. Quit Battle";
  print_endline "";
  print_string "> ";
  flush stdout

let difficulty_label active enemy =
  let difference =
    enemy.level - active.level
  in

  if difference >= 2 then
    "VERY HARD"
  else if difference = 1 then
    "HARD"
  else if difference = 0 then
    "EVEN"
  else if difference = -1 then
    "EASY"
  else
    "VERY EASY"

let rec bbucks_store player exit_after_purchase =
  Ui.clear_screen ();

  print_endline "========================================";
  print_endline "            B-BUCKS STORE";
  print_endline "========================================";
  print_endline "";

  Printf.printf
    "Current Balance: %d B-Bucks\n"
    player.Player.bbucks;

  print_endline "";
  print_endline "1. Tiny Sack       +100 B-Bucks";
  print_endline "2. Gamer Bundle    +500 B-Bucks";
  print_endline "3. Whale Package   +5000 B-Bucks";
  print_endline "4. Back";
  print_endline "";
  print_string "> ";
  flush stdout;

  match read_line () with
  | "1" ->
      let updated_player =
        Player.add_bbucks player 100
      in

      print_endline "";
      print_endline "Thank you for supporting Mintendo!";
      print_endline "+100 B-Bucks";

      Printf.printf
        "New Balance: %d B-Bucks\n"
        updated_player.Player.bbucks;

      Ui.pause ();
      if exit_after_purchase then 
        updated_player 
      else 
        bbucks_store updated_player false

  | "2" ->
      let updated_player =
        Player.add_bbucks player 500
      in

      print_endline "";
      print_endline "Thank you for supporting Mintendo!";
      print_endline "+500 B-Bucks";

      Printf.printf
        "New Balance: %d B-Bucks\n"
        updated_player.Player.bbucks;

      Ui.pause ();
      if exit_after_purchase then 
        updated_player 
      else 
        bbucks_store updated_player false

  | "3" ->
      let updated_player =
        Player.add_bbucks player 5000
      in

      print_endline "";
      print_endline "Whale status achieved.";
      print_endline "+5000 B-Bucks";

      Printf.printf
        "New Balance: %d B-Bucks\n"
        updated_player.Player.bbucks;

      Ui.pause ();
      if exit_after_purchase then 
        updated_player 
      else 
        bbucks_store updated_player false

  | "4" ->
      player

  | _ ->
      print_endline "Invalid choice.";
      Ui.pause ();
      bbucks_store player exit_after_purchase

let rec battle_loop player active enemy remaining_enemies =
  print_status player active enemy;

  match read_line () with
  | "1" ->
      player_attack
        player
        active
        enemy
        remaining_enemies
        Battle.Regular

  | "2" ->
      player_attack
        player
        active
        enemy
        remaining_enemies
        Battle.Pay2Win

  | "3" ->
      switch_bokemon
        player
        active
        enemy
        remaining_enemies

  | "4" ->
      let updated_player =
        bbucks_store player true 
      in

      battle_loop updated_player active enemy remaining_enemies


  | "5" ->
      let updated_player =
        Player.update_bokemon player active
      in

      Quit (updated_player, active)

  | _ ->
      print_endline "Invalid choice.";

      battle_loop
        player
        active
        enemy
        remaining_enemies

and player_attack
    player
    active
    enemy
    remaining_enemies
    mode =

  try
    let updated_player, updated_enemy, amount =
      Battle.perform_attack
        player
        active
        enemy
        mode
    in

    print_endline "";

    Printf.printf
      "%s attacks %s for %d damage!\n"
      active.name
      enemy.name
      amount;

    if Combat.is_defeated updated_enemy then
      let xp_gained =
        Progression.xp_reward
          active
          updated_enemy
      in

      let progressed_bokemon =
        Progression.add_xp
          active
          xp_gained
      in

      let player_with_progress =
        Player.update_bokemon
          updated_player
          progressed_bokemon
      in

      begin
        print_endline "";

        Printf.printf
          "%s was defeated!\n"
          updated_enemy.name;

        Printf.printf
          "%s gained %d XP!\n"
          progressed_bokemon.name
          xp_gained;

        if progressed_bokemon.level > active.level then
          Printf.printf
            "%s reached Level %d!\n"
            progressed_bokemon.name
            progressed_bokemon.level;

        match remaining_enemies with
        | next_enemy :: rest ->
            print_endline "";

            Printf.printf
              "The opposing trainer sends out %s!\n"
              next_enemy.name;

            Ui.pause ();

            battle_loop
              player_with_progress
              progressed_bokemon
              next_enemy
              rest

        | [] ->
            let winning_player =
              Player.add_bbucks
                player_with_progress
                1000
            in

            let winning_player =
              Player.add_win winning_player
            in

            print_endline "";
            print_endline "The opposing trainer has no Bokemon left!";
            print_endline "Victory!";
            print_endline "+1000 B-Bucks";

            Victory
              (winning_player, progressed_bokemon)
      end

    else
      enemy_turn
        updated_player
        active
        updated_enemy
        remaining_enemies

  with
  | Player.BuyMoreBBucks ->
      print_endline "";
      print_endline "Not enough B-Bucks!";
      print_endline "";
      print_endline "Redirecting you to the B-Bucks Store...";

      Ui.pause ();

      let updated_player = 
        bbucks_store player true
      in 

      battle_loop
        updated_player
        active
        enemy
        remaining_enemies

and enemy_turn
    player
    active
    enemy
    remaining_enemies =

  let amount, updated_active =
    Combat.attack enemy active
  in

  print_endline "";

  Printf.printf
    "%s attacks %s for %d damage!\n"
    enemy.name
    active.name
    amount;

  if Combat.is_defeated updated_active then
    let updated_player =
      Player.update_bokemon
        player
        updated_active
    in

    begin
      print_endline "";

      Printf.printf
        "%s was defeated!\n"
        updated_active.name;

      if Player.has_available_bokemon
           updated_player.Player.team
      then
        forced_switch
          updated_player
          updated_active
          enemy
          remaining_enemies
      else
        begin
          print_endline "";
          print_endline
            "All of your Bokemon have been defeated!";

          print_endline
            "You lost the battle.";

          Defeat
            (updated_player, updated_active)
        end
    end

  else
    battle_loop
      player
      updated_active
      enemy
      remaining_enemies

and switch_bokemon
    player
    active
    enemy
    remaining_enemies =

  let updated_player =
    Player.update_bokemon
      player
      active
  in

  Ui.clear_screen ();

  print_endline "========================================";
  print_endline "            SWITCH BOKEMON";
  print_endline "========================================";
  print_endline "";

  Printf.printf
    "Currently active: %s\n\n"
    active.name;

  Ui.print_bokemon_numbered
    updated_player.Player.team
    1;

  print_string "Choose a Bokemon: ";
  flush stdout;

  let input =
    read_line ()
  in

  match int_of_string_opt input with
  | None ->
      print_endline "Please enter a valid number.";
      Ui.pause ();

      switch_bokemon
        updated_player
        active
        enemy
        remaining_enemies

  | Some position ->
      begin
        match
          Player.bokemon_at_position
            updated_player.Player.team
            position
        with
        | None ->
            print_endline
              "That Bokemon does not exist.";

            Ui.pause ();

            switch_bokemon
              updated_player
              active
              enemy
              remaining_enemies

        | Some selected ->
            if selected.name = active.name then
              begin
                print_endline
                  "That Bokemon is already active.";

                Ui.pause ();

                switch_bokemon
                  updated_player
                  active
                  enemy
                  remaining_enemies
              end

            else if Combat.is_defeated selected then
              begin
                Printf.printf
                  "%s is defeated and cannot battle.\n"
                  selected.name;

                Ui.pause ();

                switch_bokemon
                  updated_player
                  active
                  enemy
                  remaining_enemies
              end

            else
              begin
                Printf.printf
                  "\n%s switches out!\n"
                  active.name;

                Printf.printf
                  "%s enters the battle!\n"
                  selected.name;

                enemy_turn
                  updated_player
                  selected
                  enemy
                  remaining_enemies
              end
      end

and forced_switch
    player
    defeated
    enemy
    remaining_enemies =

  Ui.clear_screen ();

  print_endline "========================================";
  print_endline "          CHOOSE NEXT BOKEMON";
  print_endline "========================================";
  print_endline "";

  Printf.printf
    "%s has been defeated!\n\n"
    defeated.name;

  Ui.print_bokemon_numbered
    player.Player.team
    1;

  print_string "Choose a Bokemon: ";
  flush stdout;

  let input =
    read_line ()
  in

  match int_of_string_opt input with
  | None ->
      print_endline "Please enter a valid number.";
      Ui.pause ();

      forced_switch
        player
        defeated
        enemy
        remaining_enemies

  | Some position ->
      begin
        match
          Player.bokemon_at_position
            player.Player.team
            position
        with
        | None ->
            print_endline
              "That Bokemon does not exist.";

            Ui.pause ();

            forced_switch
              player
              defeated
              enemy
              remaining_enemies

        | Some selected ->
            if Combat.is_defeated selected then
              begin
                Printf.printf
                  "%s is defeated and cannot battle.\n"
                  selected.name;

                Ui.pause ();

                forced_switch
                  player
                  defeated
                  enemy
                  remaining_enemies
              end
            else
              begin
                Printf.printf
                  "\n%s enters the battle!\n"
                  selected.name;

                Ui.pause ();

                battle_loop
                  player
                  selected
                  enemy
                  remaining_enemies
              end
      end

let start_battle player active trainer =
  match trainer.Enemies.team with
  | [] ->
      failwith "Enemy trainer has no Bokemon."

  | first_enemy :: remaining_enemies ->
      battle_loop
        player
        active
        first_enemy
        remaining_enemies

let rec choose_bokemon player =
  Ui.clear_screen ();

  print_endline "========================================";
  print_endline "          CHOOSE YOUR BOKEMON";
  print_endline "========================================";
  print_endline "";

  Ui.print_bokemon_numbered player.Player.team 1;

  print_string "Choose a Bokemon: ";
  flush stdout;

  let input =
    read_line ()
  in

  match int_of_string_opt input with
  | None ->
      print_endline "Please enter a valid number.";
      Ui.pause ();
      choose_bokemon player

  | Some position ->
      begin
        match
          Player.bokemon_at_position
            player.Player.team
            position
        with
        | None ->
            print_endline "That Bokemon does not exist.";
            Ui.pause ();
            choose_bokemon player

        | Some bokemon ->
            if Combat.is_defeated bokemon then
              begin
                Printf.printf
                  "%s is defeated and cannot battle.\n"
                  bokemon.name;

                Ui.pause ();
                choose_bokemon player
              end
            else
              bokemon
      end

let show_team player =
  Ui.clear_screen ();

  print_endline "========================================";
  print_endline "               YOUR TEAM";
  print_endline "========================================";
  print_endline "";

  Ui.print_bokemon_numbered player.Player.team 1;

  Ui.pause ()

let rec print_enemy_team active team =
  match team with
  | [] ->
      ()

  | (enemy : bmon) :: remaining ->
      Printf.printf
        "      %s [%s] | LVL %d | %s\n"
        enemy.name
        (string_of_bty enemy.ty)
        enemy.level
        (difficulty_label active enemy);

      print_enemy_team
        active
        remaining

let rec print_trainers active trainers number =
  match trainers with
  | [] ->
      ()

  | (trainer : Enemies.trainer) :: remaining ->
      Printf.printf
        "%d. %s\n"
        number
        trainer.trainer_name;

      print_enemy_team
        active
        trainer.team;

      print_endline "";

      print_trainers
        active
        remaining
        (number + 1)

let rec choose_trainer active =
  Ui.clear_screen ();

  print_endline "========================================";
  print_endline "          CHOOSE A TRAINER";
  print_endline "========================================";

  Printf.printf
    "Your Bokemon: %s | Level %d\n\n"
    active.name
    active.level;

  print_trainers
    active
    Enemies.trainers
    1;

  print_string "Choose a trainer: ";
  flush stdout;

  let input =
    read_line ()
  in

  match int_of_string_opt input with
  | None ->
      print_endline "Please enter a valid number.";
      Ui.pause ();
      choose_trainer active

  | Some position ->
      begin
        match
          Enemies.trainer_at_position
            Enemies.trainers
            position
        with
        | None ->
            print_endline
              "That trainer does not exist.";

            Ui.pause ();
            choose_trainer active

        | Some trainer ->
            trainer
      end

let rec heal_bokemon_menu player bokemon =
  Ui.show_healing_options bokemon;

  match read_line () with
  | "1" ->
      if bokemon.hp = bokemon.max_hp then
        begin
          print_endline "";
          print_endline "This Bokemon is already at full HP.";
          Ui.pause ();
          player
        end
      else
        begin
          try
            let updated_player =
              Player.spend_bbucks player 300
            in

            let healed_bokemon =
              Player.half_heal bokemon
            in

            let updated_player =
              Player.update_bokemon
                updated_player
                healed_bokemon
            in

            print_endline "";

            Printf.printf
              "%s was healed from %d/%d HP to %d/%d HP.\n"
              bokemon.name
              bokemon.hp
              bokemon.max_hp
              healed_bokemon.hp
              healed_bokemon.max_hp;

            print_endline "-300 B-Bucks";

            Printf.printf
              "Balance: %d B-Bucks\n"
              updated_player.Player.bbucks;

            Ui.pause ();
            updated_player

          with
          | Player.BuyMoreBBucks ->
              print_endline "";
              print_endline "Not enough B-Bucks!";
              print_endline "Half Heal costs 300 B-Bucks.";

              Printf.printf
                "Your balance: %d B-Bucks\n"
                player.Player.bbucks;

              Ui.pause ();
              player
        end

  | "2" ->
      if bokemon.hp = bokemon.max_hp then
        begin
          print_endline "";
          print_endline "This Bokemon is already at full HP.";
          Ui.pause ();
          player
        end
      else
        begin
          try
            let updated_player =
              Player.spend_bbucks player 500
            in

            let healed_bokemon =
              Player.full_heal bokemon
            in

            let updated_player =
              Player.update_bokemon
                updated_player
                healed_bokemon
            in

            print_endline "";

            Printf.printf
              "%s was fully healed from %d/%d HP to %d/%d HP.\n"
              bokemon.name
              bokemon.hp
              bokemon.max_hp
              healed_bokemon.hp
              healed_bokemon.max_hp;

            print_endline "-500 B-Bucks";

            Printf.printf
              "Balance: %d B-Bucks\n"
              updated_player.Player.bbucks;

            Ui.pause ();
            updated_player

          with
          | Player.BuyMoreBBucks ->
              print_endline "";
              print_endline "Not enough B-Bucks!";
              print_endline "Full Heal costs 500 B-Bucks.";

              Printf.printf
                "Your balance: %d B-Bucks\n"
                player.Player.bbucks;

              Ui.pause ();
              player
        end

  | "3" ->
      player

  | _ ->
      print_endline "Invalid choice.";
      Ui.pause ();
      heal_bokemon_menu player bokemon

let rec bokemon_center player =
  Ui.show_bokemon_center player;

  let input =
    read_line ()
  in

  match int_of_string_opt input with
  | None ->
      print_endline "Please enter a valid number.";
      Ui.pause ();
      bokemon_center player

  | Some 0 ->
      player

  | Some position ->
      begin
        match
          Player.bokemon_at_position
            player.Player.team
            position
        with
        | None ->
            print_endline "That Bokemon does not exist.";
            Ui.pause ();
            bokemon_center player

        | Some bokemon ->
            let updated_player =
              heal_bokemon_menu
                player
                bokemon
            in

            bokemon_center updated_player
      end

let rec main_menu player =
  Ui.show_main_menu player;

  match read_line () with
  | "1" ->
    let active_bokemon =
      choose_bokemon player
    in

    let trainer =
      choose_trainer active_bokemon
    in

    Ui.clear_screen ();

    Printf.printf
    "You challenged %s!\n"
    trainer.Enemies.trainer_name;

    Ui.pause ();

    let result =
      start_battle
        player
        active_bokemon
        trainer
    in

      begin
        match result with
        | Victory (updated_player, _) ->
            Ui.pause ();
            main_menu updated_player 

        | Defeat (updated_player, _) ->
            Ui.pause ();
            main_menu updated_player 

        | Quit (updated_player, _) ->
            main_menu updated_player 
      end

  | "2" ->
      show_team player;
      main_menu player 

  | "3" ->
      let updated_player = 
        bbucks_store player false
      in

      main_menu updated_player

  | "4" ->
      let updated_player =
        bokemon_center player 
      in
      
      main_menu updated_player 

  | "5" ->
      Ui.show_rules ();
      main_menu player 

  | "6" ->
      Ui.clear_screen ();
      print_endline "Thanks for playing Bokemon!"

  | _ ->
      main_menu player 




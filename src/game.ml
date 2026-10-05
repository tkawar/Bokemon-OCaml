open Types

type battle_rules = {
  victory_reward : int;
  count_win : bool;
}

type championship_result =
  | ChampionshipVictory of Player.player
  | ChampionshipDefeat of Player.player
  | ChampionshipQuit of Player.player

let regular_battle_rules =
  {
    victory_reward = 1000;
    count_win = true;
  }

let championship_stage_rules =
  {
    victory_reward = 0;
    count_win = false;
  }

let championship_final_rules =
  {
    victory_reward = 10000;
    count_win = true;
  }

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

let rec battle_loop player active enemy remaining_enemies rules =

  Ui.clear_screen ();

  print_status player active enemy;

  match read_line () with
  | "1" ->
      player_attack
        player
        active
        enemy
        remaining_enemies
        Battle.Regular
        rules

  | "2" ->
      player_attack
        player
        active
        enemy
        remaining_enemies
        Battle.Pay2Win
        rules

  | "3" ->
      switch_bokemon
        player
        active
        enemy
        remaining_enemies
        rules

  | "4" ->
      let updated_player =
        bbucks_store player true 
      in

      battle_loop updated_player active enemy remaining_enemies rules


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
        rules

and player_attack
    player
    active
    enemy
    remaining_enemies
    mode 
    rules =

  try
    let updated_player, updated_enemy, amount =
      Battle.perform_attack
        player
        active
        enemy
        mode
    in
    Ui.clear_screen ();

    print_endline "========================================";
    print_endline "              YOUR TURN";
    print_endline "========================================";
    print_endline "";

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
              rules

        | [] ->
            let winning_player =
                if rules.victory_reward > 0 then
                    Player.add_bbucks
                        player_with_progress
                        1000
                else 
                player_with_progress
            in

            let winning_player =
                if rules.count_win then 
                    Player.add_win winning_player
                else 
                    winning_player
            in

            print_endline "";
            print_endline "The opposing trainer has no Bokemon left!";
            print_endline "Victory!";
            if rules.victory_reward > 0 then 
                Printf.printf "+%d B-Bucks \n" rules.victory_reward;
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
            rules

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
        rules

and enemy_turn
    player
    active
    enemy
    remaining_enemies 
    rules =

  let amount, updated_active =
    Combat.attack enemy active
  in

  Ui.clear_screen ();

  print_endline "========================================";
  print_endline "              ENEMY TURN";
  print_endline "========================================";
  print_endline ""; 
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

      Ui.pause ();

      if Player.has_available_bokemon
           updated_player.Player.team
      then
        forced_switch
          updated_player
          updated_active
          enemy
          remaining_enemies
          rules
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
      rules

and switch_bokemon
    player
    active
    enemy
    remaining_enemies 
    rules =

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
        rules

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
              rules

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
                  rules
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
                  rules
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
                  rules
              end
      end

and forced_switch
    player
    defeated
    enemy
    remaining_enemies 
    rules =

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
        rules

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
              rules

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
                  rules
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
                  rules
              end
      end

let start_battle_with_rules
    player
    active
    trainer
    rules =

  match trainer.Enemies.team with
  | [] ->
      failwith "Enemy trainer has no Bokemon."

  | first_enemy :: remaining_enemies ->
      battle_loop
        player
        active
        first_enemy
        remaining_enemies
        rules

let start_battle player active trainer =
  start_battle_with_rules
    player
    active
    trainer
    regular_battle_rules

let rec championship_trainers
    player
    active
    trainers
    original_team =

  match trainers with
  | [] ->
      Ui.clear_screen ();

      print_endline "========================================";
      print_endline "              FINAL ROUND";
      print_endline "========================================";
      print_endline "";
      print_endline "Champion Cassian steps forward.";
      print_endline "";

      Ui.pause ();

      begin
        match
          start_battle_with_rules
            player
            active
            Enemies.champion
            championship_final_rules
        with
        | Victory (winning_player, _) ->
            ChampionshipVictory winning_player

        | Defeat (updated_player, _) ->
            let restored_player =
              Player.replace_team
                updated_player
                original_team
            in

            ChampionshipDefeat restored_player

        | Quit (updated_player, _) ->
            let restored_player =
              Player.replace_team
                updated_player
                original_team
            in

            ChampionshipQuit restored_player
      end

  | trainer :: remaining_trainers ->
      Ui.clear_screen ();

      Printf.printf
        "Next opponent: %s\n"
        trainer.Enemies.trainer_name;

      Ui.pause ();

      begin
        match
          start_battle_with_rules
            player
            active
            trainer
            championship_stage_rules
        with
        | Victory (updated_player, surviving_bokemon) ->
            championship_trainers
              updated_player
              surviving_bokemon
              remaining_trainers
              original_team

        | Defeat (updated_player, _) ->
            let restored_player =
              Player.replace_team
                updated_player
                original_team
            in

            ChampionshipDefeat restored_player

        | Quit (updated_player, _) ->
            let restored_player =
              Player.replace_team
                updated_player
                original_team
            in

            ChampionshipQuit restored_player
      end

let start_championship player active =
  let original_team =
    player.Player.team
  in

  championship_trainers
    player
    active
    Enemies.trainers
    original_team

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

let rec view_team player =
  Ui.show_team_menu player;

  let input =
    read_line ()
  in

  match int_of_string_opt input with
  | None ->
      print_endline "Please enter a valid number.";
      Ui.pause ();
      view_team player

  | Some 0 ->
      ()

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
            view_team player

        | Some bokemon ->
            Ui.show_bokemon_details bokemon;

            begin
              match read_line () with
              | "0" ->
                  view_team player

              | _ ->
                  view_team player
            end
      end

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

let rec print_trainers player active trainers number =
  match trainers with
  | [] ->
      ()

  | (trainer : Enemies.trainer) :: remaining ->
      if Unlocks.trainer_unlocked player trainer then
        begin
          Printf.printf
            "%d. %s [UNLOCKED]\n"
            number
            trainer.trainer_name;

          print_enemy_team
            active
            trainer.team;

          print_endline ""
        end
      else
        begin
          Printf.printf
            "%d. %s [LOCKED]\n"
            number
            trainer.trainer_name;

          Printf.printf
            "   Requires Trainer Level %d\n\n"
            trainer.unlock_level
        end;

      print_trainers
        player
        active
        remaining
        (number + 1)

let rec choose_trainer player active =
  Ui.clear_screen ();

  print_endline "========================================";
  print_endline "          CHOOSE A TRAINER";
  print_endline "========================================";

  Printf.printf
    "Your Bokemon: %s | Level %d\n\n"
    active.name
    active.level;

  print_trainers
    player
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
      choose_trainer player active

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
            choose_trainer player active

        | Some trainer ->
            if Unlocks.trainer_unlocked player trainer then
                trainer
            else
                begin
                    Printf.printf
                        "\n%s is locked.\n"
                        trainer.trainer_name;

                    Printf.printf
                        "Reach Trainer Level %d to challenge them.\n"
                        trainer.unlock_level;

                    Ui.pause ();

                    choose_trainer
                        player
                        active
                end
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
  Save.save_game player;
  Ui.show_main_menu player;

  match read_line () with
  | "1" ->
    let active_bokemon =
      choose_bokemon player
    in

    let trainer =
      choose_trainer player active_bokemon
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

            let old_level =
                updated_player.Player.trainer_level
                in

            let trainer_xp =
                trainer.Enemies.trainer_xp_reward
            in

            let progressed_player =
                Player.add_trainer_xp
                    updated_player
                    trainer_xp
            in

            let progressed_player, unlocked =
                Unlocks.apply_unlocks
                    progressed_player
            in

            Ui.show_trainer_progress
                old_level
                progressed_player
                trainer_xp
                unlocked;

            main_menu progressed_player


        | Defeat (updated_player, _) ->
            Ui.pause ();
            main_menu updated_player 

        | Quit (updated_player, _) ->
            main_menu updated_player 
      end

  | "2" ->
      view_team player;
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
    if not (Unlocks.championship_unlocked player) then
      begin
        print_endline "";
        print_endline "The Bokemon Championship is locked.";
        print_endline "Unlock every Bokemon to enter.";

        Ui.pause ();
        main_menu player
      end

    else if not (Ui.confirm_championship ()) then
      main_menu player

    else
      let active_bokemon =
        choose_bokemon player
      in

      begin
        match
          start_championship
            player
            active_bokemon
        with
        | ChampionshipVictory updated_player ->
            Ui.clear_screen ();

            print_endline "========================================";
            print_endline "         BOKEMON CHAMPION!";
            print_endline "========================================";
            print_endline "";
            print_endline "You defeated every trainer";
            print_endline "and Champion Cassian.";
            print_endline "";
            print_endline "+10,000 B-Bucks";
            print_endline "";

            Printf.printf
              "Final B-Bucks: %d\n"
              updated_player.Player.bbucks;

            Ui.pause ();

            main_menu updated_player

        | ChampionshipDefeat updated_player ->
            Ui.clear_screen ();

            print_endline "========================================";
            print_endline "       CHAMPIONSHIP FAILED";
            print_endline "========================================";
            print_endline "";
            print_endline "Your team has been restored.";
            print_endline "B-Bucks spent during the run remain spent.";

            Ui.pause ();

            main_menu updated_player

        | ChampionshipQuit updated_player ->
            Ui.clear_screen ();

            print_endline "Championship abandoned.";
            print_endline "Your team has been restored.";

            Ui.pause ();

            main_menu updated_player
      end

  | "6" ->
      Ui.show_rules ();
      main_menu player 

  | "7" ->
      Ui.clear_screen ();
      print_endline "Thanks for playing Bokemon!"

  | _ ->
      main_menu player 

let rec start () =
  let has_save =
    Save.save_exists ()
  in

  Ui.show_start_menu has_save;

  match read_line () with
  | "1" ->
      if has_save
         && not (Ui.confirm_new_game ())
      then
        start ()
      else
        begin
          let trainer_name =
            Ui.ask_trainer_name ()
          in

          let player =
            Player.create_player
              trainer_name
              Bokemon_data.starting_team
          in

          main_menu player
        end

  | "2" ->
      begin
        match Save.load_game () with
        | Some player ->
            main_menu player

        | None ->
            print_endline "";
            print_endline
              "No valid saved game was found.";

            Ui.pause ();
            start ()
      end

  | "3" ->
      Ui.clear_screen ();
      print_endline "Thanks for playing Bokemon!"

  | _ ->
      start ()




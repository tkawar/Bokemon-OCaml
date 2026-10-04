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
  print_endline "4. Quit Battle";
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

let rec print_enemy_roster active enemies number =
  match enemies with
  | [] ->
      ()

  | (enemy : bmon) :: remaining ->
      Printf.printf
        "%d. %s [%s] - Level %d\n"
        number
        enemy.name
        (string_of_bty enemy.ty)
        enemy.level;

      Printf.printf
        "   HP %d | STR %d | DEF %d | %s\n"
        enemy.max_hp
        enemy.strength
        enemy.defense
        (difficulty_label active enemy);

      print_endline "";

      print_enemy_roster
        active
        remaining
        (number + 1)

let rec battle_loop player active enemy =
  print_status player active enemy;

  match read_line () with
  | "1" ->
      player_attack player active enemy Battle.Regular

  | "2" ->
      player_attack player active enemy Battle.Pay2Win

  | "3" -> 
      switch_bokemon player active enemy

  | "4" ->
    let updated_player =
      Player.update_bokemon player active
    in

    Quit (updated_player, active)

  | _ ->
      print_endline "Invalid choice.";
      battle_loop player active enemy

and player_attack player active enemy mode =
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
            Progression.xp_reward active updated_enemy
        in 

        let progressed_bokemon =
            Progression.add_xp active xp_gained
        in

        let winning_player =
            Player.add_win updated_player
        in

        let winning_player =
            Player.update_bokemon winning_player progressed_bokemon
        in

        begin
            print_endline "";
            Printf.printf "%s was defeated!\n" updated_enemy.name;
            print_endline "Victory!";
            print_endline "+1000 B-Bucks";

            Printf.printf 
                "+%d XP for %s\n" 
                xp_gained
                progressed_bokemon.name;
            
            if progressed_bokemon.level > active.level then 
                Printf.printf
                    "%s reached Level %d!\n" 
                    progressed_bokemon.name
                    progressed_bokemon.level;

            Victory (winning_player, progressed_bokemon)
        end
    else
      enemy_turn updated_player active updated_enemy

  with
  | Player.BuyMoreBBucks ->
      print_endline "";
      print_endline "Not enough B-Bucks!";
      battle_loop player active enemy

and enemy_turn player active enemy =
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
        Player.update_bokemon player updated_active
    in

    begin
        print_endline "";
        Printf.printf "%s was defeated!\n" updated_active.name;
        print_endline "You lost the battle.";

        Defeat (updated_player, updated_active)
    end
  else
    battle_loop player updated_active enemy

and switch_bokemon player active enemy =
  let updated_player =
    Player.update_bokemon player active
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
      switch_bokemon updated_player active enemy

  | Some position ->
      begin
        match
          Player.bokemon_at_position
            updated_player.Player.team
            position
        with
        | None ->
            print_endline "That Bokemon does not exist.";
            Ui.pause ();
            switch_bokemon updated_player active enemy

        | Some selected ->
            if selected.name = active.name then
              begin
                print_endline "That Bokemon is already active.";
                Ui.pause ();
                switch_bokemon updated_player active enemy
              end

            else if Combat.is_defeated selected then
              begin
                Printf.printf
                  "%s is defeated and cannot battle.\n"
                  selected.name;

                Ui.pause ();
                switch_bokemon updated_player active enemy
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
              end
      end

let start_battle player active enemy =
  battle_loop player active enemy



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

let show_rules () =
  Ui.clear_screen ();

  print_endline "========================================";
  print_endline "             HOW TO PLAY";
  print_endline "========================================";
  print_endline "";

  print_endline "TYPE MATCHUPS";
  print_endline "";
  print_endline "Fire  > Grass";
  print_endline "Grass > Water";
  print_endline "Water > Fire";
  print_endline "";

  print_endline "Super Effective attacks deal double strength.";
  print_endline "Not Very Effective attacks use half strength.";
  print_endline "Defense is subtracted from attack damage.";
  print_endline "";

  print_endline "B-BUCKS";
  print_endline "";
  print_endline "Regular Attack:   10 B-Bucks";
  print_endline "Pay2Win Attack:   20 B-Bucks";
  print_endline "Victory Reward: +1000 B-Bucks";
  print_endline "";

  print_endline "PROGRESSION";
  print_endline "";
  print_endline "Defeat same level:      50% of next level";
  print_endline "Defeat 1 level higher:  75% of next level";
  print_endline "Defeat 2+ levels higher: 100% of next level";
  print_endline "Defeat 1 level lower:   25% of next level";
  print_endline "Defeat 2+ levels lower: 10% of next level";

  Ui.pause ()



let rec choose_enemy active =
  Ui.clear_screen ();

  print_endline "========================================";
  print_endline "           CHOOSE AN OPPONENT";
  print_endline "========================================";

  Printf.printf
    "Your Bokemon: %s | Level %d\n"
    active.name
    active.level;

  print_endline "";

  print_enemy_roster
    active
    Enemies.roster
    1;

  print_string "Choose an opponent: ";
  flush stdout;

  let input =
    read_line ()
  in

  match int_of_string_opt input with
  | None ->
      print_endline "Please enter a valid number.";
      Ui.pause ();
      choose_enemy active

  | Some position ->
      begin
        match
          Enemies.enemy_at_position
            Enemies.roster
            position
        with
        | None ->
            print_endline "That opponent does not exist.";
            Ui.pause ();
            choose_enemy active

        | Some enemy ->
            enemy
      end

let rec main_menu player =
  Ui.show_main_menu player;

  match read_line () with
  | "1" ->
    let active_bokemon =
      choose_bokemon player
    in

    let enemy =
      choose_enemy active_bokemon
    in

    Ui.clear_screen ();

    let result =
      start_battle
        player
        active_bokemon
        enemy
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
      show_rules ();
      main_menu player 

  | "4" ->
      Ui.clear_screen ();
      print_endline "Thanks for playing Bokemon!"

  | _ ->
      main_menu player 




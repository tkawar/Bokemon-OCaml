open Types

let clear_screen () =
  print_string "\027[2J\027[H";
  flush stdout

let pause () =
  print_endline "";
  print_endline "Press ENTER to continue...";
  ignore (read_line ())

let show_title () =
  print_endline "========================================";
  print_endline "               BOKEMON";
  print_endline "========================================"

let rec ask_trainer_name () =
  clear_screen ();

  print_endline "========================================";
  print_endline "               BOKEMON";
  print_endline "========================================";
  print_endline "";
  print_endline "Welcome, Trainer.";
  print_endline "";
  print_string "What is your name? ";
  flush stdout;

  let name =
    String.trim (read_line ())
  in

  if name = "" then
    begin
      print_endline "";
      print_endline "Your trainer name cannot be empty.";
      pause ();
      ask_trainer_name ()
    end
  else
    name

let show_main_menu player =
  clear_screen ();
  show_title ();

  Printf.printf
    "Trainer: %s\n"
    player.Player.name;

  Printf.printf
    "Trainer Level: %d     XP: %d/%d\n"
    player.Player.trainer_level
    player.Player.trainer_xp
    (Player.trainer_xp_required player);

  Printf.printf
    "B-Bucks: %d            "
    player.Player.bbucks;

  Printf.printf
    "Wins: %d\n"
    player.Player.wins;

  if Unlocks.championship_unlocked player then
    Printf.printf
        "Championship: UNLOCKED\n"
  else
    Printf.printf
        "Championship: LOCKED\n";

  print_endline "----------------------------------------";
  print_endline "1. Battle";
  print_endline "2. View Team";
  print_endline "3. Buy B-Bucks";
  print_endline "4. Bokemon Center";
  if Unlocks.championship_unlocked player then 
    print_endline "5. Bokemon Championship [UNLOCKED]"
  else 
    print_endline "5. Bokemon Championship [LOCKED]";
  print_endline "6. How to Play";
  print_endline "7. Quit";
  print_endline "----------------------------------------";
  print_string "> ";
  flush stdout

let rec print_bokemon_numbered bokemon_list number =
  match bokemon_list with
  | [] ->
      ()

  | (bokemon : bmon) :: remaining ->
      Printf.printf
        "%d. %s [%s]\n"
        number
        bokemon.name
        (string_of_bty bokemon.ty);

      Printf.printf
        "   HP %d/%d | LVL %d | XP %d/%d | STR %d | DEF %d\n"
        bokemon.hp
        bokemon.max_hp
        bokemon.level
        bokemon.xp
        (bokemon.level * 100)
        bokemon.strength
        bokemon.defense;

      print_endline "";

      print_bokemon_numbered
        remaining
        (number + 1)

let show_rules () =
  clear_screen ();

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
  print_endline "Defeat an entire trainer team: +1000 B-Bucks";
  print_endline "";
  print_endline "B-Bucks can be purchased from the main menu";
  print_endline "or directly during a battle.";
  print_endline "";

  print_endline "PROGRESSION";
  print_endline "";
  print_endline "Defeat same level:      50% of next level";
  print_endline "Defeat 1 level higher:  75% of next level";
  print_endline "Defeat 2+ levels higher: 100% of next level";
  print_endline "Defeat 1 level lower:   25% of next level";
  print_endline "Defeat 2+ levels lower: 10% of next level";

  pause ()

let show_bokemon_center player =
  clear_screen ();

  print_endline "========================================";
  print_endline "           BOKEMON CENTER";
  print_endline "========================================";
  print_endline "";

  Printf.printf
    "B-Bucks: %d\n\n"
    player.Player.bbucks;

  print_bokemon_numbered
    player.Player.team
    1;

  print_endline "0. Back";
  print_endline "";
  print_string "Choose a Bokemon: ";
  flush stdout

let show_healing_options bokemon =
  clear_screen ();

  print_endline "========================================";
  print_endline "              HEALING";
  print_endline "========================================";
  print_endline "";

  Printf.printf
    "%s [%s]\n"
    bokemon.name
    (string_of_bty bokemon.ty);

  Printf.printf
    "HP: %d/%d\n\n"
    bokemon.hp
    bokemon.max_hp;

  print_endline "1. Half Heal     300 B-Bucks";
  print_endline "   Adds 50% of maximum HP";
  print_endline "";
  print_endline "2. Full Heal     500 B-Bucks";
  print_endline "   Restores all HP";
  print_endline "";
  print_endline "3. Back";
  print_endline "";
  print_string "> ";
  flush stdout

let rec show_new_unlocks unlocked =
  match unlocked with
  | [] ->
      ()

  | (bokemon : bmon) :: remaining ->
      print_endline "";
      print_endline "========================================";
      print_endline "          NEW BOKEMON UNLOCKED";
      print_endline "========================================";
      print_endline "";

      Printf.printf
        "%s [%s]\n"
        bokemon.name
        (string_of_bty bokemon.ty);

      Printf.printf
        "Level %d | HP %d | STR %d | DEF %d\n"
        bokemon.level
        bokemon.max_hp
        bokemon.strength
        bokemon.defense;

      print_endline "";
      print_endline
        "This Bokemon has been added to your team.";

      show_new_unlocks remaining

let show_trainer_progress
    old_level
    player
    xp_gained
    unlocked =

  clear_screen ();

  print_endline "========================================";
  print_endline "          TRAINER PROGRESSION";
  print_endline "========================================";
  print_endline "";

  Printf.printf
    "+%d Trainer XP\n"
    xp_gained;

  print_endline "";

  Printf.printf
    "Trainer Level: %d\n"
    player.Player.trainer_level;

  Printf.printf
    "XP: %d/%d\n"
    player.Player.trainer_xp
    (Player.trainer_xp_required player);

  if player.Player.trainer_level > old_level then
    begin
      print_endline "";

      Printf.printf
        "Trainer Level Up! Level %d reached.\n"
        player.Player.trainer_level
    end;

    
    show_new_unlocks unlocked;

    if Unlocks.championship_unlocked player then
        begin
            print_endline "";
            print_endline "========================================";
            print_endline "       CHAMPIONSHIP UNLOCKED!";
            print_endline "========================================";
            print_endline "";
            print_endline
                "You have unlocked every Bokemon.";
            print_endline "";
            print_endline
                "The Bokemon Championship is now available."
        end;

    pause ()

let show_team_menu player =
  clear_screen ();

  print_endline "========================================";
  print_endline "               YOUR TEAM";
  print_endline "========================================";
  print_endline "";

  print_bokemon_numbered
    player.Player.team
    1;

  print_endline "0. Back";
  print_endline "";
  print_string "Choose a Bokemon to inspect: ";
  flush stdout

let show_bokemon_details bokemon =
  clear_screen ();

  let strong_against =
    Combat.super_effective_against bokemon.ty
  in

  let weak_against =
    Combat.not_very_effective_against bokemon.ty
  in

  let xp_needed =
    Progression.xp_required bokemon
  in

  let xp_remaining =
    xp_needed - bokemon.xp
  in

  print_endline "========================================";

  Printf.printf
    "               %s\n"
    (String.uppercase_ascii bokemon.name);

  print_endline "========================================";
  print_endline "";

  Printf.printf
    "Type:       %s\n"
    (string_of_bty bokemon.ty);

  Printf.printf
    "Level:      %d\n"
    bokemon.level;

  print_endline "";

  Printf.printf
    "HP:         %d/%d\n"
    bokemon.hp
    bokemon.max_hp;

  Printf.printf
    "XP:         %d/%d\n"
    bokemon.xp
    xp_needed;

  Printf.printf
    "XP Needed:  %d\n"
    xp_remaining;

  print_endline "";

  Printf.printf
    "Strength:   %d\n"
    bokemon.strength;

  Printf.printf
    "Defense:    %d\n"
    bokemon.defense;

  print_endline "";
  print_endline "----------------------------------------";
  print_endline "TYPE MATCHUPS";
  print_endline "----------------------------------------";
  print_endline "";

  Printf.printf
    "Super Effective Against:     %s\n"
    (string_of_bty strong_against);

  Printf.printf
    "Not Very Effective Against:  %s\n"
    (string_of_bty weak_against);

  Printf.printf
    "Normal Against:              %s\n"
    (string_of_bty bokemon.ty);

  print_endline "";
  print_endline "----------------------------------------";
  print_endline "0. Back";
  print_endline "----------------------------------------";
  print_string "> ";
  flush stdout

let rec confirm_championship () =
  clear_screen ();

  print_endline "========================================";
  print_endline "        BOKEMON CHAMPIONSHIP";
  print_endline "========================================";
  print_endline "";
  print_endline "This is the final challenge.";
  print_endline "";
  print_endline "You will fight every major trainer";
  print_endline "back-to-back before facing the Champion.";
  print_endline "";
  print_endline "Your HP carries between every battle.";
  print_endline "Defeated Bokemon remain defeated.";
  print_endline "The Bokemon Center is unavailable.";
  print_endline "The B-Bucks Store remains available.";
  print_endline "";
  print_endline "Winning the Championship rewards:";
  print_endline "10,000 B-Bucks";
  print_endline "";
  print_endline "1. Begin Championship";
  print_endline "2. Back";
  print_endline "";
  print_string "> ";
  flush stdout;

  match read_line () with
  | "1" ->
      true

  | "2" ->
      false

  | _ ->
      print_endline "Invalid choice.";
      pause ();
      confirm_championship ()

let show_start_menu has_save =
  clear_screen ();

  print_endline "========================================";
  print_endline "               BOKEMON";
  print_endline "========================================";
  print_endline "";

  print_endline "1. New Game";

  if has_save then
    print_endline "2. Continue"
  else
    print_endline "2. Continue [NO SAVE FOUND]";

  print_endline "3. Quit";
  print_endline "";
  print_string "> ";
  flush stdout

let rec confirm_new_game () =
  clear_screen ();

  print_endline "========================================";
  print_endline "              NEW GAME";
  print_endline "========================================";
  print_endline "";
  print_endline "A saved game already exists.";
  print_endline "Starting a new game will overwrite it.";
  print_endline "";
  print_endline "1. Start New Game";
  print_endline "2. Back";
  print_endline "";
  print_string "> ";
  flush stdout;

  match read_line () with
  | "1" ->
      true

  | "2" ->
      false

  | _ ->
      confirm_new_game ()





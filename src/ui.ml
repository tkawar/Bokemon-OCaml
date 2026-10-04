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

let show_main_menu player =
  clear_screen ();
  show_title ();

  Printf.printf
    "Trainer: %s\n"
    player.Player.name;

  Printf.printf
    "B-Bucks: %d\n"
    player.Player.bbucks;

  Printf.printf
    "Wins: %d\n"
    player.Player.wins;

  print_endline "----------------------------------------";
  print_endline "1. Battle";
  print_endline "2. View Team";
  print_endline "3. Buy B-Bucks";
  print_endline "4. Bokemon Center";
  print_endline "5. How to Play";
  print_endline "6. Quit";
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



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
  print_endline "3. How to Play";
  print_endline "4. Quit";
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
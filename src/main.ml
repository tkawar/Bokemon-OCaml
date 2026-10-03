open Types

let test_matchup attacker defender =
  let result = Combat.effectiveness attacker defender in

  Printf.printf
    "%s -> %s: %s\n"
    (string_of_bty attacker)
    (string_of_bty defender)
    (string_of_effectiveness result)

let () =
  print_endline "Bokemon effectiveness test:";
  print_endline "";

  test_matchup Fire Fire;
  test_matchup Fire Grass;
  test_matchup Fire Water;

  test_matchup Grass Fire;
  test_matchup Grass Grass;
  test_matchup Grass Water;

  test_matchup Water Fire;
  test_matchup Water Grass;
  test_matchup Water Water

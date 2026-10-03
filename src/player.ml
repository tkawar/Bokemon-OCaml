open Types

type player = {
  name : string;
  bbucks : int;
  team : bmon list;
  wins : int;
}

exception BuyMoreBBucks

let create_player name team =
  {
    name = name;
    bbucks = 100;
    team = team;
    wins = 0;
  }

let add_bbucks player amount =
  {
    player with
    bbucks = player.bbucks + amount;
  }

let spend_bbucks player amount =
  if player.bbucks < amount then
    raise BuyMoreBBucks
  else
    {
      player with
      bbucks = player.bbucks - amount;
    }

let add_win player =
  {
    player with
    wins = player.wins + 1;
  }
# Bokemon

Bokemon is a terminal-based monster-battling game written in OCaml.

Originally inspired by a McGill COMP 302 functional programming exercise, the project was expanded into a complete game with turn-based combat, progression, unlockable content, persistent saves, and a final Championship gauntlet.

A key constraint is that the game does not use `for` or `while` loops. Repeated behaviour is implemented using recursion and pattern matching.

## Running the Game

Requires OCaml 5.x.

Run:

```bash
make run
```

When finished:

```bash
make clean
```

No third-party OCaml libraries are required.

## Features

- Fire, Grass, and Water type matchups
- Team-based turn combat
- Bokemon XP and levelling
- Trainer XP and progression
- Unlockable trainers and Bokemon
- B-Bucks currency and healing
- Pay2Win attacks
- Persistent save/load
- Final Championship gauntlet
- Recursive game flow with no imperative loops

## Gameplay

You begin with three Bokemon:

- Flarecub, Fire
- Mossling, Grass
- Aquaphin, Water

Type effectiveness follows:

```text
Fire > Grass
Grass > Water
Water > Fire
```

Regular attacks cost **10 B-Bucks**.

Pay2Win attacks cost **20 B-Bucks** and force the attack to be Super Effective.

Defeating trainers earns B-Bucks and Trainer XP, while individual Bokemon gain XP and improve their stats as they level up.

## Progression

```text
Level 1   Rookie Nia
Level 3   Ranger Finn
Level 5   Stormfin
Level 7   Captain Jake
Level 10  Pyrelion
Level 12  Ace Mira
Level 14  Trainer Husam
Level 15  Ironbloom
```

Once every Bokemon is unlocked, the Championship becomes available.

## Championship

The final challenge is one continuous gauntlet:

```text
Rookie Nia
↓
Ranger Finn
↓
Captain Jake
↓
Ace Mira
↓
Trainer Husam
↓
Champion Cassian
```

HP carries between battles, defeated Bokemon remain defeated, and the Bokemon Center cannot be used between rounds.

Winning the Championship rewards **10,000 B-Bucks**.

## Project Structure

```text
src/
├── types.ml
├── bokemon_data.ml
├── combat.ml
├── player.ml
├── save.ml
├── battle.ml
├── progression.ml
├── enemies.ml
├── unlocks.ml
├── ui.ml
├── game.ml
└── main.ml
```

The codebase separates combat, player state, progression, persistence, enemies, unlocks, UI, and overall game flow into independent modules.

## Technical Focus

The project makes extensive use of:

- Recursion
- Pattern matching
- Algebraic data types
- Records
- Immutable updates
- Recursive list processing
- Modules
- Exceptions
- File persistence


## Status

Feature-complete.

Bokemon is an independent educational and portfolio project inspired by the monster-battling game genre. It is not affiliated with Nintendo, Game Freak, The Pokémon Company, or any related products or trademarks.

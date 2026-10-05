# Bokemon

Bokemon is a terminal-based monster-battling game written in OCaml.

It features turn-based combat, elemental matchups, Bokemon and trainer progression, an in-game currency system, unlockable content, persistent saves, and a final Championship gauntlet.

The project was built with a functional programming focus and intentionally avoids `for` and `while` loops, using recursion and pattern matching instead.

## Features

- Fire, Grass, and Water type matchups
- Team-based turn combat
- Bokemon XP and levelling
- Trainer XP and progression
- Unlockable trainers and Bokemon
- B-Bucks economy and healing system
- Persistent save/load
- Final Championship gauntlet
- No `for` or `while` loops

## Gameplay

You begin with:

- Flarecub, Fire
- Mossling, Grass
- Aquaphin, Water

Type effectiveness follows:

```text
Fire > Grass
Grass > Water
Water > Fire
```

Regular attacks cost 10 B-Bucks. Pay2Win attacks cost 20 B-Bucks and force a Super Effective attack.

Defeating trainers earns B-Bucks and Trainer XP, while individual Bokemon gain XP and improve their stats as they level up.

Progression unlocks stronger opponents and new Bokemon until the Championship becomes available.

## Championship

Once every Bokemon is unlocked, the player enters one continuous final gauntlet:

```text
Rookie Nia
↓
Ranger Finn
↓
Captain Mira
↓
Ace Layla
↓
Trainer Husam
↓
Champion Cassian
```

HP carries between battles, defeated Bokemon remain defeated, and there is no Bokemon Center between rounds.

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

The project separates combat, progression, persistence, UI, game data, and overall game flow into independent modules.

## Running

Requires OCaml 5.x.

```bash
make build
make run
```

To remove compiled files:

```bash
make clean
```

No third-party OCaml libraries are required.

## Technical Focus

Bokemon uses:

- Recursion
- Pattern matching
- Algebraic data types
- Records
- Immutable updates
- Recursive list processing
- Modules
- Exceptions
- File persistence

Menus, battles, progression, unlocks, and the Championship are implemented recursively without imperative loops.

## Status

Feature-complete.

Bokemon is an independent educational and portfolio project inspired by the monster-battling game genre and is not affiliated with Nintendo, Game Freak, or The Pokémon Company.

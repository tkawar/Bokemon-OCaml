# Bokemon-OCaml
Creating a fake Pokemon game called Bokemon. Enjoy!
Built based on an inspiration from a McGill COMP 302 Project.

requires Dune and OCaml to run
running instruction: 
dune build 
dune exec bokemon

# Bokemon

Bokemon is a terminal-based monster battling game written in OCaml.

The project is inspired by a functional programming exercise and has been expanded into a complete game featuring elemental combat, teams, B-Bucks, pay-to-win attacks, recursive menus, and a terminal user interface.

## Core Rules

Bokemon can have one of three elemental types:

- Fire
- Grass
- Water

Elemental effectiveness follows:

- Fire is super effective against Grass
- Grass is super effective against Water
- Water is super effective against Fire
- Attacks against the same type are Normal
- Attacks in the opposite direction are Not Very Effective

Damage is calculated using:

- Super Effective: strength × 2
- Normal: strength
- Not Very Effective: strength / 2
- Defender defense is then subtracted
- Damage cannot be less than 0

## B-Bucks

- Normal attack: 10 B-Bucks
- Pay2Win attack: 20 B-Bucks
- Pay2Win forces an attack to be Super Effective
- Defeating an enemy rewards 1000 B-Bucks

## Programming Constraint

The game does not use `for` loops or `while` loops.

Repeated behaviour is implemented using recursion and pattern matching.

## Project Structure

```text
src/      Core OCaml source code
data/     Game data
scripts/  Utility scripts
tests/    Automated tests
docs/     Documentation

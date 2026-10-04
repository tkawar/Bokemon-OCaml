build:
	ocamlc -I src  -o bokemon src/types.ml src/bokemon_data.ml src/combat.ml src/player.ml src/save.ml src/battle.ml src/progression.ml src/enemies.ml src/unlocks.ml src/ui.ml src/game.ml  src/main.ml 

run: build
	./bokemon

clean:
	rm -f bokemon
	rm -f src/*.cmi src/*.cmo

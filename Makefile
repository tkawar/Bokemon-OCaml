build:
	ocamlc -I src  -o bokemon src/types.ml src/combat.ml src/player.ml src/main.ml 

run: build
	./bokemon

clean:
	rm -f bokemon
	rm -f src/*.cmi src/*.cmo

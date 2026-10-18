all: build run clean

install:
	mkdir -p ~/.opam/default/lib/stublibs/
	cp -n images/dllcamlimages_png_stubs.so ~/.opam/default/lib/stublibs/

build: tp13.ml
	ocamlfind ocamlc -package camlimages -package camlimages.png -linkpkg tp13_outils.ml tp13.ml -o tp13 
#	ocamlc -I images images/*.cma tp13_outils.ml tp13.ml -o tp13
run: tp13
	./tp13

clean:
	rm -f *.cmi *.cmo

.PHONY: all install build run clean
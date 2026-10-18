CFLAGS=-Wall -pedantic -std=c99 -fsanitize=address

build: tp4.c utilitaire.c
	gcc $(CFLAGS) -o tp4.exe utilitaire.c tp4.c -lm

run: tp4.exe
	./tp4.exe

all: build run
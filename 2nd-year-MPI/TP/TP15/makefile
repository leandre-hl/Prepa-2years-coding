CFLAGS=-Wall -pedantic -std=c99 -fsanitize=address -O0

all: build run

build: TP15.c utils.c
	gcc $(CFLAGS) -o TP15 utils.c TP15.c

run: TP15
	./TP15
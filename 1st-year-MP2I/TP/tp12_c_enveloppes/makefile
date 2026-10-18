CFLAGS=-Wall -pedantic -std=c99
LDFLAGS=

.PHONY: all run clean mrproper

enveloppes.o: enveloppes.c
	gcc $(CFLAGS) -c enveloppes.c

ds: ds.o
	gcc $(LDFLAGS) -o enveloppes enveloppes.o

all: enveloppes

run: all
	./enveloppes

clean:
	rm -f *.o core

mrproper: clean
	rm -f enveloppes



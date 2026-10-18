#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "basic_ppm.h"

typedef void (*funcgen)(uint32_t, uint32_t*, int);

//*****************************************************************************
// Random generators

// gen_knuth : KNUTH, a=1664525, c=1013904223, m=2^32

void gen_knuth(uint32_t seed, uint32_t tab[], int n) {
    // A compléter
    int last = seed;
    uint64_t a = 1664525;
    int c = 1013904223;
    for (int i=0; i<n; ++i) {
        tab[i] = (a*last + c);
        last = tab[i];
    }
}

// gen_randu : RANDU, a = 65539, c=0, m=2^31

void gen_randu(uint32_t seed, uint32_t tab[], int n) {
    // A compléter
    int last = seed;
    uint64_t a = 65539;
    for (int i=0; i<n; ++i) {
        tab[i] = (a*last) % (1<<31);
        last = tab[i];
    }
}

// gen_minstd : STANDARD MINIMAL, a = 16807, c=0, m=2^31-1

void gen_minstd(uint32_t seed, uint32_t tab[], int n) {
    // A compléter
    int last = seed;
    uint64_t a = 16807;
    for (int i=0; i<n; ++i) {
        tab[i] = (a*last) % ((1U<<31) -1);
        last = tab[i];
    }
}

// gen_tmt : TinyMT32

void gen_tmt(uint32_t seed, uint32_t tab[], int n) {
    uint32_t a = 0xDEADBEEF, b = 0xDEADFACE, c = 0xABADCAFE, d = seed;
    for (int i=0; i<n; ++i) {
        uint32_t x = (a & 0x7FFFFFFF) ^ b ^ c;
        x ^= (x << 1);
        a = b;
        b = c;
        d ^= x ^ (d >> 1);
        c = x ^ (d << 10);
        if (d & 0x1) { b = b ^ 0x8F7011EE; c = c ^ 0xFC78FF1F; }
        uint32_t t1 = a + (c >> 8);
        uint32_t t0 = d ^ t1;
        if (t1 & 0x1) { t0 ^= 0x3793FDFF; }
        tab[i] = t0;
    }
}



//*****************************************************************************
// Auxilliary random functions

void gen_float(funcgen gen, uint32_t seed, double tab[], int n) {
    // A compléter*
    uint32_t* tabi = (uint32_t*)malloc(n* sizeof(uint32_t));
    gen(seed, tabi, n);
    for (int i=0; i<n; ++i) {
        tab[i] = (double)(tabi[i] % (1U<<31))/ (1U<<31);
    }
}

uint32_t extrait(uint32_t n, int i, int p) {
    return (n>>i) & ((1U<<p)-1);
}

//*****************************************************************************
// Test functions

// Display first N values of a given generator

void disp(funcgen gen, uint32_t seed, int n) {
    uint32_t* tabi = (uint32_t*)malloc(n * sizeof(uint32_t));
    gen(seed, tabi, n);
    printf("%d premiers entier pour la graine %u :\n", n, seed);
    for (int i=0; i<n; ++i) {
        printf("%u\n", tabi[i]);
    }
}

// Build statistics of lowest byte

void stats(funcgen gen, uint32_t seed, int n) {
    int count[256] = { 0 };
    // A compléter
    uint32_t* tab = (uint32_t*)malloc(n * sizeof(uint32_t));
    gen(seed, tab, n);
    for(int i=0; i<n; i++) {
        count[extrait(tab[i], 23, 8)%256]++;
    }
    // Tracé de l'histogramme
    int max = 0;
    for (int i=0; i<256; ++i) {
        if (count[i]>max) { max = count[i]; }
    }
    init(120, 256, black);
    for (int i=0; i<256; ++i) {
        int h = count[i]*100/max;
        for (int j=0; j<h; ++j) {
            set_pixel_color(119-j, i, blue);
        }
    }
    write("stats.ppm");
    free(tab);
}

// Test consecutive (float) values

void draw2D(funcgen gen, uint32_t seed, int n) {
    // A completer
    double* tab = (double*)malloc(2*n*sizeof(double));
    gen_float(gen, seed, tab, 2*n);
    init(500, 500, black);
    for (int i=0; i<n; ++i) {
        int col = 499*tab[2*i];
        int lgn = 499*tab[2*i + 1]; // A modifier
        set_pixel_color(lgn, col, yellow);
    }
    write("plot2D.ppm");
}

// Test consecutive (float) values, 3 by 3

void draw3D(funcgen gen, uint32_t seed, int n) {
    // A completer

    double* tab = (double*)malloc(2*n*sizeof(double));
    gen_float(gen, seed, tab, 2*n);
    init(500, 500, black);
    for (int i=0; i<n; ++i) {
        int col = 499*tab[2*i];
        int lgn = 499*tab[2*i + 1]; // A modifier
        set_pixel_color(lgn, col, yellow);
    }
    write("plot2D.ppm");
}

//*****************************************************************************
// DieHard tests

// OPSO

void test_OPSO(funcgen gen, uint32_t seed) {
    int nb = 0x200001;;
    uint32_t* tab = (uint32_t*)malloc(nb * sizeof(uint32_t));
    gen(seed, tab, nb);

    // A completer
}

// Parking

void test_parking(funcgen gen, uint32_t seed) {
    int nb = 528000;;
    double* tab = (double*)malloc(nb * sizeof(double));
    gen_float(gen, seed, tab, nb);

    // A completer
}

// Rangs

int rang(uint32_t matr[]) {
    return 0; // A modifier
}

void test_rang(funcgen gen, uint32_t seed) {
    int nb = 1240000;;
    uint32_t* tab = (uint32_t*)malloc(nb * sizeof(uint32_t));
    gen(seed, tab, nb);

    // A completer
}

//*****************************************************************************
// Main program

int main(int argc, char* argv[]) {
    draw2D(gen_minstd, 34, 20000);
    return 0;
}


#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>
#include "dicts.h"



struct TTT {
    int n;
    int k;
    int* grille;
};
 
typedef struct TTT ttt;

void liberer_jeu(ttt jeu) {
    free(jeu.grille);
}

ttt init_jeu(int k, int n){
    ttt jeu;
    jeu.k = k;
    jeu.n = n;
    jeu.grille = malloc(n*n*sizeof(*jeu.grille));
    for (int i= 0; i<n*n ; i++) jeu.grille[i] = 0;
    return jeu;
}

int* repartition(ttt jeu){
    int counts[3] = {0,0,0};
    for (int i=0; i<jeu.n*jeu.n; i++) {
        assert (jeu.grille[i] <= 2);
        counts[jeu.grille[i]]++;
    }
    int* tab = malloc(jeu.n*jeu.n*sizeof(*tab));
    for (int i =0; i<jeu.n*jeu.n; i++) {
        tab[i] = counts[jeu.grille[i]];;
    }
    return tab;
}

int joueur_courant(ttt jeu){
    int count = 0;
    for (int i=0; i<jeu.n*jeu.n; i++) {
        if (jeu.grille[i] != 0) count++;
    }
    if (count >= jeu.n*jeu.n) return 0;
    return count % 2 + 1;
}

void jouer_coup(ttt jeu, int lgn, int cln){
    int i = lgn*jeu.n+cln;
    assert (jeu.grille[i] == 0);
    jeu.grille[i] = joueur_courant(jeu);
}

bool alignement(ttt jeu, int i, int di, int joueur){
    int dc, dl;
    if (di >= 0) {
        dc = di % jeu.n;
        dl = di / jeu.n;
    }
    else { // di = 1-n
        dc = 1;
        dl = -1;
    }

    if (i%jeu.n + dc*(jeu.k-1) < 0 || i%jeu.n + dc*(jeu.k-1) >= jeu.n) return false;
    if (i/jeu.n + dl*(jeu.k-1) < 0 || i/jeu.n + dl*(jeu.k-1) >= jeu.n) return false;

    for (int step=0; step < jeu.k; step++) {
        if (jeu.grille[i + step*di] != joueur) return false;
    }
    return true;
}

bool gagnant(ttt jeu, int joueur){
    int di[4] = {1, jeu.n, jeu.n+1, -jeu.n+1};
    for (int d = 0; d<4; d++) {
        for (int i = 0; i< jeu.n*jeu.n; i++) {
            if (alignement(jeu, i, di[d], joueur)) return true;
        }
    }
    return false;
}


int encodage(ttt jeu){
    int code = 0;
    for (int i=jeu.n*jeu.n-1; i>=0; i--) {
        code= 3*code + jeu.grille[i];
    }
    return code;
}

int attracteur(ttt jeu, dict* D) {
    int code = encodage(jeu);
    int j = joueur_courant(jeu);
    if (j==0) return 0;
    if (member(*D, code)) return get(*D, code);
    if (gagnant(jeu, 1)) {
        add(D, code, 1);
        return 1;
    }
    if (gagnant(jeu, 2)) {
        add(D, code, 2);
        return 2;
    }
    for (int i=0; i<jeu.n*jeu.n; i++) {
        if (jeu.grille[i] == 0) {
            jouer_coup(jeu, i/jeu.n, i%jeu.n);
            if (attracteur(jeu, D) == j) {
                add(D, code, j);
                jeu.grille[i] = 0;
                return j;
            }
            jeu.grille[i] = 0;
        }
    }
    add(D, code, 3-j);
    return 3-j;
}

int strategie_optimale(ttt jeu, dict* D) {
    int code = encodage(jeu);
    int att = attracteur(jeu, D);
    int pow = 1;
    for (int i=0; i<jeu.n*jeu.n; i++, pow*=2) {
        if (jeu.grille[i] == 0 && get(*D, code+pow) == att) {
            return 
        }
    }
}

void afficher(ttt jeu){
    char symboles[3] = {' ', 'X', 'O'};

    printf(" "); for (int c = 0; c<jeu.n; c++) printf(" %d", c); printf("\n");
    for (int l = 0; l<jeu.n; l++) {
        printf(" "); for (int c = 0; c<jeu.n; c++) printf("+-"); printf("+\n");

        printf("%d", l);
        for (int c = 0; c<jeu.n; c++) {
            int i = l*jeu.n + c;
            printf("|%c", symboles[jeu.grille[i]]);
        }
        printf("|\n");
    }
    printf(" "); for (int c = 0; c<jeu.n; c++) printf("+-"); printf("+\n");
}

void jouer_partie(int k, int n){
    return;
}

int main(void){
    ttt jeu = init_jeu(3, 3);
    dict D = create();
    printf("Attracteur : %d\n", attracteur(jeu, &D));
    jouer_coup(jeu, 2, 2);
    printf("Attracteur : %d\n", attracteur(jeu, &D));
    jouer_coup(jeu, 0, 1);
    printf("Attracteur : %d\n", attracteur(jeu, &D));
    jouer_coup(jeu, 1, 0);
    printf("Attracteur : %d\n", attracteur(jeu, &D));
    jouer_coup(jeu, 2, 0);
    printf("Attracteur : %d\n", attracteur(jeu, &D));
    jouer_coup(jeu, 0, 0);
    afficher(jeu);
    printf("Attracteur : %d\n", attracteur(jeu, &D));
    jouer_coup(jeu, 1, 2);
    afficher(jeu);
    printf("gagnant 1 : %d / 2 : %d\n", gagnant(jeu, 1), gagnant(jeu, 2));
    printf("Attracteur : %d\n", attracteur(jeu, &D));
    jouer_coup(jeu, 1, 1);
    afficher(jeu);
    printf("gagnant 1 : %d / 2 : %d\n", gagnant(jeu, 1), gagnant(jeu, 2));
    printf("Attracteur : %d\n", attracteur(jeu, &D));
    liberer_jeu(jeu);
    dict_free(D);
}
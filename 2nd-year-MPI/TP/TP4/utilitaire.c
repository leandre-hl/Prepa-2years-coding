#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <math.h>
#include <limits.h>

#include "utilitaire.h"

static unsigned long int next = 1;

int rand(void){
    // Renvoie un entier selon une suite pseudo-aléatoire.
    next = next * 1103515245 + 12345;
    return (unsigned int)(next/65536) % 2147483647;
}

void srand(unsigned int seed){
    // Permet d'initialiser la graine du générateur pseudo-aléatoire.
    next = seed;
}

liste* cons(int tete, liste* queue){
    // Construit une nouvelle liste en prenant en argument une tête
    // (un entier) et une queue (une autre liste).
    liste* lst = malloc(sizeof(liste));
    lst->val = tete;
    lst->succ = queue;
    return lst;
}

void liberer_liste(liste* lst){
    // Libère la mémoire occupée par une liste.
    if (lst != NULL){
        liberer_liste(lst->succ);        
        free(lst);
    }
}

void afficher_liste(liste* lst){
    // Affiche les éléments d'une liste.
    printf("[");
    while (lst != NULL){
        printf("%d ", lst->val);
        lst = lst->succ;
    }
    printf("]\n");
}

void afficher_tab(int* tab, int n){
    // Affiche un tableau d'entiers.
    printf("{");
    for (int i=0; i<n - 1; i++) printf("%d, ", tab[i]);
    if (n > 0) printf("%d", tab[n - 1]);
    printf("}\n");
}

graphe creer_graphe(int n){
    // Crée un graphe sans arête étant donné |S|.
    liste** adj = malloc((n) * sizeof(liste*));
    for (int s=0; s<n; s++) adj[s] = NULL;
    graphe G = {.n = n, .adj = adj};
    return G;
}

void liberer_graphe(graphe G){
    // Libère la mémoire occupée par le tableau de listes d'adjacence
    // d'un graphe.
    for (int s=0; s<G.n; s++) liberer_liste(G.adj[s]);
    free(G.adj);
}

void ajouter_arete(graphe G, int s, int t){
    // Ajoute une arête dans un graphe non orienté.
    G.adj[s] = cons(t, G.adj[s]);
    G.adj[t] = cons(s, G.adj[t]);
}

graphe generer_biparti(int n, int p, int deg_max, int graine){
    // Crée un graphe biparti aléatoirement, étant donné |X|, 
    // |Y|, le degré maximal d'un sommet de X et une graine.
    srand(graine);
    graphe G = creer_graphe(n + p);
    int* tab = malloc(p * sizeof(int));
    for (int i=0; i<p; i++) tab[i] = n + i;
    for (int s=0; s<n; s++){
        int deg = rand() % (deg_max + 1);
        for (int i=0; i<deg; i++){
            int j = rand() % (p - i);
            int t = tab[j];
            tab[j] = tab[p - i - 1];
            tab[p - i - 1] = t;
            ajouter_arete(G, s, t);
        }
    }
    free(tab);
    return G;
}

double chronometre(int* f(graphe), graphe arg){
    // Renvoie le temps d'exécution en secondes pour calculer f(arg),
    // f étant une fonction qui prend en argument un graphe et renvoie
    // un tableau d'entiers.
    struct timeval start, stop;
    gettimeofday(&start, NULL);
    int* tab = f(arg); 
    gettimeofday(&stop, NULL);
    free(tab);
    return (stop.tv_sec - start.tv_sec) + 1e-6 * (stop.tv_usec - start.tv_usec);
}
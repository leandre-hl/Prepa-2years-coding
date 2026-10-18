#include <stdlib.h>
#include <stdio.h>
#include <sys/time.h>
#include <stdbool.h>

#include "utils.h"

void afficher_tab(int* tab, int n){
    // Affiche les 20 premiers éléments d'un tableau d'entiers
    if (n > 20) {n = 20;}
    printf("[");
    for (int i=0; i<n-1; i++){
        printf("%d, ", tab[i]);
    }
    if (n>0){
        printf("%d", tab[n-1]);
    }
    printf("]\n");
}

int* tab_alea(int n){
    // Renvoie un tableau d'entiers aléatoires entre 0 et 99999
    int* tab = malloc(n * sizeof(int));
    for (int i=0; i<n; i++){
        tab[i] = rand() % 100000;
    }
    return tab;
}

void swap(int* tab, int i, int j){
    // Échange les valeurs de deux éléments d'un tableau
    int tmp = tab[i];
    tab[i] = tab[j];
    tab[j] = tmp;
}

double chronometre(void* f(void*), void* arg){
    // Renvoie le temps d'exécution en secondes pour calculer f(arg)
    struct timeval start, stop;
    gettimeofday(&start, NULL);
    f(arg); 
    gettimeofday(&stop, NULL);
    return (stop.tv_sec - start.tv_sec) + 1e-6 * (stop.tv_usec - start.tv_usec);
}

void deverrouiller(mutex* m, int i) {
    m->attente[i] = false;
}

void verrouiller(mutex* m, int i) {
    m->attente[i] = true;
    m->tour = 1 - i;
    while (m->tour != i && m->attente[1-i]) {}
}

file* creer_file(void){
    file *f = malloc(sizeof(f));
    f->premier = NULL;
    f->dernier = NULL;
    f->taille_max = 0;
    pthread_mutex_init(&f->verrou, NULL);
    return f;
}

void liberer_maillon(maillon* maillon) {
    if (maillon==NULL) return;
    liberer_maillon(maillon->suivant);
    free(maillon);
}

void liberer_file(file* f) {
    liberer_maillon(f->premier);
    pthread_mutex_destroy(&f->verrou);
    free(f);
}

void enfiler(file* f, tranche tr){    
    maillon* maillon = malloc(sizeof(*maillon));
    
}

bool defiler(file* f, tranche* tr){
    // À modifier
    return true;    
}
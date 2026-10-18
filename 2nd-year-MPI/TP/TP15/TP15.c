#include <stdio.h>
#include <pthread.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdlib.h>

#include "utils.h"

#define SEUIL_TRI 16
#define NB_FILS 4

int N = 10000000;
int cpt = 0;

pthread_mutex_t verrou;

void* incrementer1(void* arg){
    for(int k = 0; k<N; k++) {
        cpt++;
    }
    return NULL;
}

pthread_mutex_t verrou;

void* incrementer2(void* arg){
    for(int k = 0; k<N; k++) {
        pthread_mutex_lock(&verrou);
        cpt++;
        pthread_mutex_unlock(&verrou);
    }
    return NULL;
}

mutex m = {.attente[0] = false, .attente[1] = false, .tour = 0};


void* incrementer3(void* arg){
    int i = *(int*) arg; 
    for(int k = 0; k<N; k++) {
        verrouiller(&m, i);
        cpt++;
        deverrouiller(&m, i);
    }
    return NULL;
}

void* tri_insertion(void* arg){
    tranche t = *(tranche*) arg;
    for (int i = 1; i < t.taille; i++) {
        int j = i;
        while (j>0 && t.debut[j-1] > t.debut[j]) {
            swap(t.debut, j-1, j);
            j--;
        }
    }
    return NULL;
}

int partition(tranche tr){
    int i = 0;
    int j = tr.taille;
    // Invariant de boucle : le pivot est en 0, les [1, i] sont <= piv, les [j, t.taille[ sont > piv
    while (i < j - 1) {
        if (tr.debut[i+1] > tr.debut[0]) {
            j--;
            swap(tr.debut, i+1, j);
        }
        else {
            i++;
        }
    }
    swap(tr.debut, 0, i);
    return i;
}

void* tri_rapide1(void* arg){
    tranche tr = *(tranche*) arg;
    if (tr.taille < SEUIL_TRI) tri_insertion(arg);
    else {    
        int piv = partition(tr);
        
        tranche tr1 = {.debut = tr.debut, .taille = piv};
        tri_rapide1(&tr1);
        
        tranche tr2 = {.debut = &tr.debut[piv+1], .taille = tr.taille - piv - 1};
        tri_rapide1(&tr2);
    }

    return NULL;
}

void traiter_tranche(file* f, tranche tr){
    // À modifier
}

void* traitement(void* arg){
    // À modifier
    return NULL;
}

void* tri_rapide2(void* arg){
    // À modifier
    return NULL;
}

int main(void){
    srand(time(0)); // Pour avoir des tirages aléatoires distincts à chaque exécution
    
    /*
    pthread_t f1, f2;
    int arg1 = 0;
    int arg2 = 1; 
    pthread_create(&f1, NULL, incrementer1, &arg1);
    pthread_create(&f2, NULL, incrementer1, &arg2);
    pthread_join(f1, NULL);
    pthread_join(f2, NULL);

    printf("cpt apres incrementer1 : %d\n", cpt);
    
    cpt = 0;
    pthread_mutex_init (&verrou, NULL);
    pthread_create(&f1, NULL, incrementer2, &arg1);
    pthread_create(&f2, NULL, incrementer2, &arg2);
    pthread_join(f1, NULL);
    pthread_join(f2, NULL);
    pthread_mutex_destroy(&verrou);
    
    printf("cpt apres incrementer2 : %d\n", cpt);
    
    cpt = 0;
    pthread_create(&f1, NULL, incrementer3, &arg1);
    pthread_create(&f2, NULL, incrementer3, &arg2);
    pthread_join(f1, NULL);
    pthread_join(f2, NULL);
    
    printf("cpt apres incrementer3 : %d\n", cpt);
    */

    int n = 1000;
    tranche tr1 = {.debut = tab_alea(n), .taille = n};
    printf("Temps insersion : %lf\n", chronometre(tri_insertion, &tr1));
    free(tr1.debut);

    tr1.debut = tab_alea(n);
    printf("Temps qsort : %lf\n", chronometre(tri_rapide1, &tr1));
    free(tr1.debut);

    n = 10000;
    tranche tr2 = {.debut = tab_alea(n), .taille = n};
    printf("Temps insersion : %lf\n", chronometre(tri_insertion, &tr2));
    free(tr2.debut);

    tr2.debut = tab_alea(n);
    printf("Temps qsort : %lf\n", chronometre(tri_rapide1, &tr2));
    free(tr2.debut);
    
    return 0;
}
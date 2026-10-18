#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>

#include "utilitaire.h"

int* creer_tab(int k, int val){
    int* tab = malloc(k*sizeof(*tab));
    for (int i=0; i<k; i++) {
        tab[i] = val;
    }
    return tab;
}

int cardinal_couplage(graphe G, int* C){
    int count = 0;
    for (int i=0; i<G.n; i++) {
        if (C[i] != -1) count++;
    }
    return count/2;
}

void dfs(graphe G, int* access, int t) {
    for (liste* voisin = G.adj[t]; voisin != NULL; voisin = voisin->succ) {
        if (access[voisin->val] == -2) {
            access[voisin->val] = t;
            dfs(G, access, voisin->val);
        }
    }
}

int* accessibles(graphe G, int s){
    int* access = creer_tab(G.n, -2);
    access[s] = -1;
    dfs(G, access, s);
    return access;
}

int calcul_nX(graphe G){
    int x = 0;
    for (; x<G.n && (G.adj[x] == NULL || G.adj[x]->val > x); x++) {}
    return x;
}

graphe graphe_augmentation(graphe G, int nX, int* C){
    graphe GA = {.n=G.n + 2, .adj=NULL};
    GA.adj = malloc(GA.n*sizeof(*GA.adj));
    for (int i=0; i<GA.n; i++) GA.adj[i] = NULL;
    int s = G.n;
    int t = G.n + 1;
    for (int i=0; i<nX; i++) {
        for (liste* voisin = G.adj[i]; voisin != NULL; voisin = voisin->succ) {
            int j = voisin->val;
            if (C[i] != j) {
                GA.adj[i] = cons(j, GA.adj[i]);
            }
            else {
                GA.adj[j] = cons(i, GA.adj[j]);
            }
        }
    }
    for (int i=0; i<G.n; i++) {
        if (i<nX && C[i] == -1) GA.adj[s] = cons(i, GA.adj[s]);
        else if (i>=nX && C[i] == -1) GA.adj[i] = cons(t, GA.adj[i]);
    }
    return GA;
}

liste* constuire_chemin(int* pre, int t, liste* acc) {
    if (pre[t]==-1) return acc;
    return constuire_chemin(pre, pre[t], cons(t, acc));
}

liste* chemin_augmentant(graphe G, int nX, int* C){
    graphe GA = graphe_augmentation(G, nX, C);
    int s = G.n;
    int t = s + 1;
    int* pre = accessibles(GA, s);
    liste* chemin = NULL;
    if (pre[t] >= 0) {
        chemin = constuire_chemin(pre, pre[t], NULL); // On retire t
    }
    liberer_graphe(GA);
    free(pre);
    return chemin;
}

void augmenter(int* C, liste* sigma){
    for (liste* maillon = sigma; maillon != NULL; maillon = maillon->succ->succ) {
        int s = maillon->val;
        int t = maillon->succ->val;
        C[s] = t;
        C[t] = s;
    }
}

int* couplage_maximum(graphe G){
    int* C = creer_tab(G.n, -1);
    int nX = calcul_nX(G);
    liste* sigma = chemin_augmentant(G, nX, C);
    while (sigma != NULL) {
        augmenter(C, sigma);
        liberer_liste(sigma);
        sigma = chemin_augmentant(G, nX, C);
    }
    return C;
}

int* bfs_alternant(graphe G, int nX, int* C, int* dist){
    for (int i=0; i<G.n; i++) {
        dist[i] = -1;
    }
    
    int* ordre_bfs = creer_tab(G.n, -1);
    int d = 0;
    int f = 0;
    for (int i=0; i<nX; i++) {
        if (C[i] == -1) {
            ordre_bfs[f] = i;
            dist[i] = 0;
            f++;
        }
    }

    while (d < f) {
        int s = ordre_bfs[d];
        if (s<nX) { // s est dans X
            for (liste* voisin = G.adj[s]; voisin != NULL; voisin = voisin->succ) {
                int t = voisin->val;
                if (dist[t] == -1 && C[s] != t) {
                    if (f >= G.n) { free(ordre_bfs); return NULL; }
                    dist[t] = dist[s] + 1;
                    ordre_bfs[f] = t;
                    f++;
                }
            }
        }
        else { // s est dans Y
            int t = C[s];
            if (t != -1 && dist[t] == -1) {
                if (f >= G.n) { free(ordre_bfs); return NULL; }
                dist[t] = dist[s] + 1;
                ordre_bfs[f] = t;
                f++;
            }
        }
        d++;
    }

    return ordre_bfs;
}

liste* dfs_alternant(graphe G, int nX, int* C, int* dist, bool* vus, int y){
    if (vus[y]) return NULL;

    vus[y] = true;
    if (y < nX && C[y] == -1 && dist[y] == 0) return cons(y, NULL);

    for (liste* voisin = G.adj[y]; voisin != NULL; voisin = voisin->succ) {
        int x = voisin->val;
        if (dist[x] == dist[y] - 1 && !vus[x]) {
            if (y < nX) {
                if (C[x] != y) continue;
            } else {
                if (C[x] == y) continue;
            }
            liste* l = dfs_alternant(G, nX, C, dist, vus, x);
            if (l!=NULL) return cons(y, l);
        }
    }
    return NULL;
}

int* hopcroft_karp(graphe G){
    int* C = creer_tab(G.n, -1);
    int nX = calcul_nX(G);

    bool existe_augmentant = true;
    while (existe_augmentant) {
        existe_augmentant = false;

        int* dist = creer_tab(G.n, -1);
        int* ordre_bfs = bfs_alternant(G, nX, C, dist);
        bool* vus = calloc(G.n, sizeof(*vus));

        for (int i=0; i<G.n; i++) {
            int y = ordre_bfs[i];
            if (y == -1) break;
            if (y<nX || C[y] != -1 || dist[y] == -1) continue;
            
            liste* chemin = dfs_alternant(G, nX, C, dist, vus, y);
            if (chemin == NULL) continue;
            
            augmenter(C, chemin);
            existe_augmentant = true;
            liberer_liste(chemin);
        }

        free(dist);
        free(ordre_bfs);
        free(vus);
    }
    return C;
}


int main(void){
    graphe G1 = generer_biparti(6, 6, 3, 11);
    int C1[12] = {-1, 10, 7, 9, 6, -1, 4, 2, -1, 3, 1, -1};

    for (int s=0; s<6; s++){
        printf("Sommet %d : ", s);
        afficher_liste(G1.adj[s]);
    }

    printf("Cardinal C1 : %d\n", cardinal_couplage(G1, C1));

    int* access = accessibles(G1, 0);
    printf("Accessibles G1 : "); afficher_tab(access, G1.n);
    free(access);

    printf("Nx G1 : %d\n", calcul_nX(G1));

    liste* chemin = chemin_augmentant(G1, calcul_nX(G1), C1);
    printf("Chemin augmentant : "); afficher_liste(chemin);
    
    printf("C1 avant augmentation : "); afficher_tab(C1, 12);
    printf("Cardinal : %d\n", cardinal_couplage(G1, C1));
    augmenter(C1, chemin);
    printf("C1 apres augmentation : "); afficher_tab(C1, 12);
    printf("Cardinal : %d\n", cardinal_couplage(G1, C1));
    liberer_liste(chemin);

    int* couplage_max = couplage_maximum(G1);
    printf("Couplage maximum : "); afficher_tab(couplage_max, 12); 
    printf("Cardinal : %d\n", cardinal_couplage(G1, couplage_max));
    free(couplage_max);


    graphe G2 = generer_biparti(100, 100, 5, 1);
    graphe G3 = generer_biparti(5000, 5000, 10, 42);

    // Tests  couplage maximum (très long)
    printf("Exécution de couplage pas optimisé (env 3 min) :\n");
    int* C2 = couplage_maximum(G2);
    int* C3 = couplage_maximum(G3);
    printf("|C2| : %d\n", cardinal_couplage(G2, C2));
    printf("|C3| : %d\n", cardinal_couplage(G3, C3));
    free(C2);
    free(C3);
    

    // Tests hopcroftk karp
    printf("Couplage optimisé avec hopcroft karp :\n");
    int* C2bis = hopcroft_karp(G2);
    int* C3bis = hopcroft_karp(G3);
    printf("|C2| hopcroft karp : %d\n", cardinal_couplage(G2, C2bis));
    printf("|C3| hopcroft karp : %d\n", cardinal_couplage(G3, C3bis));
    free(C2bis);
    free(C3bis);

    liberer_graphe(G1);
    liberer_graphe(G2);
    liberer_graphe(G3);
    return 0;
}
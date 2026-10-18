#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <limits.h>

// ───────────────────────────────────────────────
//  Structures de données
// ───────────────────────────────────────────────

typedef struct {
    int n;      // nombre de sommets
    int **adj;  // liste d'adjacence : [voisin, poids, voisin, poids, ..., -1]
} graphe;

typedef struct {
    int s;  // source
    int t;  // cible
    int p;  // poids
} arete;


// ───────────────────────────────────────────────
//  Assertions renforcées
// ───────────────────────────────────────────────

void assert2(int condition, const char *message, const char *file, int line) {
    if (!condition) {
        fprintf(stderr, "Assertion failed: %s\nFile: %s, line: %d\n", message, file, line);
        exit(EXIT_FAILURE);
    }
}
#define ASSERT2(cond) assert2((cond), #cond, __FILE__, __LINE__) // macro pratique pour afficher condition + fichier + ligne


// ───────────────────────────────────────────────
// Fonctions de base sur les graphes
// ───────────────────────────────────────────────

int degre(graphe G, int s) {
    ASSERT2(s >= 0 && s < G.n);
    int d = 0;
    // on parcourt les couples (voisin, poids) jusqu’au marqueur -1
    while (G.adj[s][2*d] != -1) {
        d++;
        ASSERT2(d <= G.n); // sécurité contre une boucle infinie si -1 manquant
    }
    return d;
}

void ajouter_arete(graphe G, arete a) {
    ASSERT2(a.s >= 0 && a.s < G.n);
    ASSERT2(a.t >= 0 && a.t < G.n);

    // On vérifie qu’on n’ajoute pas de doublon
    int i = 0;
    while (i<10 && G.adj[a.s][2*i] != -1) {
        int voisin = G.adj[a.s][2*i];
        int poids  = G.adj[a.s][2*i+1];
        if (voisin == a.t && poids == a.p) return; // même arête déjà présente
        if (voisin == a.t) return; // même extrémité, poids différent ignoré
        i++;
        ASSERT2(i <= G.n);
    }

    int deg_s = degre(G, a.s);
    int deg_t = degre(G, a.t);
    if (deg_s >= 10 || deg_t >= 10) return; // si la liste d'adjacence est pleine  
    ASSERT2(deg_s < G.n && deg_t < G.n); // limite arbitraire : chaque sommet a au plus n arêtes

    // Ajout symétrique (graphe non orienté)
    G.adj[a.s][2*deg_s]   = a.t;
    G.adj[a.s][2*deg_s+1] = a.p;
    G.adj[a.s][2*deg_s+2] = -1;

    G.adj[a.t][2*deg_t]   = a.s;
    G.adj[a.t][2*deg_t+1] = a.p;
    G.adj[a.t][2*deg_t+2] = -1;
}

graphe construire_graphe(const char* nom_fichier) {
    FILE* canal = fopen(nom_fichier, "r");
    ASSERT2(canal != NULL);

    graphe G;
    ASSERT2(fscanf(canal, "%d", &G.n) == 1);
    ASSERT2(G.n > 0);

    // allocation du tableau d’adjacence
    G.adj = malloc(G.n * sizeof(int*));
    ASSERT2(G.adj != NULL);

    // chaque ligne d’adjacence a une taille fixe (ici 21 entiers)
    for (int s = 0; s < G.n; s++) {
        G.adj[s] = malloc(21 * sizeof(int));
        ASSERT2(G.adj[s] != NULL);
        G.adj[s][0] = -1; // initialise avec une liste vide
    }

    // lecture des arêtes depuis le fichier
    arete a;
    while (fscanf(canal, "%d %d %d", &a.s, &a.t, &a.p) == 3) {
        ASSERT2(a.s >= 0 && a.s < G.n);
        ASSERT2(a.t >= 0 && a.t < G.n);
        ajouter_arete(G, a);
    }

    fclose(canal);
    return G;
}

void liberer_graphe(graphe G) {
    for (int s = 0; s < G.n; s++)
        free(G.adj[s]);
    free(G.adj);
}

int poids_graphe(graphe G) {
    int poids = 0;
    // somme des poids de toutes les arêtes (chaque arête comptée deux fois)
    for (int s = 0; s < G.n; s++) {
        for (int i = 0; G.adj[s][2*i] != -1; i++) {
            poids += G.adj[s][2*i+1];
            ASSERT2(i <= G.n);
        }
    }
    return poids / 2; // division par 2 pour corriger le double comptage
}


// ───────────────────────────────────────────────
// Composantes connexes et arêtes sûres
// ───────────────────────────────────────────────

void numerote_cc(graphe H, int s, int *cc, int curr_cc) {
    ASSERT2(s >= 0 && s < H.n);
    if (cc[s] != -1) return; // déjà visité

    cc[s] = curr_cc;
    // DFS récursive sur les voisins
    for (int i = 0; H.adj[s][2*i] != -1; i++) {
        int voisin = H.adj[s][2*i];
        ASSERT2(voisin >= 0 && voisin < H.n);
        numerote_cc(H, voisin, cc, curr_cc);
    }
}

int* composantes(graphe H, int *m) {
    ASSERT2(m != NULL);
    int *cc = malloc(H.n * sizeof(*cc));
    ASSERT2(cc != NULL);

    // initialisation : tous les sommets non visités
    for (int i = 0; i < H.n; i++) cc[i] = -1;
    *m = 0;

    // numérotation successive des composantes
    for (int i = 0; i < H.n; i++) {
        if (cc[i] == -1) {
            numerote_cc(H, i, cc, *m);
            (*m)++;
        }
    }
    return cc;
}

arete* aretes_sures(graphe G, graphe H, int* cc, int m) {
    ASSERT2(cc != NULL && m > 0);
    arete* sures = malloc(m * sizeof(*sures));
    ASSERT2(sures != NULL);

    // initialisation : aucune arête sûre encore trouvée
    for (int i = 0; i < m; i++) {
        sures[i].s = -1;
        sures[i].t = -1;
        sures[i].p = INT_MAX;
    }

    // on parcourt toutes les arêtes de G
    for (int s = 0; s < H.n; s++) {
        for (int i = 0; G.adj[s][2*i] != -1; i++) {
            int voisin = G.adj[s][2*i];
            int poids  = G.adj[s][2*i+1];
            ASSERT2(voisin >= 0 && voisin < G.n);

            // on ne considère que les arêtes entre deux composantes différentes
            if (cc[s] != cc[voisin]) {
                int comp = cc[s];
                arete meilleure = sures[comp];
                arete curr = { s, voisin, poids };

                // sélection de la meilleure (poids minimal, puis plus petit s, puis plus petit t)
                if (curr.p < meilleure.p ||
                    (curr.p == meilleure.p && curr.s < meilleure.s) ||
                    (curr.p == meilleure.p && curr.s == meilleure.s && curr.t < meilleure.t)) {
                    sures[comp] = curr;
                }
            }
        }
    }
    return sures;
}


// ───────────────────────────────────────────────
// Algorithme de Borůvka (arbre couvrant minimum)
// ───────────────────────────────────────────────

graphe boruvka(graphe G) {
    graphe H;
    H.n = G.n;

    // H commence vide : pas d’arêtes
    H.adj = malloc(H.n * sizeof(*H.adj));
    ASSERT2(H.adj != NULL);
    for (int i = 0; i < H.n; i++) {
        H.adj[i] = malloc((2*H.n+1) * sizeof(int)); // taille généreuse pour les ajouts successifs
        ASSERT2(H.adj[i] != NULL);
        H.adj[i][0] = -1;
    }

    while (1) {
        int nb_cc = 0;
        int *cc = composantes(H, &nb_cc); // calcule les composantes actuelles
        ASSERT2(cc != NULL);

        if (nb_cc <= 1) { // un seul arbre = ACM trouvé
            free(cc);
            break;
        }

        arete *sures = aretes_sures(G, H, cc, nb_cc); // arêtes minimales inter-composantes
        ASSERT2(sures != NULL);

        int nb_ajoutees = 0;
        for (int i = 0; i < nb_cc; i++) {
            if (sures[i].s != -1) { // arête valide trouvée
                ajouter_arete(H, sures[i]);
                nb_ajoutees++;
            }
        }

        free(sures);
        free(cc);

        if (nb_ajoutees == 0) break; // graphe non connexe
    }
    return H;
}


// ───────────────────────────────────────────────
// Section de tests
// ───────────────────────────────────────────────

void tests() {
    printf("\n=== Début des tests ===\n");

    // petit graphe à la main
    graphe G;
    G.n = 3;
    G.adj = malloc(G.n * sizeof(int*));
    for (int i = 0; i < G.n; i++) {
        G.adj[i] = malloc((2*G.n+1) * sizeof(int));
        G.adj[i][0] = -1;
    }

    ajouter_arete(G, (arete){0,1,1});
    ajouter_arete(G, (arete){1,2,2});
    ajouter_arete(G, (arete){0,2,3});

    ASSERT2(degre(G, 0) == 2);
    ASSERT2(poids_graphe(G) == 6);

    graphe T = boruvka(G);
    ASSERT2(poids_graphe(T) == 3); // arbre couvrant minimal attendu : 1 + 2

    liberer_graphe(T);
    liberer_graphe(G);

    printf("Test manuel Borůvka ok\n");

    // tests sur fichiers (graphe simple et dense)
    graphe g_10_sd = construire_graphe("g_10_sd.txt");
    graphe g_10_ad = construire_graphe("g_10_ad.txt");
    ASSERT2(poids_graphe(g_10_sd) == 343);
    ASSERT2(poids_graphe(g_10_ad) == 168);

    graphe t_10_sd = boruvka(g_10_sd);
    graphe t_10_ad = boruvka(g_10_ad);
    ASSERT2(poids_graphe(t_10_sd) == 117);
    ASSERT2(poids_graphe(t_10_ad) == 66);

    liberer_graphe(t_10_sd);
    liberer_graphe(t_10_ad);
    liberer_graphe(g_10_sd);
    liberer_graphe(g_10_ad);

    printf("Tests fichiers ok\n");

    // cas limite : un seul sommet
    graphe G1;
    G1.n = 1;
    G1.adj = malloc(sizeof(int*));
    G1.adj[0] = malloc(3*sizeof(int));
    G1.adj[0][0] = -1;

    graphe T1 = boruvka(G1);
    ASSERT2(poids_graphe(T1) == 0);

    liberer_graphe(T1);
    liberer_graphe(G1);

    printf("Cas limite (1 sommet) ok\n");
    printf("=== Tous les tests sont validés ===\n");
}


// ───────────────────────────────────────────────
//  Main
// ───────────────────────────────────────────────

int main() {
    tests(); // lance les tests internes

    // tests sur grands graphes (1000 sommets)
    graphe g_1000_sd = construire_graphe("g_1000_sd.txt");
    graphe g_1000_ad = construire_graphe("g_1000_ad.txt");
    graphe mst_sd = boruvka(g_1000_sd);
    graphe mst_ad = boruvka(g_1000_ad);

    printf("Poids g_1000_sd : %d\n", poids_graphe(g_1000_sd));
    printf("Poids ACM : %d\n", poids_graphe(mst_sd));
    printf("Poids g_1000_ad : %d\n", poids_graphe(g_1000_ad));
    printf("Poids ACM : %d\n", poids_graphe(mst_ad));

    // libération mémoire finale
    liberer_graphe(g_1000_sd);
    liberer_graphe(g_1000_ad);
    liberer_graphe(mst_sd);
    liberer_graphe(mst_ad);
    return 0;
}

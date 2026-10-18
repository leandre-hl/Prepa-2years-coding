struct Liste {
    int val; // Valeur du maillon
    struct Liste* succ; // Pointeur vers le maillon suivant
};

typedef struct Liste liste;

struct Graphe {
    // Implémente un graphe biparti G = (S, A)
    int n; // Taille de S
    liste** adj; // Tableau de listes d'adjacence
};

typedef struct Graphe graphe;

liste* cons(int, liste*);

void liberer_liste(liste*);

void afficher_liste(liste*);

void afficher_tab(int*, int);

graphe creer_graphe(int);

void liberer_graphe(graphe);

void ajouter_arete(graphe, int, int);

graphe generer_biparti(int, int, int, int);

double chronometre(int* f(graphe), graphe arg);
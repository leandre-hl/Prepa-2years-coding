#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

struct Regle {
    char X;
    char* alpha;
};
typedef struct Regle regle;

struct Grammaire {
    int taille_V;
    int nb_prod;
    regle* Prod;
};
typedef struct Grammaire grammaire;


bool terminal(char c) {
    return 'a' <= c && c <= 'z';
}

bool variable(char c) {
    return 'A' <= c && c <= 'Z';
}

grammaire creer_grammaire(int taille_V, char* tab_X, char** tab_alpha) {
    grammaire G;
    G.taille_V = taille_V;
    G.nb_prod = strlen(tab_X);

    G.Prod = malloc(G.nb_prod*sizeof(*G.Prod));
    for (int i=0; i<G.nb_prod; i++) {
        G.Prod[i].X = tab_X[i];
        G.Prod[i].alpha = tab_alpha[i];
    }
    
    return G;
}

void libérer_grammaire(grammaire G) {
    free(G.Prod);
}

bool regle_chomsky(regle r) {
    int l = strlen(r.alpha);
    return l == 0 && r.X == 'S' 
        || l == 1 && terminal(r.alpha[0])
        || l == 2 && variable(r.alpha[0]) && variable(r.alpha[1]) && r.alpha[0] != 'S' && r.alpha[1] != 'S';
}


void afficher_grammaire(grammaire G) {
    printf("|V| = %d\n", G.taille_V);
    for (int i=0; i<G.nb_prod; i++) {
        printf("%c -> %s\n", G.Prod[i].X, G.Prod[i].alpha);
    }
}

bool est_FNC(grammaire G) {
    for (int i=0; i<G.nb_prod; i++) {
        if (!regle_chomsky(G.Prod[i])) return false;
    }
    return true;

}

bool CYN(grammaire G, char* u) {
    int n = strlen(u);
    bool*** X = malloc(n*sizeof(*X));
    for (int i = 0; i < n; i++) {
        X[i] = malloc(n*sizeof(*X[i]));
        for (int j=0; j < n; j++) {
            X[i][j] = malloc(G.taille_V*sizeof(*X[i][j]));
            for (int k=0; k<G.taille_V; k++) X[i][j][k] = false;
        }
        for (int p=0; p<G.nb_prod; p++) {
            if (strlen(G.Prod[p].alpha) == 1 && G.Prod[p].alpha[0] == u[i]) {
                X[i][i][(int) (G.Prod[p].X - 'A')] = true;
            }
        }
    }
    for (int delta = 1; delta<n; delta++) {
        for(int i = 0; i<n-delta+1; i++) {
            int j = i+delta;
            for(int k=i; k<j-1; k++) {
                for (int p=0; p<G.nb_prod; p++) {
                    regle r = G.Prod[p];
                    if (strlen(r.alpha) == 2 && variable(r.alpha[0]) && variable(r.alpha[1]) && r.alpha[0] != 'S' && r.alpha[1] != 'S') {
                        if (X[i][k][(int) (r.alpha[0] - 'A')] && X[k+1][j][(int) (r.alpha[1] - 'A')]) {
                            X[i][j][(int) (r.X - 'A')] = true;
                        }
                    }
                }
            }
        }
    }

    bool res = X[0][n-1][0];
    
    for (int i = 0; i < n; i++) {
        for (int j=0; j < n; j++) {
            free(X[i][j]);
        }
        free(X[i]);
    }
    free(X);

    return res;
}


int main() {
    printf("G0 :\n");
    char* tab_alpha0[] = {"BbB", "Ba", ""};
    grammaire G0 = creer_grammaire(2, "ABB", tab_alpha0);
    afficher_grammaire(G0);
    libérer_grammaire(G0);

    printf("G1 :\n");
    char* tab_alpha1[] = {"BC","CB","DB","b","BE","a","b","BC","a"};
    grammaire G1 = creer_grammaire(5, "AAAABBCDE", tab_alpha1);
    afficher_grammaire(G1);
    printf("%d\n", CYN(G1, "ab"));
    libérer_grammaire(G1);
    return 0;

    printf("G2 :\n");
    char* tab_alpha2[] = {"FC", "FD", "FE", "FG", "", "FC", "FD", "FE", "FG", "BD", "GB", "BG", "a", "b"};
    grammaire G2 = creer_grammaire(7, "AAAAABBBBCDEFG", tab_alpha2);
    afficher_grammaire(G2);
    printf("%d\n", CYN(G2, "ab"));
    libérer_grammaire(G2);
    return 0;

    
}

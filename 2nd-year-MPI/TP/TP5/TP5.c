#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <stdbool.h>
#include <assert.h>

#include "dicts.h"

struct AFD {
    int Q;
    int Sigma;
    int q0;
    bool* finaux;
    int** delta;
};

typedef struct AFD afd;

void liberer_afd(afd A){
    for (int i=0; i<A.Q; i++) {
        free(A.delta[i]); 
    }
    free(A.delta);
    free(A.finaux);
}

afd init_afd(int Q, int Sigma, int q0){
    afd A;
    A.Q = Q;
    A.Sigma = Sigma;
    A.q0 = q0;
    A.finaux = malloc(Q*sizeof(*A.finaux));
    A.delta = malloc(Q*sizeof(*A.delta));
    for (int i=0; i<Q; i++) {
        A.finaux[i] = false;
        A.delta[i] = malloc(Sigma*sizeof(*A.delta[i]));
        for (int j=0; j<Sigma; j++) {
            A.delta[i][j] = -1;
        }
    }
    return A;
}

void ajout_transition_afd(afd A, int q, char a, int p){
    A.delta[q][(int)a-97] = p;
}

int delta_etoile_afd(afd A, int q, char* u){
    if (q==-1) return -1;
    char a = u[0];
    if (a=='\0') return q;
    return delta_etoile_afd(A, A.delta[q][(int)a-97], &u[1]);
}

bool reconnu_afd(afd A, char* u){
    int qf = delta_etoile_afd(A, A.q0, u);
    return qf != -1 && A.finaux[qf];
}


struct AFND {
    int Q;
    int Sigma;
    bool* initiaux;
    bool* finaux;
    liste*** Delta;
};

typedef struct AFND afnd;

void liberer_afnd(afnd B){
    // Libère la mémoire d'un AFND.
    free(B.initiaux);
    free(B.finaux);
    for (int i=0; i<B.Q; i++){
        for (int j=0; j<B.Sigma; j++){
            liberer_liste(B.Delta[i][j]);
        }
        free(B.Delta[i]);
    }
    free(B.Delta);
}

afnd init_afnd(int Q, int Sigma){
    // Initialise un AFND.
    afnd B;
    B.Q = Q;
    B.Sigma = Sigma;
    bool* finaux = malloc(Q * sizeof(*finaux));
    bool* initiaux = malloc(Q * sizeof(*initiaux));
    liste*** Delta = malloc(Q * sizeof(*Delta));
    for (int q=0; q<Q; q++){
        finaux[q] = false;
        initiaux[q] = false;
        liste** tab = malloc(Sigma * sizeof(*tab));
        for (int a=0; a<Sigma; a++){
            tab[a] = NULL;
        }
        Delta[q] = tab;
    }
    B.finaux = finaux;
    B.initiaux = initiaux;
    B.Delta = Delta;
    return B;
}

void ajout_transition_afnd(afnd B, int q, char a, int p){
    B.Delta[q][(int)a-97] = cons(p, B.Delta[q][(int)a-97]);
}

bool* Delta_etats(afnd B, bool* X, char a){
    bool* etats = malloc(B.Q*sizeof(*etats));
    for (int i=0; i<B.Q; i++) etats[i] = false;

    for (int i=0; i<B.Q; i++) {
        if (X[i]) {
            for (liste* q = B.Delta[i][(int)a-97]; q != NULL; q = q->suivant) {
                etats[q->val] = true;
            }
        }
    }

    return etats;
}

bool* Delta_etoile_afnd(afnd B, bool* X, char* u, bool free_X){
    if (u[0] == '\0') return X;
    bool* etats = Delta_etats(B, X, u[0]);
    if (free_X) free(X);
    return Delta_etoile_afnd(B, etats, &u[1], true);
}

bool reconnu_afnd(afnd B, char* u){
    bool* etats = Delta_etoile_afnd(B, B.initiaux, u, false);
    bool reconnu = false;
    for (int i=0; !reconnu && i<B.Q; i++) {
        if (etats[i] && B.finaux[i]) reconnu = true;
    }
    free(etats);
    return reconnu;
}
 
int etats_vers_entier(bool* X, int Q){
    if (Q==0) return 0;
    
    int offset;
    if (X[Q-1]) offset = 1;
    else offset = 0;

    return offset + 2*etats_vers_entier(X, Q-1);
}

bool* entier_vers_etats(int x, int Q){
    bool* etats = malloc(Q*sizeof(*etats));
    for (int i=Q-1; i>=0; i--) {
        etats[i] = (x%2 == 1);
        x /= 2;
    }
    return etats;
}

afd determiniser(afnd B){
    afd A = init_afd(1<<B.Q, B.Sigma, etats_vers_entier(B.initiaux, B.Q));
    
    for (int i=0; i<A.Q; i++) {
        bool* etat = entier_vers_etats(i, B.Q);
        for (int k = 0; k<B.Q; k++) {
            if (etat[k] && B.finaux[k]) {
                A.finaux[i] = true;
                break;
            }
        }
        for (int j=0; j<A.Sigma; j++) {
            bool* arivee = Delta_etats(B, etat, (char)j + 'a');
            A.delta[i][j] = etats_vers_entier(arivee, B.Q);
            free(arivee);
        }
        free(etat);
    }
    return A;
}


void dfs_accessibles(int etat, dict* D, afd A, bool* vus) {
    if (etat<0 || etat >= A.Q) return;
    if (vus[etat]) return;
    vus[etat] = true;
    add(D, etat, size(*D));
    for(int a=0; a<A.Sigma; a++) {
        dfs_accessibles(A.delta[etat][a], D, A, vus);
    }
}

dict accessibles(afnd B){
    dict D;
    afd A = determiniser(B);
    bool* vus = malloc(A.Q*sizeof(vus));
    dfs_accessibles(A.q0, &D, A, vus);
    liberer_afd(A);
    return D;
}
    

void dfs_determiniser2(int etat, dict D, afd C, afd* A, bool* vus) {
    if (!member(D, etat)) return;
    int i = get(D, etat);
    if (vus[i]) return;
    vus[i] = true;
    for (int a=0; a<C.Sigma; a++) {
        int next = C.delta[etat][a];
        if (member(D, next)) {
            A->delta[i][a] = get(D, next);
            dfs_determiniser2(next, D, C, A, vus);
        }
    }
}

afd determiniser2(afnd B){
    dict D = accessibles(B);
    
    afd A = init_afd(size(D), B.Sigma, 0);

    afd C = determiniser(B);
    bool* vus = malloc(A.Q*sizeof(*vus));
    for (int i=0; i<A.Q; i++) {vus[i] = false;}

    dfs_determiniser2(A.q0, D, C, &A, vus);
    return A;
}

void print_reconnu(afd A, char* u) {
    if (reconnu_afd(A, u)) printf("reconnu\n");
    else printf("non reconnu\n");
}

void print_reconnu2(afnd B, char* u) {
    if (reconnu_afnd(B, u)) printf("reconnu\n");
    else printf("non reconnu\n");
}

struct EPSILON_AFND {
    int Q;
    int Sigma;
    bool* initiaux;
    bool* finaux;
    liste*** Delta;
};
typedef struct EPSILON_AFND e_afnd;



int main(void){
    char u[] = "abbabbabaab";
    char v[] = "baababbbbba";
    char w[] = "aaabababb";

    afd A1 = init_afd(4, 2, 0);
    A1.finaux[3] = true;
    ajout_transition_afd(A1, 0, 'b', 0); ajout_transition_afd(A1, 0, 'a', 1);
    ajout_transition_afd(A1, 1, 'a', 2); ajout_transition_afd(A1, 1, 'b', 0);
    ajout_transition_afd(A1, 2, 'a', 2); ajout_transition_afd(A1, 2, 'b', 3);
    ajout_transition_afd(A1, 3, 'a', 1); ajout_transition_afd(A1, 3, 'b', 0);
    
    printf("u dans A1 : "); print_reconnu(A1, u);
    printf("v dans A1 : "); print_reconnu(A1, v);
    printf("w dans A1 : "); print_reconnu(A1, w);
    
    liberer_afd(A1);

    afd A2 = init_afd(4, 2, 0);
    A2.finaux[3] = true;
    ajout_transition_afd(A2, 0, 'a', 1);
    ajout_transition_afd(A2, 1, 'a', 2); ajout_transition_afd(A2, 1, 'b', 2);
    ajout_transition_afd(A2, 2, 'a', 3); ajout_transition_afd(A2, 2, 'b', 3);
    ajout_transition_afd(A2, 3, 'a', 1); ajout_transition_afd(A2, 3, 'b', 1);

    printf("u dans A2 : "); print_reconnu(A2, u);
    printf("v dans A2 : "); print_reconnu(A2, v);
    printf("w dans A2 : "); print_reconnu(A2, w);

    liberer_afd(A2);

    // Automate reconnaissant les mots commencant par ab ou finissant par ba
    afnd B1 = init_afnd(6, 2);
    B1.initiaux[0] = true; B1.initiaux[3] = true;
    B1.finaux[2] = true; B1.finaux[5] = true;
    ajout_transition_afnd(B1, 0, 'a', 0); ajout_transition_afnd(B1, 0, 'b', 0);
    ajout_transition_afnd(B1, 0, 'a', 1); ajout_transition_afnd(B1, 1, 'b', 2);
    ajout_transition_afnd(B1, 3, 'b', 4); ajout_transition_afnd(B1, 4, 'a', 5);
    ajout_transition_afnd(B1, 5, 'a', 5); ajout_transition_afnd(B1, 5, 'b', 5);
    
    printf("u dans B1 : "); print_reconnu2(B1, u);
    printf("v dans B1 : "); print_reconnu2(B1, v);
    printf("w dans B1 : "); print_reconnu2(B1, w);

    afd B1_deter = determiniser(B1);
    printf("u dans B1_deter : "); print_reconnu(B1_deter, u);
    printf("v dans B1_deter : "); print_reconnu(B1_deter, v);
    printf("w dans B1_deter : "); print_reconnu(B1_deter, w);
    liberer_afd(B1_deter);

    afd B1_deter2 = determiniser(B1);
    printf("u dans B1_deter2 : "); print_reconnu(B1_deter2, u);
    printf("v dans B1_deter2 : "); print_reconnu(B1_deter2, v);
    printf("w dans B1_deter2 : "); print_reconnu(B1_deter2, w);
    liberer_afd(B1_deter2);

    liberer_afnd(B1);

    afnd B2 = init_afnd(4, 2);
    B2.initiaux[0] = true;
    B2.finaux[3] = true;
    ajout_transition_afnd(B2, 0, 'a', 0); ajout_transition_afnd(B2, 0, 'b', 0);
    ajout_transition_afnd(B2, 0, 'a', 1);
    ajout_transition_afnd(B2, 1, 'a', 2); ajout_transition_afnd(B2, 1, 'b', 2);
    ajout_transition_afnd(B2, 2, 'a', 3); ajout_transition_afnd(B2, 2, 'b', 3);

    printf("u dans B2 : "); print_reconnu2(B2, u);
    printf("v dans B2 : "); print_reconnu2(B2, v);
    printf("w dans B2 : "); print_reconnu2(B2, w);

    afd B2_deter = determiniser(B2);
    printf("u dans B2_deter : "); print_reconnu(B2_deter, u);
    printf("v dans B2_deter : "); print_reconnu(B2_deter, v);
    printf("w dans B2_deter : "); print_reconnu(B2_deter, w);
    liberer_afd(B2_deter);

    afd B2_deter2 = determiniser(B2);
    printf("u dans B2_deter2 : "); print_reconnu(B2_deter2, u);
    printf("v dans B2_deter2 : "); print_reconnu(B2_deter2, v);
    printf("w dans B2_deter2 : "); print_reconnu(B2_deter2, w);
    liberer_afd(B2_deter2);

    liberer_afnd(B2);
    
    return 0;
}
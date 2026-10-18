#include "stdio.h"
#include "math.h"
#include "stdlib.h"
#include "stdbool.h"
#include "time.h"
#include "assert.h"

// ---- Partie 1 ----

int pgcd (int a, int b) {
    if (b==0) return a;
    return pgcd(b, a % b);
}


double somme(int n) {
    if (n==0) return 0.;
    return 1./(n*n) + somme (n-1);
}


int seuil(int n) {
    int k=0;
    int acc=1;
    while (acc < n) {
        acc *= 2;
        k += 1;
    }
    return k;
}

int maximum(int* tab, int len) {
    int maxv = tab[0];
    for (int i=1; i<len; i++) {
        if (tab[i] > maxv) maxv = tab[i];
    }
    return maxv;
}

int maximum2(int* tab, int len) {
    int maxi = 0;
    for (int i=1; i<len; i++) {
        if (tab[i] > tab[maxi]) maxi = i;
    }
    return maxi;
}

void afficher_tableau(int* tab, int len) {
    printf("[");
    for (int i = 0; i<len-1; i++) {
        printf("%d, ", tab[i]);
    }
    if (len>0) printf("%d", tab[len-1]);
    printf("]\n");

}

int* tableau_alea(int len, int m) {
    int* tab = malloc(len*sizeof(int));
    for (int i=0; i<len; i++) {
        tab[i] = rand() % m;
    }
    return tab;
}

void tri_selection(int* tab, int len) {
    for (int i=len-1; i>=0; i--) {
        int maxi = maximum2(tab, i+1);
        int tmp = tab[maxi];
        tab[maxi] = tab[i];
        tab[i] = tmp;
    }
}

bool appartient(int x, int* tab, int len) {
    if (len==0) return false;
    return x==tab[0] || appartient(x, &tab[1], len-1);
}

bool dichotomie(int x, int* tab, int len) {
    int l = 0, g = len;
    while (g-l > 1) {
        int m = (l+g)/2;
        if (tab[m] <= x) l=m;
        if (tab[m] > x) g=m;
    }
    return tab[l] == x;
}


bool premier(int n) {
    bool premier = true;
    for (int i=0; premier && i*i<n; i++) {
        if (n % i == 0) premier = false;
    }
    return premier;
}


int* crible(int n, int* len) {
    bool* grid = calloc((n+1),sizeof(*grid));
    int* premiers_big = malloc((n+1)*sizeof(int));
    int nb_premiers = 0;
    for (int i = 2; i<n+1; i++) {
        if (!grid[i]) {
            premiers_big[nb_premiers] = i;
            nb_premiers ++;
            for (int j=i; j<=n; j+=i) {
                grid[j] = true;
            }
        }
    }

    int* premiers = malloc(nb_premiers*sizeof(int));
    for (int i=0; i<nb_premiers; i++) {
        premiers[i] = premiers_big[i];
    }
    free(grid);
    free(premiers_big);

    *len = nb_premiers;
    return premiers;
}

// ---- Partie 2 ----

typedef struct Liste {
    int data;
    struct Liste* suivant;
} liste;

liste* creer_liste(int x) {
    liste* maillon = malloc(sizeof(*maillon));
    maillon->data = x;
    maillon->suivant = NULL;
    return maillon;
}

liste* convertir_tab(int* tab, int len) {
    if (len==0) return NULL;
    liste* front = creer_liste(tab[0]);
    front->suivant = convertir_tab(&tab[1], len-1);
    return front;
}

void afficher_liste(liste* lst) {
    if (lst == NULL) {printf("NULL\n"); return;}
    printf("%d -> ", lst->data);
    afficher_liste(lst->suivant);
}

void liberer_liste(liste* lst) {
    if (lst!=NULL) {
        liberer_liste(lst->suivant);
        free(lst);
    }
}

typedef struct File {
    liste* premier;
    liste* dernier;
} file;


file* creer_vide(void) {
    file* f = malloc(sizeof(*f));
    f->premier = NULL;
    f->dernier = NULL;
    return f;
}

bool est_vide(file* f) {
    return f->premier == NULL;
}

void liberer_file(file* f) {
    if (f==NULL) return;
    liberer_liste(f->premier);
    free(f);
}

void enfiler(file* f, int x) {
    liste* nouv = creer_liste(x);
    if (est_vide(f)) {
        f->dernier = nouv;
        f->premier = nouv;
    }
    else {
        f->dernier->suivant = nouv;
        f->dernier = f->dernier->suivant;
    }
}

int defiler(file* f) {
    assert(!est_vide(f));
    int x = f->premier->data;
    liste* tmp = f->premier->suivant;
    free(f->premier);
    f->premier = tmp;
    return x;
}


// ---- Partie 3 ----

int inversions_naif(int* tab, int n) {
    int count = 0;
    for (int i=0; i<n; i++) {
        for (int j=i+1; j<n; j++) {
            if (tab[j] < tab[i]) count++;
        }
    }
    return count;
}


int inversions_DPR(int* tab, int n) {
    if (n<=1) return 0;
    int inv_left = inversions_DPR(tab, n/2);
    int inv_right = inversions_DPR(&tab[n/2], (n+1)/2);
    int new_inv = 0;
    int* tmp = malloc(n*sizeof(int));
    int j=0;
    for (int i=0; i<n/2; i++) {
        while (j < (n+1)/2 && tab[n/2 + j] < tab[i]) {
            tmp[i+j] = tab[n/2 + j];
            j++;
            new_inv += n/2 - i;
        }
        tmp[i+j] = tab[i];
    }
    for (int k=0; k<n/2 + j; k++) {
        tab[k] = tmp[k];
    }
    free(tmp);
    return inv_left + inv_right + new_inv;
}


struct Tab_dyna {
    int taille;
    int capacite;
    int* data;
};
typedef struct Tab_dyna tab_dyna;


tab_dyna* creer_tab_dyna() {
    tab_dyna* td = malloc(sizeof(*td));
    td->taille = 0;
    td->capacite = 1;
    td->data = malloc(sizeof(*td->data));
    return td;
}

void liberer_tab_dyna(tab_dyna* td) {
    free(td->data);
    free(td);
}

int evaluer(tab_dyna* td, int i) {
    assert(i < td->taille);
    return td->data[i];
}

void modifier(tab_dyna* td, int i, int x) {
    assert(i < td->taille);
    td->data[i] = x;
}

void redimentionner(tab_dyna* td, int capa) {
    assert(capa >= td->taille);
    int* new_data = malloc(capa*sizeof(*new_data));
    for (int i=0; i<td->taille; i++) {
        new_data[i] = td->data[i];
    }
    free(td->data);
    td->data = new_data;
    td->capacite = capa;
}

void ajouter(tab_dyna* td, int x) {
    if (td->taille == td->capacite) redimentionner(td, 2 * td->capacite);
    td->data[td->taille] = x;
    td->taille++;
}

int retirer(tab_dyna* td) {
    assert(td->taille != 0);
    assert(td->taille <= td->capacite);
    td->taille--;
    return td->data[td->taille];
}

void afficher_tab_dyna(tab_dyna* td) {
    printf("Taille : %d - Capacite : %d - Data : ", td->taille, td->capacite);
    afficher_tableau(td->data, td->taille);
}

void tests() {
    // pgcd
    printf("pgcd(12, 15) = %d\n", pgcd(12, 15));
    printf("pgcd(50, -7) = %d\n", pgcd(50, -7));

    // somme
    printf("somme(1) = %lf\n", somme(2));
    printf("somme(2) = %lf\n", somme(2));
    printf("somme(3) = %lf\n", somme(3));
    printf("somme(1000) = %lf\n", somme(1000));


    // Seuil
    printf("seuil(10) = %d\n", seuil(10));
    printf("seuil(100) = %d\n", seuil(100));
    printf("seuil(1) = %d\n", seuil(1));
    printf("seuil(16) = %d\n", seuil(16));

    int len = 20;
    int* tab = tableau_alea(len, 30);


    // afficher_tableau
    printf("tab = "); afficher_tableau(tab, len);

    // maximum
    printf("maximum(tab) = %d\n", maximum(tab, len));

    // maximum2
    printf("maximum2(tab) = %d\n", maximum2(tab, len));

    // appartient (classique)
    printf("appartient(3, tab, len) = %d\n", appartient(3, tab, len));
    printf("appartient(-1, tab, len) = %d\n", appartient(-1, tab, len));

    // tri_selection
    tri_selection(tab, len);
    printf("tab = "); afficher_tableau(tab, len);

    // appartient (dichotomie)
    printf("dichotomie(3, tab, len) = %d\n", dichotomie(3, tab, len));
    printf("dichotomie(-1, tab, len) = %d\n", dichotomie(-1, tab, len));

    // crible
    int len2;
    int* premiers = crible(100, &len2);
    printf("premiers inferieurs a 100 : "); afficher_tableau(premiers, len2);
    free(premiers);

    // afficher_liste
    liste* lst = convertir_tab(tab, len);
    afficher_liste(lst);
    liberer_liste(lst);
    
    free(tab);

    // enfiler, défiler
    file* f = creer_vide();
    afficher_liste(f->premier);
    enfiler(f, 1);
    afficher_liste(f->premier);
    enfiler(f, 2);
    afficher_liste(f->premier);
    enfiler(f, 3);
    afficher_liste(f->premier);
    defiler(f);
    afficher_liste(f->premier);
    defiler(f);
    afficher_liste(f->premier);
    defiler(f);
    afficher_liste(f->premier);
    liberer_file(f);
    

    // inversions_naif
    len = 20;
    tab = tableau_alea(len, 30);
    afficher_tableau(tab, len);

    printf("Nb inversions naif : %d\n", inversions_naif(tab, len));
    printf("Nb inversions DPR  : %d\n", inversions_DPR(tab, len));

    free(tab);

    tab_dyna* td = creer_tab_dyna();
    afficher_tab_dyna(td);
    ajouter(td, 0);
    afficher_tab_dyna(td);
    ajouter(td, 1);
    afficher_tab_dyna(td);
    ajouter(td, 2);
    afficher_tab_dyna(td);
    ajouter(td, 3);
    afficher_tab_dyna(td);
    ajouter(td, 4);
    afficher_tab_dyna(td);
    retirer(td);
    afficher_tab_dyna(td);
    retirer(td);
    afficher_tab_dyna(td);
    retirer(td);
    afficher_tab_dyna(td);
    retirer(td);
    afficher_tab_dyna(td);
    retirer(td);
    afficher_tab_dyna(td);

    liberer_tab_dyna(td);

}

int main () {
    srand(time(0));
    tests();
    return 0;
}
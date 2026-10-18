#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

// Attention : solution dp plus efficace tableau de taille l * k

int max(int a, int b) {
    if (a>b) return a;
    return b;
}

int nb_cutting(int* arr, int k, int l, int** memo) {
    if (l==0) return 1;
    if (l<0 || k<0) return 0;
    if (memo[k][l] != -1) return memo[k][l];
    
    int nb = nb_cutting(arr, k-1, l, memo) + nb_cutting(arr, k, l-arr[k], memo);
    memo[k][l] = nb;
    return nb;
}

int header_nb_cutting(int* arr, int k, int l) {
    int** memo = malloc(k*sizeof(int*));
    for (int i=0; i<k; i++) {
        memo[i] = malloc((l+1)*sizeof(int));
        for (int j=0; j<l+1; j++) {
            memo[i][j] = -1;
        }
    }

    int nb = nb_cutting(arr, k-1, l, memo);

    for (int i=0; i<k; i++) {free(memo[i]);}
    free(memo);

    return nb;
}

int max_price(int* arr, int* prices, int k, int l, int** memo) {
    if (l==0) return 0;
    if (l<0 || k<0) return INT_MIN;
    if (memo[k][l] != -1) return memo[k][l];

    int nb = max(max_price(arr, prices, k-1, l, memo), prices[k] + max_price(arr, prices, k, l-arr[k], memo));
    memo[k][l] = nb;
    return nb;
}

int header_max_price(int* arr, int* prices, int k, int l) {
    int** memo = malloc(k*sizeof(int*));
    for (int i=0; i<k; i++) {
        memo[i] = malloc((l+1)*sizeof(int));
        for (int j=0; j<l+1; j++) {
            memo[i][j] = -1;
        }
    }

    int nb = max_price(arr, prices, k-1, l, memo);

    for (int i=0; i<k; i++) {free(memo[i]);}
    free(memo);

    return nb;
}


void print_decomp(int* arr, int* prices, int k, int l, bool** last) {
    if (l<=0 || k<0) return;
    if (last[k][l]) {
        print_decomp(arr, prices, k, l-arr[k], last);
        printf("| %d ", prices[k]);
    }
    else {
        print_decomp(arr, prices, k-1, l, last);
    }
}

int max_price_decomp(int* arr, int* prices, int k, int l, int** memo, bool** last) {
    if (l==0) return 0;
    if (l<0 || k<0) return INT_MIN;
    if (memo[k][l] != -1) return memo[k][l];

    int nocut = max_price_decomp(arr, prices, k-1, l, memo, last);
    int cut = prices[k] + max_price_decomp(arr, prices, k, l-arr[k], memo, last);
    int nb;
    if (nocut >= cut) {
        last[k][l] = false;
        nb = nocut;
    }
    else {
        last[k][l] = true;
        nb = cut;
    }
    memo[k][l] = nb;
    return nb;
}

void header_max_price_decomp(int* arr, int* prices, int k, int l) {
    int** memo = malloc(k*sizeof(int*));
    bool** last = malloc(k*sizeof(bool*)); 
    for (int i=0; i<k; i++) {
        memo[i] = malloc((l+1)*sizeof(int));
        last[i] = malloc((l+1)*sizeof(bool));
        for (int j=0; j<l+1; j++) {
            memo[i][j] = -1;
            last[i][j] = false;
        }
    }

    max_price_decomp(arr, prices, k-1, l, memo, last);

    printf("Décomposition : ");
    print_decomp(arr, prices, k-1, l, last);
    printf("\n");

    for (int i=0; i<k; i++) {
        free(memo[i]);
        free(last[i]);
    }
    free(memo);
    free(last);

}


void print_decomp_loss(int* arr, int* prices, int k, int l, int** last) {
    // 0 on change de découpe
    // 1 on découpe
    // 2 on s'arrête
    if (l<=0 || k<0 || last[k][l]==2) return;
    if (last[k][l]==1) {
        print_decomp_loss(arr, prices, k, l-arr[k], last);
        printf("| %d ", prices[k]);
    }
    else {
        print_decomp_loss(arr, prices, k-1, l, last);
    }
}

int max_price_loss(int* arr, int* prices, int k, int l, int** memo, int** last) {
    if (l==0) return 0;
    if (l<0 || k<0) return INT_MIN;
    if (memo[k][l] != -1) return memo[k][l];

    int nocut = max_price_loss(arr, prices, k-1, l, memo, last);
    int cut = prices[k] + max_price_loss(arr, prices, k, l-arr[k], memo, last);

    int nb = max(0, max(nocut, cut));
    if (nb == nocut) {last[k][l] = 0;}
    else if (nb == cut) {last[k][l] = 1;}
    else {last[k][l] = 2;}

    memo[k][l] = nb;
    return nb;
}

void header_max_price_loss(int* arr, int* prices, int k, int l) {
    int** memo = malloc(k*sizeof(int*));
    int** last = malloc(k*sizeof(int*)); 
    for (int i=0; i<k; i++) {
        memo[i] = malloc((l+1)*sizeof(int));
        last[i] = malloc((l+1)*sizeof(int));
        for (int j=0; j<l+1; j++) {
            memo[i][j] = -1;
            last[i][j] = false;
        }
    }

    max_price_loss(arr, prices, k-1, l, memo, last);

    printf("Prix maximal en autorisant les chuttes : %d\n", memo[k-1][l]);
    printf("Décomposition : "); print_decomp_loss(arr, prices, k-1, l, last);
    printf("\n");

    for (int i=0; i<k; i++) {
        free(memo[i]);
        free(last[i]);
    }
    free(memo);
    free(last);

}


int main() {
    int l = 500;
    int k = 5;
    int arr[] = {42, 13, 37, 28, 195};
    int prices[] = {15, 2, 10, 7, 17};
    printf("Nombre de découpes possibles : %d\n", header_nb_cutting(arr, k, l));
    printf("Prix maximal : %d\n", header_max_price(arr, prices, k, l));
    header_max_price_decomp(arr, prices, k, l);
    header_max_price_loss(arr, prices, k, l);
    return 0;
}
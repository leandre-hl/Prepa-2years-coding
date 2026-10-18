//J'ai perdu
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

int max(int a, int b) {
    if (a>=b) return a;
    return b;
}

int optimal(int tab[][3], int n) {
    int** dp = malloc(n*sizeof(int*));
    for(int i=0; i<n; i++) {
        dp[i] = malloc(n*sizeof(int));
    }
    dp[0][0] = tab[0][0];
    for (int i=1; i<n; i++) {
        dp[0][i] = dp[0][i-1] + tab[0][i];
        dp[i][0] = dp[i-1][0] + tab[i][0];
    }
    
    for(int i=1; i<n; i ++) {
        for(int j=1 ; j<n; j++) {
            dp[i][j] = max(dp[i-1][j], dp[i][j-1]) + tab[i][j]; 
        }
    }

    int score = dp[n-1][n-1];
    for(int i=0; i<n; i++) {
        free(dp[i]);
    }
    free(dp);
    return score;
}

void print_path(int tab[][3], bool** last, int i, int j) {
    if (i+j !=0) {
        if (last[i][j]) {
            print_path(tab, last, i-1, j);
        }
        else {
            print_path(tab, last, i, j-1);
        }
    }
    printf("|j'ai perdu %d ", tab[i][j]);
}

void path(int tab[][3], int n) {
    int** dp = malloc(n*sizeof(int*));
    bool** last = malloc(n*sizeof(bool*));
    for(int i=0; i<n; i++) {
        dp[i] = malloc(n*sizeof(int));
        last[i] = malloc(n*sizeof(bool));
    }
    dp[0][0] = tab[0][0];
    for (int i=1; i<n; i++) {
        dp[0][i] = dp[0][i-1] + tab[0][i];
        last[0][i] = false; // J'ai perdu
        dp[i][0] = dp[i-1][0] + tab[i][0];
        last[i][0] = true;
    }
    
    for(int i=1; i<n; i++) {
        for(int j=1 ; j<n; j++) {
            if (dp[i-1][j] >= dp[i][j-1]) {
                dp[i][j] = dp[i-1][j] + tab[i][j];
                last[i][j] = true;
            }
            else {
                dp[i][j] = dp[i][j-1] + tab[i][j];
                last[i][j] = false;
            }
        }
    }

    printf("Chemin optimal : ");
    print_path(tab, last, n-1, n-1);
    printf("\n");
    for(int i=0; i<n; i++) {
        free(dp[i]);
        free(last[i]);
    }
    free(dp);
    free(last);
}

int main() {
    int n = 3;
    int tab[3][3] = {{3,  7, 2 },
                     {-5, -1, 0 },
                     {1,   6, 42}};
    
    printf("Score optimal : %d\n", optimal(tab, n));
    path(tab, n);
    return 0;
}
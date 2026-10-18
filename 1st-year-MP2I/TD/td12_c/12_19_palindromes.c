#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

int min(int a, int b) {
    if (b>a) return a;
    return b;
}

bool is_palindrome(char* string, int i, int j, int** memo_pal) {
    if (j-i<=1) return true;
    if (memo_pal[i][j] != -1) return memo_pal[i][j];

    memo_pal[i][j] = string[i] == string[j] && is_palindrome(string, i+1, j-1, memo_pal) ? 1 : 0;
    return memo_pal[i][j] == 1;
}

int backtrack(char* string, int n, int* memo, int** memo_pal) {
    if (n<=0) return 0;
    if (n<=2) return 1;
    if (memo[n] != -1) return memo[n];
    
    int mini = INT_MAX;
    for(int i=0; i<=n; i++) {
        if (is_palindrome(string, i, n, memo_pal)) {
            mini = min(mini, 1 + backtrack(string, i-1, memo, memo_pal));
        }
    }

    memo[n] = mini;
    return mini;
}

int header(char* string, int n) {
    int** memo_pal = malloc(n*sizeof(*memo_pal));
    int* memo = malloc(n*sizeof(memo));
    for (int i=0; i<n; i++) {
        memo_pal[i] = malloc(n*sizeof(*memo_pal[i]));
        for (int j=0; j<n; j++) {
            memo_pal[i][j] = -1;
        }
        memo[i] = -1;
    }
    int result = backtrack(string, 8-1, memo, memo_pal);
    for (int i=0; i<n; i++) {
        free(memo[i]);
    }
    free(memo);
    
    return result;
}

int main() {
    int n = 8;
    char string[] = "BOBAETEICI";
    printf("Nombre min de palindromes : %d\n", header(string, n));
}
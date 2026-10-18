# include <stdbool.h>
# include <stdio.h>
# include <stdlib.h>


bool check(int* arr, int n) {
    int* count = malloc(n*sizeof(int));
    for(int i=0; i<n; i++) {
        count[i] = 0;
    }

    for(int i=0; i<n; i++) {
        count[arr[i]]++;
    }

    for(int i=0; i<n; i++) {
        if (count[i] != arr[i]) {
            free(count);
            return false;
        }
    }

    free(count);
    return true;
}

void print_arr(int* arr, int n) {
    printf("[");
    for(int i=0; i<n; i++) {
        printf("%d", arr[i]);
        if (i<n-1) printf(", ");
    }
    printf("]\n");
}

void backtrack(int* sol, int n, int idx, int sum) {
    if (idx==n) {
        if (sum == n && check(sol, n)) {
            print_arr(sol, n);
        }
        return;
    }

    for (int i=0; sum + i <= n; i++) {
        sol[idx] = i;
        backtrack(sol, n, idx+1, sum+i);
    }
}

int main() {
    int n = 9;
    int* sol = malloc(n*sizeof(int));
    backtrack(sol, n, 0, 0);
    free(sol);
}
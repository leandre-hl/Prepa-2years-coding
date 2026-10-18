# include <stdbool.h>
# include <stdio.h>
# include <stdlib.h>

int power(int x, int n) {
    // Computes x^n
    if (n==0) return 1;

    int tmp = power(x, n/2);
    if (n%2==0) return tmp*tmp;
    return tmp*tmp*x;
}

bool ckeck(int* arr, int n) {
    bool* used_diff = malloc((arr[n-1]+1) * sizeof(bool));
    for (int i = 0; i<arr[n-1]+1; i++) {
        used_diff[i] = false;
    }

    for (int i=0; i<n; i++) {
        for(int j=i+1; j<n; j++) {
            int diff = arr[j] - arr[i];
            if (used_diff[diff]) return false;
            used_diff[diff] = true;
        }
    }
    free(used_diff);
    return true;
}

void print_arr(int* arr, int n) {
    printf("[");
    for (int i=0; i<n; i++) {
        printf("%d", arr[i]);
        if (i<n-1) printf(", ");
    }
    printf("]\n");
}

void backtrack(int* sol, int n, int idx, bool* used_diff, int* max, int* best_sol) {
    if (idx==n) {
        if (sol[n-1] < *max) {
            *max = sol[n-1];
            for(int i=0; i<n; i++) {
                best_sol[i] = sol[i];
            }
        }
        return;
    }
    
    for (int i = sol[idx-1]+1; i + (n-idx-1)*(n-idx)/2 < *max; i++) {
        bool possible = true;
        for (int j=0; j<idx && possible; j++) {
            if (used_diff[i-sol[j]]) possible = false;
        }
        if (possible) {
            sol[idx] = i;
            for (int j=0; j<idx; j++) {
                used_diff[i-sol[j]] = true;
            }

            backtrack(sol, n, idx+1, used_diff, max, best_sol);

            for (int j=0; j<idx; j++) {
                    used_diff[i-sol[j]] = false;
            }
        }
    }

}

void golomb(int n) {
    int* sol = malloc(n*sizeof(int));
    sol[0] = 0;
    int max = power(2,n)+1;
    int* best_sol = malloc(n*sizeof(int));
    bool* used_diff = malloc(max*sizeof(bool)); // C'est claqué comme borne sup mais flemme de faire des trucs dynamique
    backtrack(sol, n, 1, used_diff, &max, best_sol);
    print_arr(best_sol, n);
    free(sol);
    free(used_diff);
    free(best_sol);
}


int main() {
    int n = 13;
    golomb(n);
    return 0;
}

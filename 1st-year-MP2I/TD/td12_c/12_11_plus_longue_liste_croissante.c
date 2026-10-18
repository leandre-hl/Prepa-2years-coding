# include <stdio.h>
# include <stdbool.h>
# include <stdlib.h>
# define NMAX 1000

int max_len = 0;
int best_subseq[NMAX] = {0};


void backtrack(int *arr, int n, int idx, int *subseq, int curr_len) {
    if (idx == n) {
        if (curr_len > max_len) {
            max_len = curr_len;
            for (int i=0; i<curr_len; i++) {
                best_subseq[i] = subseq[i];
            }
        }
        return;
    }

    // On prendre l'element si possible
    if ((curr_len == 0 || subseq[curr_len-1] <= arr[idx]) && curr_len + n - idx > max_len) {
        subseq[curr_len] = arr[idx];
        backtrack(arr, n, idx+1, subseq, curr_len+1);
    }

    // On essaie de ne pas prendre l'element
    if (curr_len + n - idx - 1 > max_len) {
        backtrack(arr, n, idx+1, subseq, curr_len);
    }
}

void print_arr(int* arr, int size) {
    printf("[");
    for (int i=0; i<size; i++) {
        printf("%d", arr[i]);
        if (i!=size-1) {printf(", ");}
    }
    printf("]\n");
}

int main() {
    int arr[9] = {5, 1, 0, 3, 7, 4, 9, 6, 8};
    int subseq[9];
    backtrack(arr, 9, 0, subseq, 0);
    print_arr(best_subseq, max_len);
    return 0;
}
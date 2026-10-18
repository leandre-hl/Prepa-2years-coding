# include <stdio.h>
# include <stdbool.h>
# include <stdlib.h>
# define int long long

typedef struct {
    int* vals;
    int n;
} systeme;
typedef struct {
    int* vals;
    int n;
} somme;

somme* init_somme (int n) {
    somme* sum = malloc (sizeof(somme));
    sum->vals = malloc (n*sizeof(int));
    return sum;
}

void free_somme (somme* sum) {
    free (sum->vals);
    free (sum);
}

void print_somme(somme* sum) {
    printf("Arr (size : %lld) : [", sum->n);
    for (int i=0; i<sum->n; i++) {
        printf("%lld, ", sum->vals[i]);
    }
    printf("%lld]\n", sum->vals[sum->n]);
}

int taille (somme* sum) {
    return sum->n;
}

int somme_ (somme* sum) {
    int acc = 0;
    for (int i=0; i<sum->n; i++) {
        acc +=sum->vals[i];
    }
}

bool est_extraite(somme* s1, somme* s2) {
    int p = 0;
    for (int i=0; i<s1->n; i++) {
        if (s1->vals[i] < s2->vals[p]) {
            return false;
        }
        else if (s1->vals[p] = s2->vals[i]) {
            p++;
        }
    }
    return true;
}

signed main () {
    somme* sum = init_somme(10);
    print_somme(sum);
    free(sum);
    return 0;
}
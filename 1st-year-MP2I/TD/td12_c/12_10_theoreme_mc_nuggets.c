# include <stdio.h>
# include <stdbool.h>
# include <stdlib.h>
# include <string.h>



bool check(int* nuggets, int k, int n) {
    // k : current nugget index
    // n : goal of nuggets
    if (n==0) return true;
    if (n<0 || k<0) return false;

    return check(nuggets, k, n-nuggets[k]) || check(nuggets, k-1, n);
}

int biggest_nosol(int* nuggets, int k, int n, int nb_consecutive) {
    if (nb_consecutive == 6) return n - 7;

    if (check(nuggets, k-1, n)) {
        return biggest_nosol(nuggets, k, n+1, nb_consecutive+1);
    }
    return biggest_nosol(nuggets, k, n+1, 0);
}


int main() {
    int k = 3;
    int nuggets[] = {6, 9, 20};
    int n = 49;
    printf("Possible d'atteindre %d ?\n", n);
    if (check(nuggets, k-1, n)) printf("OUI\n");
    else printf("NON\n\n");

    printf("Plus grand n non atteignable : %d\n", biggest_nosol(nuggets, k, 0, 0));
    return 0;
}
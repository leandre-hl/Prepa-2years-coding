# include <stdio.h>
# include <stdbool.h>
# include <stdlib.h>
# define int long long

void liste_couples (int n) {
    for (int x=1; x<=n; x++) {
        for (int y=x; y<=n; y++) {
            printf("(%lld, %lld) ", x, y);
        }
    }
    printf("\n");
}

signed main () {
    liste_couples(3);
    return 0;
}
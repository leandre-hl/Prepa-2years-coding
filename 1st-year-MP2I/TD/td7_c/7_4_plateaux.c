# include <stdio.h>
# include <stdbool.h>
# include <stdlib.h>
# define int long long


int longest_stat (int arr[], int lgh) {
    if (lgh == 0) {
        return 0;
    }
    int global_max = 1, max = 1;
    for (int i = 1; i<lgh; i++) {
        if (arr[i-1]==arr[i]) {
            max++;
            if (global_max < max) {
                global_max = max;
            }
        }
        else {
            max = 1;
        }
    }
    return global_max;
}

signed main () {
    int arr[] = {0, 1, 2, 4, 4, 4, 5};
    printf("Anwser : %lld", longest_stat(arr, 7));
    return 0;

}
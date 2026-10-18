# include <stdio.h>
# include <stdbool.h>
# include <stdlib.h>
# define int long long

bool is_symetric (int arr[], int length) {
    for (int i = 0; i<length/2; i++) {
        if (arr[i] != arr[length-1-i]) {
            return false;
        }
    }
    return true;
}

signed main () {
    int arr[] = {1, 2, 3, 4, 4, 3, 2, 1};
    printf("Anwser : %d\n", is_symetric(arr, 8));
    return 0;
}
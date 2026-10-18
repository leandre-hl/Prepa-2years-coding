# include <stdio.h>
# include <stdbool.h>
# include <stdlib.h>
# define int long long

void print_arr(int arr[], int length) {
    printf("Arr (size : %lld) : [", length);
    for (int i=0; i<length-1; i++) {
        printf("%lld, ", arr[i]);
    }
    printf("%lld]\n", arr[length-1]);
}

void invcum (int arr[], int length) {
    for (int i=length-1; i>0; i--) {
        arr[i] -= arr[i-1];
    }
}

void cumsum (int arr[], int length) {
    for (int i=1; i<length; i++) {
        arr[i] += arr[i-1];
    }
}

signed main () {
    int length = 8;
    int arr[] = {1, 2, 3, 4, 4, 7, 8, 1};
    print_arr(arr, length);
    cumsum(arr, length);
    print_arr(arr, length);
    invcum(arr, length);
    print_arr(arr, length);
    return 0;
}
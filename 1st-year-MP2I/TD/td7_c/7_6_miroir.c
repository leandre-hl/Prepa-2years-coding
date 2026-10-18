# include <stdio.h>
# include <stdbool.h>
# include <stdlib.h>
# define int long long


void swap(int arr[], int i, int j) {
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}

void reverse (int arr[], int length) {
    for (int i = 0; i<length/2; i++) {
        if (arr[i] != arr[length-1-i]) {
            swap(arr, i, length-1-i);
        }
    }
}

signed main () {
    int arr[] = {1, 2, 3, 4, 4, 7, 8, 1};
    reverse(arr, 8);
    return 0;
}
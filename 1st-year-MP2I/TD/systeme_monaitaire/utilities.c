# include <stdio.h>
# include <stdbool.h>
# include <stdlib.h>
# define int long long

int* createIntArray(int n) {
    // Allocate memory for n integers
    int* arr = (int*)malloc(n * sizeof(int));
    
    // Check if memory allocation was successful
    if (arr == NULL) {
        printf("Memory allocation failed!\n");
        return NULL;
    }
    return arr;
}

void print_arr(int arr[], int length) {
    printf("Arr (size : %lld) : [", length);
    for (int i=0; i<length-1; i++) {
        printf("%lld, ", arr[i]);
    }
    printf("%lld]\n", arr[length-1]);
}

void swap(int arr[], int i, int j) {
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}

int partition(int* arr, int length) {
    int p = arr[0];
    int i, j;
    for (i=1, j=1; j<length; j++) {
        if (arr[j] < p) {
            swap(arr, i, j);
            i++;
        }
    }
    // Remettre le pivot en place
    swap(arr, 0, i-1);
    return i-1;
}

void quicksort(int* arr, int length) {
    int pivot = partition(arr, length);
    if (pivot>=2) {
        quicksort(arr, pivot);
    }
    if (pivot <= length-2) {
        quicksort(&(arr[pivot+1]), length-pivot-1);
    }
}

void swap(int arr[], int i, int j) {
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}

signed main () {
    printf("Anwser : %lld\n", 42);
    return 0;
}
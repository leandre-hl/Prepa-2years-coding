#include "stdbool.h"

void swap(int* arr, int i, int j) {
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}

void bubble_sort(int* arr, int n) {
    // Invariant : les éléments [i, n[ sont bien placés
    for (int i=n ; i > 1; i--) {
        for (int j = 0; j < i - 1; j++) {
            if (arr[j] > arr[j+1]) {
                swap(arr, j, j+1);
            }
        }
    }
}

void bubble_sort_opti(int* arr, int n) {
    // Invariant : les éléments [i, n[ sont bien placés
    int i = n;
    while (i > 1) {
        int ilast_swap = 0; // Opti
        for (int j = 0; j < i - 1; j++) {
            if (arr[j] > arr[j+1]) {
                swap(arr, j, j+1);
                ilast_swap = j; // Opti
            }
        }
        i = ilast_swap + 1; // Opti
    }
}



void insertion_sort(int* arr, int n) {
    // Invariant : les éléments [0, i[ sont bien placés
    for (int i = 0; i<n; i++) {
        int j = i; // élément à insérer
        while (j > 0 && arr[j-1] > arr[j]) {
            swap(arr, j-1, j);
            j--;
        }
    }
}



void selection_sort(int* arr, int n) {
    // Invariant : les éléments [0, i[ sont bien placés
    for (int i = 0; i<n; i++) {
        int imin = i;
        for (int j = i; j<n; j++) {
            if (arr[j] < arr[imin]) imin = j;
        }
        swap(arr, imin, i);
    }
}



int partition(int* arr, int n) {
    // Invariant : pivot en position 0,
    // [1, i[ éléments <= piv
    // [i, j[ non examinés
    // [j, n[ éléments > piv
    int piv = arr[0];
    int i = 1;
    int j = n;
    while (j > i) {
        if (arr[i] <= piv) i++;
        else {
            swap(arr, i, j-1);
            j--;
        }
    }
    swap(arr, 0, i-1); // On remet le pivot
    return i-1;
}

void quick_sort(int* arr, int n) {
    if (n <= 1) return;

    int i = partition(arr, n);
    // [0, i[ : éléments <= piv
    // en i : piv
    // [i+1, n[ : éléments > piv
    quick_sort(arr, i);
    quick_sort(&arr[i+1], n-i-1);
}


void merge(int* arr, int n, int* tmp) {
    int mid = n/2;
    int left = 0;
    int right = mid;
    int i = 0;

    while (left < mid && right < n) {
        if (arr[left] <= arr[right]) {
            tmp[i] = arr[left];
            left++;
        } else {
            tmp[i] = arr[right];
            right++;
        }
        i++;
    }

    // On recopie les éléments restants de gauche
    while (left < mid) {
        tmp[i] = arr[left];
        left++;
        i++;
    }

    for (i = 0; i < right; i++) {
        arr[i] = tmp[i];
    }
}

void merge_sort_rec(int* arr, int n, int* tmp) {
    if (n <= 1) return;

    int mid = n/2;
    merge_sort_rec(arr, mid, tmp);
    merge_sort_rec(arr + mid, n - mid, tmp);
    merge(arr, n, tmp);
}

void merge_sort(int* arr, int n) {
    int* tmp = malloc(n * sizeof(*tmp));
    merge_sort_rec(arr, n, tmp);
    free(tmp);
}




void repair_up(int* heap, int i) {
    while (i > 0 && heap[(i-1)/2] > heap[i]) {
        swap(heap, (i-1)/2, i);
        i = (i-1)/2;
    }
}

void insert_heap(int* heap, int n, int x) {
    heap[n] = x;
    repair_up(heap, n);
}

void repair_down(int* heap, int i, int n) {
    while (true) {
        int g = 2*i + 1;
        int d = 2*i + 2;
        int imin = i;
        if (g < n && heap[imin] > heap[g]) imin = g;
        if (d < n && heap[imin] > heap[d]) imin = d;
        if (imin == i) break;

        swap(heap, i, imin);
        i = imin;
    }
}

int extract_min_heap(int* heap, int n) {
    int min = heap[0];
    swap(heap, 0, n-1);
    repair_down(heap, 0, n-1);
    return min;
}


void heap_sort(int* arr, int n) {
    int* heap = malloc(n*sizeof(*heap));
    for (int i = 0; i<n; i++) {
        insert_heap(heap, i, arr[i]);
    }
    for (int i = 0; i<n; i++) {
        arr[i] = extract_min_heap(heap, n-i);
    }
    free(heap);
}
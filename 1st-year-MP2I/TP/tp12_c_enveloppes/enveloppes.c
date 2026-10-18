#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// Nuage utilisé en exemple (trié par abscisses croissantes)
int pts_1[][2] = {{0,0}, {1,4}, {1,8}, {4,1}, {4,4}, {5,9},
                  {5,6}, {7,-1}, {7,2}, {8,5}, {11,6}, {13,1}};

// Nuage utilisé en exemple (ordre des points aléatoire)
int pts_2[][2] = {{4,4}, {8,5}, {13,1}, {0,0}, {11,6}, {4,1},
                  {7,2}, {5,6}, {7,-1}, {1,8}, {5,9}, {1,4}};

// Autre nuage de test
int pts_3[][2] = {{-2,-3}, {4,-1}, {2,-2}, {0,3}, {6,1}, {8,2},
                  {9,1}, {1,0}, {5,3}, {-1,-1}, {7,-3}, {3,4}};

int buffer[12];

//------------------------------------------------------------------
// Fonctions communes

int orientation(int pts[][2], int i, int j, int k) {
    if (i==j || j==k || i==k) return 0;
    int x1 = pts[j][0]-pts[i][0];
    int y1 = pts[j][1]-pts[i][1];
    int x2 = pts[k][0]-pts[i][0];
    int y2 = pts[k][1]-pts[i][1];
    int vect = x1*y2 - y1 * x2;
    if (vect < 0) {
        return -1;
    }
    return vect > 0;
}

//------------------------------------------------------------------
// Méthode de Jarvis

int lowest(int pts[][2], int n) {
    int min = 0;
    for (int i = 0; i<n; i++) {
        if (pts[i][1] < pts[min][1] || (pts[i][1] == pts[min][1] && pts[i][0] < pts[min][0])) {
            min = i;
        }
    }
    return min;
}

int next(int pts[][2], int n, int i) {
    int max = (i == 0) ? 1 : 0;
    for (int j=0; j<n; j++) {
        if (j!=i && orientation(pts, i, max, j) <= 0) {
            max = j;
        }
    }
    return max;
}

int jarvis(int pts[][2], int n, int* buffer) {
    int count = 0;
    int fst = lowest(pts, n);
    int curr = fst;
    while ((curr != fst || count == 0) && count < n) {
        buffer[count] = curr;
        curr = next(pts, n, curr);
        count++;
    }
    return count;
}

//------------------------------------------------------------------
// Méthode de Graham

void swap(int pts[][2], int i, int j) {
    int xtmp = pts[i][0];
    int ytmp = pts[i][1];
    pts[i][0] = pts[j][0];
    pts[i][1] = pts[j][1];
    pts[j][0] = xtmp;
    pts[j][1] = ytmp;
}

int partition(int pts[][2], int n) {
    if (n<=1) return 0;
    int i=0, j=1;
    swap(pts, 0, rand() % n);
    while (j<n) {
        if (pts[0][0] > pts[j][0] || (pts[j][0] == pts[0][0] && pts[0][1] > pts[j][1])) {
            i++;
            swap(pts, i, j);
        }
        j++;
    }
    swap(pts, 0, i);
    return i;
}

void sort(int pts[][2], int n) {
    int p = partition(pts, n);
    if (p>=2) {
        sort(pts, p);
    }
    if (p<=n-2) {
        sort(&(pts[p+1]), n-p-1);
    }
}

struct stack {
    int* data;
    int size;
};

typedef struct stack Stack;

Stack create(int n) {
    // à compléter
    Stack s = { .data = NULL, .size = 0 };
    return s;
}

bool is_empty(Stack s) {
    // à modifier
    return true;
}

void push(int elem, Stack s) {
    // à compléter
}

int top(Stack s) {
    // à modifier
    return 0;
}

int pop(Stack s) {
    // à modifier
    return 0;
}

void delete(Stack s) {
    // à compléter
}

void update_upper(int pts[][2], Stack upper_env, int i) {
    // à compléter
}

void update_lower(int pts[][2], Stack lower_env, int i) {
    // à compléter
}

int graham(int pts[][2], int n, int* buffer) {
    // à compléter
    return 0;
}

//------------------------------------------------------------------
// Fonctions d'affichage

void disp_points(int pts[][2], int n) {
    // Affiche le nuage de points
    // Note : certains points peuvent ne pas être affichés s'ils sont
    // sur la même ligne et trop proches
    int minx = pts[0][0], maxx = pts[0][0];
    int miny = pts[0][1], maxy = pts[0][1];
    for (int i=1; i<n; ++i) {
        if (pts[i][0] < minx) { minx = pts[i][0]; }
        if (pts[i][0] > maxx) { maxx = pts[i][0]; }
        if (pts[i][1] < miny) { miny = pts[i][1]; }
        if (pts[i][1] > maxy) { maxy = pts[i][1]; }
    }
    for (int y=maxy; y>=miny; y--) {
        for (int x=minx*2-2; x<=maxx*2+2; x++) {
            bool not_found = true;
            for (int i=0; i<n; ++i) {
                if (x==2*pts[i][0] && y==pts[i][1]) {
                    printf("+%d", i);
                    x += 1;
                    while (i>=10) { x++; i/=10; }
                    not_found = false;
                    break;
                }
            }
            if (not_found) { printf(" "); }
        }
        printf("\n");
    }
}

void print_array(int* buffer, int n) {
    printf("[");
    for (int i=0; i<n-1; ++i) { printf("%d, ", buffer[i]); }
    if (n) { printf("%d", buffer[n-1]); }
    printf("]\n");
}

void print_points(int pts[][2], int n) {
    printf("[");
    for (int i=0; i<n-1; ++i) {
        printf("(%d, %d), ", pts[i][0], pts[i][1]);
    }
    if (n) {
        printf("(%d, %d)", pts[n-1][0], pts[n-1][1]);
    }
    printf("]\n");
}

int main(void) {
    print_points(pts_3, 12);
    sort(pts_3, 12);
    print_points(pts_3, 12);

    // Test de la méthode de Jarvis
    // int buffer[12] = {0};
    // int nb = 0;
    // nb = jarvis(arr_1, 12, buffer)
    // print_array(buffer, nb);

    // Test de la méthode de Graham
    // int buffer[12] = {0};
    // int nb = 0;
    // nb = graham(arr_1, 12, buffer)
    // print_array(buffer, nb);

    return 0;
}

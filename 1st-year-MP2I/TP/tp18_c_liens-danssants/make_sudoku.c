#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>

int sudoku[9][9] = {{0,0,0,8,0,1},
                    {0,0,0,0,0,0,0,4,3},
                    {5},
                    {0,0,0,0,7,0,8},
                    {0,0,0,0,0,0,1},
                    {0,2,0,0,3},
                    {6,0,0,0,0,0,0,7,5},
                    {0,0,3,4},
                    {0,0,0,2,0,0,6}
                };


int main() {
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            printf("R%d%d ", i, j+1); // Row
            printf("C%d%d ", i, j+1); // Col
            printf("S%d%d ", i, j+1); // Square
        }
    }
    for (int i=0; i<9; i++) {
        for (int j=0; j<9; j++) {
            if (sudoku[i][j] == 0) {
                for (int k=1; k<9; k++) {
                    bool ok = true;
                    for (int l=0; l<9 && ok; l++) {
                        if (sudoku[l][j] == k) ok = false;
                        if (sudoku[i][j] == k) ok = false;
                        if (sudoku[(i/3)*3+(l%3)][(j/3)*3+l/3]) ok = false;
                    }
                    if (ok) {
                        printf("\n");
                        printf("\n");
                        printf("R%d%d ", i, k); // Row
                        printf("C%d%d ", j, k); // Col
                        printf("S%d%d ", (i/3)*3 + (j/3), k); // Square
                    }
                }
            }
        }
    }
}
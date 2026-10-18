# include <stdio.h>
# include <stdbool.h>
# include <stdlib.h>
# define NMAX 1000

bool grid[2*NMAX+1][2*NMAX+1] = {false};

int backtrack(int n, int x, int y, int curr_length) {
    if (curr_length == n) {
        return 1;
    }
    
    int sum = 0;

    // Droite
    if (!grid[x+1][y]) {
        grid[x+1][y] = true;
        sum += backtrack(n, x+1, y, curr_length+1);
        grid[x+1][y] = false;
    }
    
    // Gauche
    if (!grid[x-1][y]) {
        grid[x-1][y] = true;
        sum += backtrack(n, x-1, y, curr_length+1);
        grid[x-1][y] = false;
    }
    
    // Haut
    if (!grid[x][y+1]) {
        grid[x][y+1] = true;
        sum += backtrack(n, x, y+1, curr_length+1);
        grid[x][y+1] = false;
    }
    
    // Droite
    if (!grid[x][y-1]) {
        grid[x][y-1] = true;
        sum += backtrack(n, x, y-1, curr_length+1);
        grid[x][y-1] = false;
    }

    return sum;
}

int main() {
    int n = 21;
    grid[n][n] = true;
    printf("Nombre de chemins auto-evitants de taille %d :\n", n);
    printf("%d\n", backtrack(n, n, n, 0));
    return 0;
}
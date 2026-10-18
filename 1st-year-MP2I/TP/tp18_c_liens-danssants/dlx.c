#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

const int maxlen = 1000;
char* no_string = "Erreur";

//-----------------------------------
// Node structure and allocation

struct node {
    struct node* u;
    struct node* d;
    struct node* l;
    struct node* r;
    struct node* c;
    char* name;
    int nb;
};

typedef struct node Node;

Node* new_node(void) {
    Node* n = (Node*)malloc(sizeof(Node));
    // If allocation fail
    if (n==NULL) { fprintf(stderr, "Node allocation failed\n"); exit(-1); }
    // Initialisation
    n->u = n; n->d = n; n->l = n; n->r = n;
    n->c = n; n->name = no_string;
    n->nb = 0;
    return n;
}

//-----------------------------------
// File analysis

char* strdup2(char* s) {
    // Create a copy of a string (allocating memory for it first)
    // If you compile the file with GNU extension, comment this function!
    int len = strlen(s);
    char* result = (char*)malloc((len+1)*sizeof(char));
    if (result == NULL) { return NULL; }
    memcpy(result, s, len+1);
    return result;
}

int get_offer(char* buffer, Node* h, Node* provides[], int line_counter) {
    // This function takes:
    //   - a string (char* buffer) containing an offer
    //   - a pointer to the node h of a DLX structure
    //   - an array of Node* to fill (large enough)
    //   - the index of the line (for error messages)

    // You DO NOT need to understand this function!
    // It fills the (beginning) of the array "provides"
    // with pointers to nodes in the header line of the DLX structure
    // corresponding to objects provided by the offer in the buffer,
    // and returns the number of objets in the offer

    // Read elements and fill boolean "offered" array
    Node* ptr = NULL;

    // Count all objects
    int nb=0;
    for (Node* ptr = h->r; ptr != h; ptr=ptr->r) { nb++; }

    // Allocate a boolean array with a cell for each object
    bool* offered = malloc(nb * sizeof(bool));
    for (int i=0; i<nb; ++i) { offered[i] = false; }

    // Read buffer
    for (char* tok = strtok(buffer, " \r\n"); tok != NULL; tok = strtok(NULL, " \r\n")) {
        // Compute index i of object named like tok
        Node* ptr = h->r;
        int i=0;
        while (ptr != h && strcmp(ptr->name, tok))
            { ptr = ptr->r; i++; }
        if (ptr == h)
            { fprintf(stderr, "Unknown token <%s> line <%d>\n", tok, line_counter); exit(-1); }
        if (offered[i])
            { fprintf(stderr, "Duplicate token <%s> line <%d>\n", tok, line_counter); exit(-1); }
        offered[i] = true;
    }

    // Use "offered" boolean array to fill "provides" array of pointers
    int nb_pr = 0;
    ptr = h->r;
    for (int i=0; i<h->nb; ++i, ptr = ptr->r)
        { if (offered[i]) { provides[nb_pr] = ptr; nb_pr++; } }

    // Offers can't be empty!
    if (nb_pr == 0)
        { fprintf(stderr, "No token line <%d>\n", line_counter); exit(-1); }

    // Free the boolean array and returns the number of objects in the offer.
    free(offered);
    return nb_pr;
}

Node* load_file(char* filename) {
    // Open file
    FILE* f = fopen(filename, "r");
    if (f==NULL) { fprintf(stderr, "Can't open file <%s>\n", filename); exit(-1); }

    // Reference node
    Node* h = new_node();
    h->name = "<>";

    // Buffer to read data
    char* buffer = (char*)malloc(maxlen*sizeof(char));

    // First line (list of objects)
    fgets(buffer, maxlen, f);
    char* str_token = strtok(buffer, " \r\n");
    while (str_token != NULL) {
        // Another object!
        h->nb++;

        // Create a new header node
        Node* n = new_node();
        n->name = strdup2(str_token);
        n->nb = 0;

        // Attach node to existing ones
        // Theres 4 pointers to set (two from node n, two pointing to node n)
        n->l = h->l;
        n->r = h;
        h->l->r = n;
        h->l = n;

        // Get next name
        str_token = strtok(NULL, " \r\n");
    }

    // Read each offers (one per line)
    int line_counter = 0;
    Node** provides = malloc(h->nb * sizeof(Node*));

    while (!feof(f)) {
        line_counter++;
        // Read line
        if (fgets(buffer, maxlen, f)) {
            // Get number of objects and fill "provides" from buffer
            int nb_pr = get_offer(buffer, h, provides, line_counter);

            // Create nodes
            // Create nb_pr nodes and set/update 7 pointers for each node
            // (5 from the node (u, d, l, r, c), 2 pointing to the node)
            for(int i=0; i<nb_pr; i++) {
                provides[i]->nb++;

                Node* n = new_node();
                n->c = provides[i];

                n->u = provides[i]->u;
                provides[i]->u->d = n;

                n->d = provides[i];
                provides[i]->u = n;
            }

            for (int i=0; i<nb_pr; i++) {
                provides[i]->u->l = provides[(i-1+nb_pr)%nb_pr]->u;
                provides[i]->u->r = provides[(i+1)%nb_pr]->u;
            }
        }
    }
    // Close file
    fclose(f);
    return h;
}

//-----------------------------------
// Display functions

void print_line(Node* n) {
    printf("%s ", n->c->name);
    for(Node* i = n; i->r != n; i = i->r) {
        printf("%s ", i->r->c->name);
    }
    printf("\n");
}

void test_print_line(void) {
    char* opts[] = { "DE", "FAITE", "UNE", "BONNE", "CHOSE", "Erreur" };
    Node array[10];
    for (int i=0; i<5; ++i) {
        array[i].u = &(array[i+5]);
        array[i].d = &(array[i+5]);
        array[i].r = &(array[(i+1)%5]);
        array[i].l = &(array[(i+4)%5]);
        array[i].c = &(array[i]);
        array[i].name = opts[i];

        array[i+5].c = &(array[i]);
        array[i+5].u = &(array[i]);
        array[i+5].d = &(array[i]);
        array[i+5].r = &(array[(i+1)%5+5]);
        array[i+5].l = &(array[(i+4)%5+5]);
        array[i+5].name = opts[5];
    }
    print_line(&(array[7]));
}

void print_solution(Node** output, int k) {
    // used to keep track of solution number
    static int counter=0;
    counter++;

    // Display solution
    printf("Solution #%d:\n", counter);
    for (int i=0; i<k; ++i) {
        printf("  ");
        print_line(output[i]);
    }
}

void explore_str(Node* n, char* str) {
    printf("%p\n", (void*)n);
    if (!n) { return; }
    if (*str=='u') { printf("<UP>    "); explore_str(n->u, str+1); } else
    if (*str=='d') { printf("<DOWN>  "); explore_str(n->d, str+1); } else
    if (*str=='l') { printf("<LEFT>  "); explore_str(n->l, str+1); } else
    if (*str=='r') { printf("<RIGHT> "); explore_str(n->r, str+1); } else
    if (*str=='c') { printf("<COL>   "); explore_str(n->c, str+1); } else
    if (*str!='\0') { printf("Unknown direction <%c> in string\n", *str); }
}

//-----------------------------------
// Linked list functions

void remove_h(Node* n) {
    n->l->r = n->r;
    n->r->l = n->l;
}

void replace_h(Node* n) {
    n->l->r = n;
    n->r->l = n;
}

void remove_v(Node* n) {
    n->u->d = n->d;
    n->d->u = n->u;
    n->c->nb--;
}

void replace_v(Node* n) {
    n->u->d = n;
    n->d->u = n;
    n->c->nb++;
}

//-----------------------------------
// Covering functions

void cover(Node* c) {
    remove_h(c);
    for (Node* s = c->d; s!=c; s = s->d) {
        for (Node* r = s->r; r!=s; r = r->r) {
            remove_v(r);
        }
    }
}

void uncover(Node* c) {
    for (Node* s = c->u; s!=c; s = s->u) {
        for (Node* r = s->l; r!=s; r = r->l) {
            replace_v(r);
        }
    }
    replace_h(c);
}

//-----------------------------------
// Backtracking resolution

Node* choose_column(Node* h) {
    Node* min = h->r;
    for (Node* c = h->r->r; c!=h; c = c->r) {
        if (c->nb < min->nb) {
            min = c;
        }
    }
    return min;
}

void search(int k, Node* h, Node** output) {
    if (h->r == h) { print_solution(output, k); return; }

    // Choose column
    Node* c = choose_column(h);

    // Backtracking
    cover(c);
    for (Node* r = c->d; r!=c; r = r->d) {
        output[k] = r;
        for(Node* s = r->r; s!=r; s = s->r) { cover(s->c);}

        search(k+1, h, output);

        for(Node* s = r->l; s!=r; s = s->l) { uncover(s->c);}
    }
    uncover(c);
}

void solve(Node* h) {
    Node** output = (Node**)malloc(h->nb*sizeof(Node*));
    if (output==NULL) { fprintf(stderr, "Allocation of output failed\n"); exit(-1); }
    search(0, h, output);
}

//-----------------------------------
// Main program

int main(void) {
    // Test de print_line
    /*
    printf("Test de print_line : ");
    fflush(stdout);
    test_print_line();
    fflush(stdout);
    */

    // Lecture du fichier dlx
    Node* h = load_file("reines.dlx");

    // Tests d'affichage de la liste des options
    /*
    printf("Options (attendu A B C D E F) : ");
    fflush(stdout);
    print_line(h);
    fflush(stdout);
    

    // Test d'affichage de la première ligne
    
    printf("Première ligne (attendu : A C) : ");
    fflush(stdout);
    print_line(h->r->d);
    fflush(stdout);
    

    // Test d'affichage de la troisième ligne

    printf("Troisième ligne (attendu : B E F) : ");
    fflush(stdout);
    print_line(h->l->u->r);
    fflush(stdout);


    // Test de remove_h (doit afficher F B ou B F)
    printf("Test remove_h (attendu : F B) : ");
    fflush(stdout);
    Node* tmph = h->l->u->l;
    remove_h(tmph);
    print_line(h->l->u);
    fflush(stdout);

    // Test de replace_h (doit afficher F B E ou équivalent)
    printf("Test replace_h (attendu : F B E) : ");
    fflush(stdout);
    replace_h(tmph);
    print_line(h->l->u);
    fflush(stdout);

    // Test de couverture
    Node* tmp1 = h->r->r->r;
    cover(tmp1);
    printf("Test cover (attendu : <> A B D E F) : ");
    fflush(stdout);
    print_line(h);             // Doit afficher <> A B D E F
    fflush(stdout);
    printf("Test cover (attendu : D) : ");
    fflush(stdout);
    print_line(h->l->l->l->d); // Doit affichier D
    fflush(stdout);
    Node* tmp2 = h->r->r->r->r;
    cover(tmp2);
    printf("Test cover (attendu : <> A B D F) : ");
    fflush(stdout);
    print_line(h);             // Doit afficher <> A B D F
    fflush(stdout);

    // Test de rétablissement
    uncover(tmp2);
    uncover(tmp1);
    printf("Test uncover (attendu : <> A B C D E F) : ");
    fflush(stdout);
    print_line(h);             // Doit afficher <> A B C D E F
    fflush(stdout);
    printf("Test uncover (attendu : D A C) : ");
    fflush(stdout);
    print_line(h->l->l->l->d); // Doit affichier D A C
    fflush(stdout);
    */
    
    // Résolution du problème
    solve(h);
    
    return 0;
}

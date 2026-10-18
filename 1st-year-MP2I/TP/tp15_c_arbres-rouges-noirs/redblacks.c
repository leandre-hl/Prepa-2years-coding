#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

//--------------------------------------------------------------------
// Tree structure

struct node {
    bool is_red;
    int value;
    struct node* parent;
    struct node* lchild;
    struct node* rchild;
};

typedef struct node Node;

//--------------------------------------------------------------------
// Tree nodes manipulation

Node* new_node(bool is_red, int value) {
    Node* node = (Node*)malloc(sizeof(Node));
    node->value = value;
    node->is_red = is_red;
    node->parent = NULL;
    node->lchild = NULL;
    node->rchild = NULL;
    return node;
}

void attach_left(Node* parent, Node* child) {
    // attach node child (or nothing) as left child of node parent
    // parent should NEVER be NULL, but child can be NULL
    if (parent->lchild) {
        parent->lchild->parent = NULL;
    }
    parent->lchild = child;

    if (child) {
        if (child->parent) {
            if (child->parent->lchild == child) {
                child->parent->lchild = NULL;
            } else {
                child->parent->rchild = NULL;
            }
        }
        child->parent = parent;
    }
}

void attach_right(Node* parent, Node* child) {
    // attach node child (or nothing) as right child of node parent
    // parent should NEVER be NULL, but child can be NULL
    if (parent->rchild) {
        parent->rchild->parent = NULL;
    }
    parent->rchild = child;

    if (child) {
        if (child->parent) {
            if (child->parent->lchild == child) {
                child->parent->lchild = NULL;
            } else {
                child->parent->rchild = NULL;
            }
        }
        child->parent = parent;
    }
}

//--------------------------------------------------------------------
// General tree functions

int size(Node* tree) {
    // Returns the size of the tree
    if (tree == NULL) return 0;
    return 1 + size(tree->lchild) + size(tree->rchild);
}

int get_values(Node* tree, int array[]) {
    // Put all values stored in the tree in the array
    // the values should be ordered as infix depth-first search
    //
    // The function returns the number of values written
    if (tree == NULL) return 0;

    int n = get_values(tree->lchild, array);
    array[n] = tree->value;
    return n + 1 + get_values(tree->rchild, &(array[n+1]));
}

void disp_node(Node* node) {
    if (node) {
        if (node->is_red) {
            printf("\033[101mR %d\033[0m", node->value);
        } else {
            printf("\033[100mB %d\033[0m", node->value);
        }
    } else {
        printf("None");
    }
}

int width_node(int v) {
    int w = 2;
    if (v<=0) { w++; }
    while (v) { w++; v/=10; }
    return w;
}

bool disp_tree_depth(Node* node, int p) {
    bool res = false;
    if (!node) { return false; }
    res = disp_tree_depth(node->lchild, p-1) || res;
    if (!p) {
        disp_node(node);
        res = true;
    } else {
        for (int i=0; i<width_node(node->value); ++i) { printf(" "); }
    }
    res = disp_tree_depth(node->rchild, p-1) || res;
    return res;
}

void disp_tree(Node* node) {
    // Display a red-black tree in terminal
    if (!node) {
        printf("Empty tree\n");
        return;
    }
    bool goon = true;
    for (int i=0; goon; i++) {
        goon = disp_tree_depth(node, i);
        printf("\n");
    }
}

void disp_values(Node* tree) {
    // Display values of a binary tree
    // This function depends on functions size and get_values!
    // For binary search trees, the values should be non-decreasing

    int nb = size(tree);
    int* tab = (int*)malloc(nb*sizeof(int));
    if (tab) {
        get_values(tree, tab);
        printf("Values = [ ");
        for (int i=0; i<nb; ++i) { printf("%d ", tab[i]); }
        printf("]\n");
        free(tab);
    }
}

bool is_bst(Node* tree) {
    // Returns true if the tree is a valid BST
    // returns false otherwise
    // Note : empty tree (NULL) is a valid BST

    int nb = size(tree);
    int* tab = (int*)malloc(nb*sizeof(int));
    if (tab) {
        get_values(tree, tab);
        for (int i=0; i<nb-1; ++i) {
            if (tab[i] > tab[i+1]) {
                return false;
            }
        }
        free(tab);
    }
    return true;
}

//--------------------------------------------------------------------
// Moving in the tree

Node* parent(Node* node) {
    // returns pointer to parent if possible
    // returns NULL if node is NULL or tree is root
    if (!node) { return NULL; }
    return node->parent;
}

Node* lchild(Node* node) {
    // returns pointer to left child if there's one
    // returns NULL if node is NULL or no left child
    if (node) return node->lchild;
    return NULL;
}

Node* rchild(Node* node) {
    // returns pointer to right child if there's one
    // returns NULL if node is NULL or no right child
    if (node) return node->rchild;
    return NULL;
}

Node* brother(Node* node) {
    // returns pointer to brother if there's one
    // returns NULL if node is NULL or has no brother
    if (node == NULL || node->parent == NULL) return NULL;
    if (node->parent->lchild == node) return node->parent->rchild;
    return node->parent->lchild;
}

Node* greatparent(Node* node) {
    // returns pointer to great-parent if there's one
    // returns NULL if node is NULL or has no great-parent
    if (node && node->parent) {
        return node->parent->parent;
    }
    return NULL;
}

Node* uncle(Node* node) {
    // returns pointer to uncle if there's one
    // returns NULL if node is NULL or has no uncle
    if (node) {
        return brother(node->parent); // An uncle is the brother of the father of the node
    }
    return NULL;
}

//--------------------------------------------------------------------
// Testing the tree

bool is_root(Node* node) {
    // returns true if node is the root of the tree
    // returns false otherwise
    return node && node->parent == NULL;
}

bool is_left_child(Node* node) {
    // returns tree if node is left child of it
    return node && lchild(parent(node)) == node;
}

bool is_right_child(Node* node) {
    return node && rchild(parent(node)) == node;
}

bool is_red_node(Node* node) {
    return node && node->is_red;
}

bool is_black_node(Node* tree) {
    return tree && !tree->is_red;
}

//--------------------------------------------------------------------
// Example of tree

struct rbdata { char type; int value; };

Node* build_tree(struct rbdata data[], int n) {
    Node* stack = NULL;
    for (int i=0; i<n; ++i) {
        if (data[i].type == 'X') {
            Node* node = new_node(false, 0);
            node->lchild = node;
            node->parent = stack;
            stack = node;
        } else {
            Node* node = new_node(data[i].type == 'R', data[i].value);
            node->rchild = stack;
            stack = node->rchild->parent;
            if (node->rchild->lchild == node->rchild) {
                free(node->rchild);
                node->rchild=NULL;
            } else {
                node->rchild->parent = node;
            }
            node->lchild = stack;
            stack = node->lchild->parent;
            if (node->lchild->lchild == node->lchild) {
                free(node->lchild);
                node->lchild=NULL;
            } else {
                node->lchild->parent = node;
            }
            node->parent=stack;
            stack=node;
        }
    }
    return stack;
}

struct rbdata ex_tree_data[] = { {'X',0}, {'X',0}, {'R',1}, {'X',0}, {'B',4}, {'X',0}, {'X',0}, {'R',10}, {'X',0}, {'X',0}, {'R',14}, {'B',11}, {'B',9}, {'X',0}, {'X',0}, {'B',22}, {'X',0}, {'X',0}, {'X',0}, {'R',29}, {'B',25}, {'X',0}, {'X',0}, {'X',0}, {'R',54}, {'B',42}, {'R',37}, {'B',23}, {'B',17} };

//--------------------------------------------------------------------
// Red-black trees constraints

bool has_double_red(Node* tree) {
    // return true if and only if there's a red node with a red parent
    if (tree) {
        if (tree->is_red) {
            if ((tree->lchild && tree->lchild->is_red) || (tree->rchild && tree->rchild->is_red)) {
                return true;
            }
        }
        return has_double_red(tree->lchild) || has_double_red(tree->rchild);
    }
    return false;
}

int black_height(Node* tree) {
    // Returns black height if correct, -1 if incorrect
    if (tree) {

        int lft_black_height = black_height(tree->lchild);
        int rgh_black_height = black_height(tree->rchild);
        if (lft_black_height != rgh_black_height || lft_black_height == -1) return -1;
        
        if (tree->is_red) return lft_black_height;
        else return 1 + lft_black_height;
    }
    return 1; // à compléter
}

bool is_rb_tree(Node* tree) {
    if (!tree) return true; // Un arbre vide est un arbre rouge noir
    else if (!tree->is_red && !has_double_red(tree) && black_height(tree) != -1) return true;
    return false;
}

//--------------------------------------------------------------------
// Search

Node* find(Node* tree, int value) {
    // returns pointer to node in tree whose label equals value
    // returns NULL if no such node exists

    if (tree == NULL) return NULL;
    else if (tree->value == value) return tree;
    else if (tree->value > value) return find(tree->lchild, value);
    else return find(tree->rchild, value);
}

bool mem(Node* tree, int value) {
    // returns true if there's a node whose label equals value
    // returns false if there's none

    return find(tree, value) != false; // à compléter
}

//--------------------------------------------------------------------
// Add

void rotate_left(Node* x) {
    // Rotate left on the node x
    Node* y = x->rchild;
    // Déplace le sous-arbre gauche de y comme sous-arbre droit de x
    x->rchild = y->lchild;
    if (y->lchild != NULL)
        y->lchild->parent = x;
    // Remonter y à la place de x
    y->parent = x->parent;
    if (x->parent != NULL) {
        if (x == x->parent->lchild)
            x->parent->lchild = y;
        else
            x->parent->rchild = y;
    }
    y->lchild = x;
    x->parent = y;
}

void rotate_right(Node* x) {
    // Rotate right on the node x

    Node* y = x->lchild;
    // Déplace le sous-arbre droit de y comme sous-arbre gauche de x
    x->lchild = y->rchild;
    if (y->rchild != NULL)
        y->rchild->parent = x;
    // Remonter y à la place de x
    y->parent = x->parent;
    if (x->parent != NULL) {
        if (x == x->parent->lchild)
            x->parent->lchild = y;
        else
            x->parent->rchild = y;
    }
    y->rchild = x;
    x->parent = y;
}

void repair_red(Node* node) {
    // Tant que le nœud n'est pas la racine et que son parent est rouge
    while (node != NULL && node->parent != NULL && node->parent->is_red) {
        Node* parent = node->parent;
        Node* grandparent = parent->parent;
        // Si le parent est le fils gauche du grand-parent
        if (parent == grandparent->lchild) {
            Node* uncle = grandparent->rchild; // le tonton
            // Cas 1 : le tonton existe et est rouge
            if (uncle != NULL && uncle->is_red) {
                parent->is_red = false;
                uncle->is_red = false;
                grandparent->is_red = true;
                // Remonter la réparation au niveau du grand-parent
                node = grandparent;
            } else {
                // Cas 2 : le nœud est le fils droit du parent
                if (node == parent->rchild) {
                    // Rotation à gauche sur le parent pour transformer en cas 3
                    rotate_left(parent);
                    node = parent;
                    parent = node->parent;
                }
                // Cas 3 : le nœud est le fils gauche du parent
                parent->is_red = false;
                grandparent->is_red = true;
                // Rotation à droite sur le grand-parent
                rotate_right(grandparent);
            }
        } else { 
            // Cas symétrique : le parent est le fils droit du grand-parent
            Node* uncle = grandparent->lchild; // le tonton
            // Cas 1 symétrique : le tonton existe et est rouge
            if (uncle != NULL && uncle->is_red) {
                parent->is_red = false;
                uncle->is_red = false;
                grandparent->is_red = true;
                node = grandparent;
            } else {
                // Cas 2 symétrique : le nœud est le fils gauche du parent
                if (node == parent->lchild) {
                    // Rotation à droite sur le parent pour transformer en cas 3
                    rotate_right(parent);
                    node = parent;
                    parent = node->parent;
                }
                // Cas 3 symétrique : le nœud est le fils droit du parent
                parent->is_red = false;
                grandparent->is_red = true;
                // Rotation à gauche sur le grand-parent
                rotate_left(grandparent);
            }
        }
    }
    // Après correction, il faut s'assurer que la racine soit noire.
    // On remonte jusqu'à la racine.
    Node* root = node;
    while (root && root->parent != NULL)
        root = root->parent;
    if (root != NULL)
        root->is_red = false;
}

Node* add(Node* tree, int value) {
    if (tree == false) return new_node(true, value);
    else if (value < tree->value) {
        if (tree->lchild) {add(tree->lchild, value); return tree;}
        attach_left(tree, new_node(true, value));
        disp_tree(tree);
        repair_red(tree->lchild);
    }
    else if (value > tree->value) {
        if (tree->rchild) {add(tree->rchild, value); return tree;}
        attach_right(tree, new_node(true, value));
        disp_tree(tree);
        repair_red(tree->rchild);
    }
    return tree;
}

//--------------------------------------------------------------------
// Remove

//--------------------------------------------------------------------
// Main program

int main(void) {
    /*
    Node* my_tree = new_node(false, 5);
    attach_left(my_tree, new_node(false, 3));
    attach_right(my_tree, new_node(true, 42));
    attach_left(my_tree->rchild, new_node(true, 12));

    disp_tree(my_tree);
    printf("%d\n", size(my_tree));
    disp_values(my_tree);
    */
    /*
    Node* ex_tree = build_tree(ex_tree_data,
                          sizeof(ex_tree_data)/sizeof(struct rbdata));
    disp_tree(ex_tree);
    printf("%d\n", size(ex_tree));
    disp_values(ex_tree);
    printf("%d\n", has_double_red(ex_tree));
    printf("%d\n", black_height(ex_tree));*/
    /*
    printf("%d ", mem(ex_tree, 42));
    printf("%d ", mem(ex_tree, 22));
    printf("%d ", mem(ex_tree,  1));
    printf("%d ", mem(ex_tree, 54));
    printf("%d ", mem(ex_tree, -1));
    printf("%d ", mem(ex_tree, 15));
    printf("%d ", mem(ex_tree, 68));
    printf("\n");

    printf("Le père de 37 est ");
    disp_node( parent( find(ex_tree, 37) ) );
    printf("\n");
    printf("Le fils gauche de 37 est ");
    disp_node( lchild( find(ex_tree, 37) ) );
    printf("\n");
    printf("Le fils droit de 37 est ");
    disp_node( rchild( find(ex_tree, 37) ) );
    printf("\n");
    printf("Le frère de 37 est ");
    disp_node( brother( find(ex_tree, 37) ) );
    printf("\n");
    printf("L'oncle de 37 est ");
    disp_node( uncle( find(ex_tree, 37) ) );
    printf("\n");
    printf("Le grandpère de 37 est ");
    disp_node( greatparent( find(ex_tree, 37) ) );
    printf("\n");
    */
    /*
    printf("Le père de 9 est ");
    disp_node( parent( find(ex_tree, 9) ) );
    printf("\n");
    printf("Le fils gauche de 9 est ");
    disp_node( lchild( find(ex_tree, 9) ) );
    printf("\n");
    printf("Le fils droit de 9 est ");
    disp_node( rchild( find(ex_tree, 9) ) );
    printf("\n");
    printf("Le frère de 9 est ");
    disp_node( brother( find(ex_tree, 9) ) );
    printf("\n");
    printf("L'oncle de 9 est ");
    disp_node( uncle( find(ex_tree, 9) ) );
    printf("\n");
    printf("Le grandpère de 9 est ");
    disp_node( greatparent( find(ex_tree, 9) ) );
    printf("\n");
    */

    Node* test_add = NULL;
    for (int i=1; i <= 20; i++) {
        test_add = add(test_add, i);
    }
    disp_tree(test_add);

    free(test_add);
    return 0;
}
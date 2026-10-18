
/********************************************************************/
/* Concours Centrale-Supélec                                        */
/* Sujet 0 - MPI                                                    */
/* https://www.concours-centrale-supelec.fr                         */
/* CC BY-NC-SA 3.0                                                  */
/********************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <assert.h>
#include <string.h>

struct node_s {
  char* key;
  int val;
  struct node_s* left;
  struct node_s* right;
};
typedef struct node_s node;

int lexcmp(char* s1, char* s2) {
  int i;
  for (i = 0; s1[i] != '\0' && s2[i] != '\0'; i++) {
    if (s1[i] < s2[i]) return -1;
    if (s1[i] > s2[i]) return  1;
  }
  if (s1[i] == '\0') {
    if (s2[i] == '\0') return 0;
    return -1;
  }
  return  1;
}

void print_bst_aux(node* bst, int p) {
  if (bst == NULL) {
    return;
  }
  print_bst_aux(bst->right, p + 1);
  for (int i = 0; i < p; i = i + 1) {
    printf("\t");
  }
  printf("%s : %d\n", bst->key, bst->val);
  print_bst_aux(bst->left, p + 1);
}

void print_bst(node* bst) {
  print_bst_aux(bst, 0);
}

node* delete_min(node* bst, node** min) {
  assert(bst != NULL);
  if (bst->left == NULL) {
    *min = bst;
    return bst->right;
  } else {
    bst->left = delete_min(bst->left, min);
    return bst;
  }
}

node* delete(char* key, node* bst) {
  if (bst == NULL) {
    return NULL;
  } else {
    int c = lexcmp(key, bst->key);
    if (c == 0) {
      node* new;
      if (bst->left == NULL) {
        new = bst->right;
      } else if (bst->right == NULL) {
        new = bst->left;
      } else {
        node* right = delete_min(bst->right, &new);
        new->right = right;
        new->left = bst->left;
      }
      free(bst->key);
      free(bst);
      bst = new;
    } else if (c < 0) {
      bst->left = delete(key, bst->left);
    } else {
      bst->right = delete(key, bst->right);
    }
    return bst;
  }
}

void free_bst(node* bst) {
  if (bst != NULL) {
    free_bst(bst->left);
    free_bst(bst->right);
    if (bst->key) free(bst->key);
    free(bst);
  }
}

node* insert(char* key, node* bst) {
  if (bst==NULL) {
    node* root = malloc(sizeof(*root));
    assert(root!=NULL);
    root->key = malloc((n + 1) * sizeof(char));
  assert(root->key != NULL);
  strcpy(key, root->key);
    root->left = NULL;
    root->right = NULL;
    return root;
  }
  int comp = lexcmp(key, bst->key);
  if (comp == 0) {
    bst->val++;
  }
  else if (comp == 1) {
    bst->right = insert(key, bst->right);
  }
  else {
    bst->left = insert(key, bst->left);
  }
  return bst;
}


void write_lexique_aux(FILE* f, node* bst) {
  if (bst != NULL) {
    fprintf(f, "%s %d\n", bst->key, bst->val);
    write_lexique_aux(f, bst->left);
    write_lexique_aux(f, bst->right);
  }
}


void lexique(char* file_src, char* file_dest) {
  FILE* f = fopen(file_src, "r");
  node* bst = NULL;
  char line[101];
  while (fscanf(f, "%s", line) != EOF) {
    bst = insert(line, bst);
  }
  fclose(f);

  f = fopen(file_dest, "w");
  write_lexique_aux(f, bst);

  free_bst(bst);

  fclose(f);
}



int main(void) {
  /*
  node* bst = NULL;
  char* key = malloc(10*sizeof(char));
  for (int i = 0; i<10; i++) {
    key[i] = '\0';
  }
  key[0] = 'a';
  bst = insert(key, bst);
  print_bst(bst);
  key[1] = 'b';
  bst = insert(key, bst);
  print_bst(bst);
  bst = insert(key, bst);
  print_bst(bst);
  key[2] = 'c';
  bst = insert(key, bst);
  print_bst(bst);
  bst = insert(key, bst);
  print_bst(bst);

  bst = delete(key, bst);
  print_bst(bst);
  
  free(key);
  */

  lexique("data/les_trois_mousquetaires.txt", "lexiques/les_trois_mousquetaires.txt");
}

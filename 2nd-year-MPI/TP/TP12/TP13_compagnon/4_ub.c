#include <stdio.h>
#include <stdbool.h>


int main()
{
  bool p[10] = {false,false,false,false,false,false,false,false,false,false};
  int i = 0;
  while (i < 10 && !p[i])
  {
    printf("%d : %d\n", i, p[i]); 
    i++;
  }
  return 0;
}
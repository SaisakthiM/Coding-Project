#include <stdio.h>
#include <string.h>

int main() {
  char string[20];
  printf("Enter a String : ");
  fgets(string, sizeof(string), stdin);
  int size = sizeof(string);
  for (int i = 0; i < size; i++) {
    if (string[i] == 't') {
      memmove(&string[i], &string[i + 1], strlen(string) - i);
      i--;
    }
  }
  printf("%s", string);
}

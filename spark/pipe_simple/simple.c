#include <stdio.h>

int main (int argc, char *argv[]) {
  char str[100];

  while (1) {
    if (!fgets(str, 100, stdin)) {
      return 0;
    }
    printf("Hello, %s", str);
  }
}

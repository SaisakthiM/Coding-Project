#include <stdio.h>

int main() {
  int fhar, celsius, step;
  int lower = 0;
  int upper = 300;
  step = 20;
  fhar = lower;
  while (fhar <= upper) {
    celsius = 5 * (fhar - 32) / 9;
    printf("%d\t%d\n", fhar, celsius);
    fhar = fhar + step;
  }
  double x = 5.0 / 9.0;
  printf("%f", x);
}

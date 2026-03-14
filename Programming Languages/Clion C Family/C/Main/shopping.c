#include <stdio.h>

int main() {
  // Shopping Cart Program
  char item[50] = "";
  float price;
  int qty = 0;
  float total = 0.0f;

  printf("This is Shopping Cart Programm, \n Enter an Item : ");
  scanf("%s", item);
  printf("Enter a Price : ");
  scanf("%f", &price);
  printf("Enter the Quantity : ");
  scanf("%d", &qty);

  printf("The Total Money Needed is : ");
  total = price * (float)qty;
  printf("%f", total);
  return 0;
}

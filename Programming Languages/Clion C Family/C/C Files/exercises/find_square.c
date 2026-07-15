#include <cstdlib>
#include <inttypes.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int find() {
    int a;
    printf("Enter a number : ");
    scanf("%d",&a);

    for (int i = a; i > 0; i--) {
        int r = (int)sqrt(i);
        if (r * r == i) {
            printf("nearest square number is : %d", i);
            return 0;
        }
    };
    printf("no near square number");
    return 0;
}

int sum_of_digits() {
    int b;
    printf("Enter a number : ");
    scanf("%d",&b);

    int sum = 0;
    char str[10];
    sprintf(str, "%d", b);

    for (int i = 0; i < strlen(str); i++) {
        sum += (int) str[i] - '0';
    }
    return sum;

}

int division(int numerator, int denominator,int *dividend, int *_remainder) {
    if (denominator == 0) {
        return 0;
    }
    *dividend = numerator / denominator;
    *_remainder = numerator % denominator;
    return 0;
}
void learn() {
    /* 
     int a = 10;
    int b = a >> 1;
    printf("%d",b);
    printf("");
    printf("%d",~b);
    char arr[] = "abc";
    arr[3] = 'd';
    printf("%s", arr);
    printf("%i", arr[11211]);
    char arr[] = "abc";

    for (int i = 0; i < 10; i++) {
        printf("%p -> %d\n", (void *)&arr[i], arr[i]);
    }

    printf("%i",arr[-9999999999999999999]);
    char d[10] = "heloddddd";
    int instance_of_d = 0;

    int len_d = strlen(d);
    int j = 0;

    while (j < len_d) {
        if (d[j] == 'd') {
            instance_of_d += 1;
        }
        j++;
    };

    printf("%i", instance_of_d);

    char s[10],t[10];
    int i,j;
    strcpy(s,"frog");
    for (i=0; i<strlen(s); i++)
    t[i]=s[i];
    j=0;
    for (i=0; i<strlen(t); i++)
    j=j+(int)t[i];
    printf("%d\n",j);

    char name[50],first[25],last[25];
    printf("Enter a name : ");
    scanf("%s", name);
    int i = 1;
    first[0] = name[0];
    while (name[i] > 96 && name[i] < 123) {
        first[i] = name[i];
        i++;
    }
    first[i+1] = '\0';
    while (i < strlen(name)) {
        last[i] = name[i];
        i++;
    }
    last[i+1] = '\0';
    printf("%s", name);
    printf("%s", first);
    printf("%s", last);
    int c, *cp;
    c = 10;
    cp = &c;
    *cp = 1;
    printf("%i", c);
    printf("\n");
    printf("%p\nff", cp);
    int numerator = 100;
    int denominator = 10;
    int dividend, remainder;
    division(numerator, denominator, &dividend, &remainder);
    printf("%i\n", numerator);
    printf("%i\n", denominator);
    printf("%i\n", dividend);
    printf("%i\n", remainder);

    int n;
    printf("Enter the number of character of name : ");
    scanf("%i", &n);
    char name[n];
    printf("Enter the name : ");
    scanf("%s", name);
    printf("%s", name);

    char name[100];
    printf("Enter a name : ");
    scanf("%s", name);
    char* new_name = realloc(&name, sizeof(name) * 2);

    int* numbers;
    int k = integers(5, &numbers);
    int j;
    for (j = 0; j < 5; j++) {
        printf("%i\n", numbers[j]);
        printf("%p\n", &numbers[j]);
    }

    struct Teacher person;
    person.year = 1980;
    person.age = 46;
    char name[10] = "saisakthi";
    strcpy(person.name, name);
    person.ppg = 10.2;

    printf("%s", person.name);

    FILE *fpt;
    char text[800];
    fpt = fopen("output.txt","r");
    fscanf(fpt, "%s", text);
    printf("%s", text);
    
    */
}

int integers(int list_size, int** list) {
    int n;
    int i;
    *list = (int* ) malloc(list_size*sizeof(int));

    for (i = 0; i < list_size; i++) {
        (*list)[i] = i + 10;
    }
    return 0;
}

struct Teacher {
    char name[10];
    int age;
    int year;
    double ppg;
};



int main() {
    
}
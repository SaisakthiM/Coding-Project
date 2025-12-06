#include <stdio.h>

int sumArray(int arr[], int size) {
    int sum = 0; // Initialize sum to 0

    // Loop through each element of the array
    for (int i = 0; i < size; i++) {
        sum += arr[i]; // Add the current element to the sum
    }

    return sum; // Return the calculated sum
}

int main() {
    int numbers[] = {10, 20, 30, 40, 50}; // Declare and initialize an array
    int arraySize = sizeof(numbers) / sizeof(numbers[0]); // Calculate the size of the array

    // Call the sumArray function and store the result
    int totalSum = sumArray(numbers, arraySize);

    // Print the sum
    printf("The sum of the array elements is: %d\n", totalSum);
    int k = 0;

    do {
        printf("%d", k);
        k += 1;
    } while (k < 10);

    return 0;

    
}

/* */
#include <stdio.h>
int sum(int arr[],int n){
    int sum = 0;
    for (int i = 0; i < n; i++){
        sum += arr[i];
    }
    return sum;
}
int sum_2d(int arr[][10], int x, int y){
    int sum = 0;
    for (int i = 0; i < x; i++){
        for (int j = 0; j < y; j++){
            sum += arr[i][j];
        }
    }
    return sum;
}
int main(){
    int n = 10;
    int arr[] = {1,2,3,4,5,6,7,8,9,10};
    printf("%d",sum(arr,n));
}
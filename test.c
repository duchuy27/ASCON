#include <stdio.h>
#include <conio.h>

void soft(int arr[]){
    for (int i=0; i<arr.size(); i++){
        if(arr[i]>=100 && arr[i]<=999 && arr[i]%2==0){
            for (int j = i-1; j < 0; j--){
                if(i > 0){
                temp = arr[j];
                arr[j] = arr[i];
                arr[i] = temp;
                i--;
                }
            }
        }
    }
}

int main(){
    int arr[10];
    printf("nhap 10 so nguyen: ");
    
    for (int i = 0; i < 10; i++){
        scanf("%d", &arr[i]);
    }

    soft(arr);

    printf("mang sau khi sap xep: ");
    for (int i = 0; i < 10; i++){
        printf("%d ", arr[i]);
    }
    return 0;
}

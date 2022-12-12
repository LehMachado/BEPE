#include <stdio.h>

int main(){
    int soma[20];
    int x = 2;
    int y = 0;

    for(int i = 0; i < 20; i++){
        soma[i] = x + y;
        x++;
        y++; 
        printf("%d\n", soma[i]); 
    }

}

#include <stdio.h>

int funcao(int x[], int y, FILE *fp){
        //bitmask pos = numa_get_membind();
        fprintf(fp, "%d acessa", x[y]);
        return x[y];
    }
int main(){
    FILE *fp;
    fp = fopen("p_mem.txt", "w");

    int soma[20];
    int x = 2;
    int y = 0;

    for(int i = 0; i < 20; i++){

        soma[i] = x + y;
        x++;
        y++; 
        printf("%d\n", funcao(soma,i, fp)); 
    }

}
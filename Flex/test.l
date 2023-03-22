
/*** Definition Section has one variable
which can be accessed inside yylex() 
and main() [a-zA-Z]*("_"|"")[a-zA-Z]+
***/
%{
#include <math.h>
#include <stdio.h>
#include <string.h>
int chaves = 0; 
int main_o = 0;
int main_c = 0;
int de     = 0; 
int pv     = 0;
char vari[31];
char type[20];
%}

DIGIT    [0-9]

VAR     [a-zA-Z]*("_"|"")[a-zA-Z]+
ESC     vari

/*** Rule Section has three rules, first rule 
matches with capital letters, second rule
matches with any character except newline and 
third rule does not take input after the enter***/
%%
("int "|"double"|"float"|"char"|"void") {de = 1; printf("%s", yytext);}

";" {de = 0; pv = 1; printf("%s", yytext);}
"{" {pv = 1; printf("%s", yytext); }

{VAR}"[" {if(de == 0 && pv == 0) { 
    yytext[strlen(yytext)-1] = '\0';     
    if(strcmp(yytext, vari) == 0){  
        printf("funcao(numa_node_of_cpu(sched_getcpu()), %s,", yytext); 
        chaves ++;
        } 
    else {printf("%s[", yytext);}}
    else {printf("%s", yytext);}
    }

[a-zA-Z]*[0-9]*"]" {if(chaves != 0)     
        {yytext[strlen(yytext)-1] = '\0'; 
        printf("%s)", yytext); chaves --;}
    else if(chaves != 0) printf(")"); 
    else printf("%s", yytext);}

/*Before the main of the code, the functions needed to run the parsing are written*/

"int main" {
    main_o = 1;
    main_c= 1;
    printf("int tab[TAB_LENGTH];\n"); 
    printf("int pos = 0;\n"); 
    printf("FILE *fp;\n"); 
    printf("char filename[8] = %cout%c; \n", 34, 34);
    printf("int tab_caller[TAB_LENGTH];\n");
    printf("\n void ini() {for(int i = 0; i < TAB_LENGTH; i++) tab[i] = -1; \n}\n");
    printf("void save(){\n");
    printf("        fp = fopen(filename, %cw%c);\n\n", 34, 34);
    printf("        for(int i = 0; i < TAB_LENGTH; i = i + 2){\n");
    printf("            if(tab[i] == -1) break;\n");
    printf("            fprintf(fp,%c%cd %cd %cd %cn%c, tab[i],tab_caller[i], tab[i+1]);\n",34,37,37,37, 92, 34);
    printf("            tab[i] = -1;\n");
    printf("            tab[i+1] = -1;\n"); printf("        }\n");
    printf("        fclose(fp);\n"); printf("}\n\n");
    printf("void find_memory_node_for_addr(void* ptr) {\n");
    printf("    int numa_node = 0;\n");
    printf("    if(get_mempolicy(&numa_node, NULL, 0, ptr, MPOL_F_NODE | MPOL_F_ADDR) < 0)\n");
    printf("        printf(%cWARNING: get_mempolicy failed    %c);\n", 34, 34);
    printf("    tab[pos+1] = numa_node;\n}\n\n");
    printf("%s funcao(%s caller,%s x[], int y){\n",type, type, type); 
    printf("   tab[pos] = y;\n");
    printf("   tab_caller[pos] = caller;\n");
    printf("   find_memory_node_for_addr(x+y);\n");
    printf("   pos+=2;\n");
    printf("   if(pos == TAB_LENGTH){\n");
    printf("        save();\n");
    printf("        pos = 0;\n");
    printf("   }\n\n");
    printf("   return x[y];\n"); printf("}\n\n");   
    printf("%s", yytext);
    }


"){"        {printf("%s", yytext); if(main_o == 1){
            printf("    ini();\n");
            main_o = 0;} pv = 1;}
"return 0"  {if(main_c == 1){
            printf("save();\n");}
            printf("%s", yytext);}

.           {if(strcmp(yytext," ") != 0) pv = 0; printf("%s", yytext);}
\n          printf("\n");

%%
  
/*** Code Section prints the number of
capital letter present in the given input***/
int yywrap(){}
int main(){

//"+"|"-"|"*"|"/" {if(chaves == 1) {printf(",%s,", yytext);} else printf("%s", yytext);}
// Explanation:
// yywrap() - wraps the above rule section
/* yyin - takes the file pointer 
          which contains the input*/
/* yylex() - this is the main flex function
          which runs the Rule Section*/
// yytext is the text in the buffer
    
    /*Collects the data that needs to be analyzed, "type", "vector" and "file*/
    FILE *fp;
    char filename[50];
    char varname[31];
    printf("//Insert the type, variable name and file name \n");
    scanf("%s %s %s", type, varname, filename);
    fp = fopen(filename,"r");
    yyin = fp;
    
    /*initializes the libraries needed to run parsing */
    printf("#include <numa.h>\n");
    printf("#include <numaif.h>\n");
    printf("#include <string.h>\n");
    printf("#define TAB_LENGTH 10000\n");
    strcpy(vari, varname);
  
    yylex();

return 0;
}

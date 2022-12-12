
/*** Definition Section has one variable
which can be accessed inside yylex() 
and main() ***/
%{
#include <math.h>
#include <stdio.h>
#include <string.h>
int chaves = 0; 
int main_c = 0;
int de     = 0; 
%}

DIGIT    [0-9]

VAR     [a-zA-Z] 

/*** Rule Section has three rules, first rule 
matches with capital letters, second rule
matches with any character except newline and 
third rule does not take input after the enter***/
%%
("int "|"double"|"float"|"char"|"void") {de = 1; printf("%s", yytext);}

";" {de = 0; printf("%s", yytext);}

[a-zA-Z]*("_"|"")[a-zA-Z]+"[" {if(de == 0) {if(strlen(yytext)-1 <= 31) {yytext[strlen(yytext)-1] = '\0'; printf("funcao(%s,", yytext); chaves ++;}}
else printf("%s", yytext);}

[a-zA-Z]*[0-9]*"]" {if(chaves != 0) {yytext[strlen(yytext)-1] = '\0'; printf("%s, fp)", yytext); chaves --;}else if(chaves != 0) printf(")"); 
else printf("%s", yytext);}


"int main" {printf("int funcao(int x[], int y, FILE *fp){\n"); printf("        bitmask pos = numa_get_membind();\n"); printf("        fprintf(fp, %c%cd acessa%c, x[y], pos);\n",34,37,34);
printf("        return x[y];\n"); printf("    }\n"); printf("%s", yytext); main_c = 1;}
"{" {printf("%s\n", yytext); if(main_c == 1) {printf("    FILE *fp;\n"); printf("    fp = fopen(%cp_mem.txt%c, %cw%c);\n",34,34,34,34); main_c = 0;}}

.       printf("%s", yytext);
\n      printf("\n");

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
    
    // Uncomment the lines below 
    // to take input from file
    FILE *fp;
    char filename[50];
    char varname[31];
    scanf("%s %s",varname, filename);
    fp = fopen(filename,"r");
    yyin = fp;
     printf("#include <numa.h>\n");

  
yylex();
  
return 0;
}
%{
#include <stdio.h>
int yyerror(const char *s);
extern FILE *yyin;
int yylex();

int posX=0;
int posY=0;
char* couleur="noir";
char** lvar;

%}

%union {
        int num;
	char *variable;
}

%token fin plus moins fois diviser finProgramme baisserCrayon leverCrayon
%token bleu rouge noir colSymb virgule chevronOuvrant chevronFermant assigne parOuvrant parFermant ligne carree
%token<num> nombreD
%token<variable> var

%start S

%type<num> DESSIN NOMBRE CALCUL DESSINER COULEUR BOUCLE DEPLACERCRAYON DESSING X OPERATION
%type<num> DESSINERLIGNE DESSINERCARREE LIGNE CARREE
%type<variable> VARIABLE
%type<variable> DECLARERVALEUR

%%

S : DESSIN {printf("fin programme\n");return 0;}

DESSIN : DESSING DESSIN {}
| fin {}
;

DESSING :
DEBUTDESSIN DESSINER leverCrayon fin {printf("dessin fini ");}
| BOUCLE fin {printf("boucle fini\n");}
| DECLARERVALEUR fin {printf("declarer valeur %s\n",$1);}
| COULEUR fin {printf("changer couleur\n");}

DESSINERLIGNE :  LIGNE parOuvrant NOMBRE virgule NOMBRE parFermant parOuvrant NOMBRE virgule NOMBRE parFermant {
	printf("trait de %d,%d a %d,%d en %s\n",$3,$5,$8,$10,couleur);
}
;

LIGNE : ligne {printf("ligne\n");}

DESSINERCARREE : CARREE parOuvrant NOMBRE virgule NOMBRE parFermant parOuvrant NOMBRE virgule NOMBRE parFermant {
	printf("trait de %d,%d a %d,%d en %s\n",$3,$5,$8,$5,couleur);
	printf("trait de %d,%d a %d,%d en %s\n",$8,$5,$8,$10,couleur);
	printf("trait de %d,%d a %d,%d en %s\n",$8,$10,$3,$10,couleur);
	printf("trait de %d,%d a %d,%d en %s\n",$3,$10,$3,$5,couleur);
}

CARREE : carree{
	printf("carree\n");
}

DEPLACERCRAYON : parOuvrant NOMBRE virgule NOMBRE parFermant {
	printf("trait de %d,%d a %d,%d en %s\n",posX,posY,$2,$4,couleur);
	posX=$2;
	posY=$4;
}

DECLARERVALEUR : VARIABLE assigne NOMBRE {

	printf("variable declare est : %s\n",$1);$$=$1;
}
;

VARIABLE : var {char* v =$1;$$=v;printf("variable est %s\n",$1);}

BOUCLE : chevronOuvrant NOMBRE virgule NOMBRE virgule NOMBRE chevronFermant DESSIN chevronOuvrant chevronFermant {
printf("boucle");
}
;

DEBUTDESSIN : baisserCrayon NOMBRE virgule NOMBRE {
	posX=$2;posY=$4;
	printf("Dessin commence a : %d , %d\n",$2,$4);
}
;

DESSINER : DESSINERG DESSINER {}
| fin {};

DESSINERG :COULEUR fin
| DEPLACERCRAYON fin {printf("deplacer crayon\n");}
| DECLARERVALEUR fin {printf("declarer valeur\n");}
| DESSINERLIGNE fin {printf("ligne dessiner\n");}
| DESSINERCARREE fin {printf("carree dessiner\n");}
| fin {}
;

COULEUR : colSymb COL colSymb { printf("couleur\n"); }

COL : bleu {printf("bleu\n");couleur="bleu";}
| rouge {printf("rouge\n");couleur="rouge";}
| noir {printf("noir\n");couleur="noir";}
;

OPERATION : parOuvrant CALCUL parFermant {$$=$2;}

CALCUL : NOMBRE plus NOMBRE { printf("%d + %d\n",$1,$3);$$=$1+$3;}
| NOMBRE moins NOMBRE { printf("%d - %d\n",$1,$3);$$=$1-$3;}
| NOMBRE fois NOMBRE { printf("%d * %d\n",$1,$3);$$=$1*$3;}
| NOMBRE diviser NOMBRE { printf("%d / %d\n",$1,$3);$$=$1/$3;}
;

NOMBRE: X {$$=$1;}
| var {}
| OPERATION {$$=$1;}
;

X :
nombreD {$$=$1;}
;

%%

int main(int argc, char *argv[])
{
	printf("Application dessin \n");
	yyin=fopen(argv[1],"r+");
	if(yyin==NULL)
	{
		printf("\n Error ! \n");
		return 1;
	}
	else 
	{
		yyparse();
		return 0;
	}
}

int yyerror(s)
const char *s;
{
	fprintf(stderr, "%s\n",s);
	return(2);
}

int yywrap()
{
	return(1);
}

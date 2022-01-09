%{
#include <stdio.h>
#include "y.tab.h"
%}

%%
"carree"	return(carree);
"ligne"	return(ligne);
"("	return(parOuvrant);
")"	return(parFermant);
"<-"	return(assigne);
"<"	return(chevronOuvrant);
">"	return(chevronFermant);
","	return(virgule);
":"	return(colSymb);
"!"	return(finProgramme);
";"	return(fin);
"{"	return(baisserCrayon);
"}"	return(leverCrayon);
"+"	return(plus);
"-"	return(moins);
"*"	return(fois);
"/"	return(diviser);
BLEU	return(bleu);
ROUGE	return(rouge);
NOIR	return(noir);
[0-9]*	{ yylval.num = (float)atof(strdup(yytext));return(nombreD);};
[A-Za-z][A-Za-z0-9]*	{yylval.variable =strdup(yytext);return(var);};
. {return 1;}

%%

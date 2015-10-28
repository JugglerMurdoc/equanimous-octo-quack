%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "y.tab.h"
%}

%%

[a-zA-Z]		{
				yylval.valeur=yytext[0]; return IDEN;
			}//La valeur de l'identifiant est son index ASCII

[0-9]+			{
				yylval.valeur=atoi(yytext); return ENTIER;
			}
			

[{},:=	]			{

				return yytext[0];
			}

[\n]			{
				return yytext[0];
			}
			
.			{
				printf("Char inconnu %s\n", yytext);
			}

%%

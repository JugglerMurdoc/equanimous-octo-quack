%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "y.tab.h"
%}
OP_1 COMP|comp
OP_2 DIFF|diff|UNION|union|INTER|inter

%%
{OP_1}	 		{	return OP1;
			}
			
{OP_2}			{
				switch(yytext[0]){
					case 'd' : 
					case 'D' : yylval.valeur=1;
						   break;
					
					case 'i' : 
					case 'I' : yylval.valeur=2;
						   break;
						   
					case 'u' : 
					case 'U' : yylval.valeur=3;
						   break;
				}
				printf("OP2 : code %d\n",yylval.valeur);
				return OP2;
			}

[a-zA-Z]		{
				yylval.valeur=yytext[0]; return IDEN;
			}//La valeur de l'identifiant est son index ASCII

[0-9]+			{
				yylval.valeur=atoi(yytext);
				return ENTIER;
			}
			

[{},:=]			{

				return yytext[0];
			}

[\t ]+			{	}

[\n]			{
				return yytext[0];
			}
			
.			{
				printf("Char inconnu %s\n", yytext);
			}

%%

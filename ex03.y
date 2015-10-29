%{
	#include <stdio.h>
	#include <stdio.h>
	void yyerror(char*);  
   
struct liste {
	char id;
	unsigned long int value;
	int is_assigned;
};   
typedef struct liste LISTE;

LISTE hash_table[52];

//HEADERS
unsigned long int get_list(char hash_char);
unsigned long int add_element(unsigned long int element, unsigned int target);
char insert_list(char hash_char, unsigned long int list);
void print_list(unsigned long int list);
void print_hash_table();
int hash (char caracter);

%}

%union{
  int valeur;
  char addr_list;
}

%union{
  unsigned long int ptr_liste;
}


%token <valeur> ENTIER
%token <addr_list> IDEN
%type  <ptr_liste> liste
%type  <ptr_liste> instruction
%type  <ptr_liste> operande 
%type  <ptr_liste> expression 
%type  <ptr_liste> ensemble 
%type  <ptr_liste> liste_elements 
%right  ','

%%

liste : instruction '\n' {
	YYACCEPT;};

instruction :
   IDEN ':''=' expression 
   	{
   	 $$=insert_list($1,$4);
   	 }
 | IDEN 
 	{	int list_index = hash($1);
 		 if(hash_table[list_index].is_assigned == 1){
 		 	unsigned long int list = hash_table[list_index].value;
 		 	print_list(list);
 		 }
 		 else{
 		 	printf("Variable not assigned.\n");
 		 }
 	  $$=$1;
 	 };
   
expression :   
	operande
	{$$=$1;};

operande :  
 IDEN {$$=get_list($1);}
| ensemble
	{$$=$1;};		

ensemble :  
  '{' '}' 
  	{$$=0;}
| '{' liste_elements '}'
	{$$=$2;};

liste_elements :   
  ENTIER
 	{$$=(unsigned long int)$1;}
 | ENTIER ',' liste_elements
 	{$$=add_element($1,$3);};


%%

unsigned long set_nth_bit(unsigned long target, int index, int value){
	unsigned long result = 0;
	if(value == 0){
		unsigned long mask = 0 << index;
		result = target & mask;
	}else{
		unsigned long mask = 1 << index;
		result = target | mask;
	}
	
	return result;
}

int get_nth_bit(unsigned long target, int index){
	unsigned long mask =  1 << (index);
	unsigned long masked_n = target & mask;
	int thebit = masked_n >> index;
	return thebit;	
}

void print_list(unsigned long int list){
	unsigned long int mask = 1;
	int i;
	printf("[");
	for (i = 0; i < 32; i ++){
		if(get_nth_bit(list,i) == 1){
			printf(" %d;",i+1);
		}
		mask *= 2;
	}
	printf("]\n");
}

unsigned long int add_element(unsigned long int element, unsigned int target){
	int result = set_nth_bit(target,element-1,1);
	return result;
}

int hash (char caracter){
	int result = 0;
	if((caracter - 'a') < 0){
		result = 26 + (caracter- 'A');
	}
	else{
		result = caracter - 'a'; 
	}
	
	if(result < 0 || result > 51){
		printf("Invalid caracter : %c\n", caracter);
		return -1;	
		}
	
	return result;
}

unsigned long int get_list(char hash_char){
	int index = hash(hash_char);
	return hash_table[index].value;

}

void init_hash_table(){
	int i;
	for(i = 0; i < 26; i++){
		hash_table[i].id = (char) 'a'+i;
		hash_table[i].value = 0;
		hash_table[i].is_assigned = 0;
	}
	
	for(i = 26; i < 52; i++){
		hash_table[i].id = (char)'A'+i - 26;
		hash_table[i].value = 0;
		hash_table[i].is_assigned = 0;
	}
}

char insert_list(char hash_char, unsigned long int list){
	int index = hash(hash_char);
	hash_table[index].id=hash_char;
	hash_table[index].value = list;
	hash_table[index].is_assigned = 1;
	return hash_char;
}

void print_hash_table(){
	int i;
	printf("============================\n");
	printf("Index |Content             |\n");
	printf("============================\n");
	for(i = 0; i < 52; i++){
	printf("%c    |",hash_table[i].id);
	if(hash_table[i].is_assigned > 0){
	print_list(hash_table[i].value);}
	else{
	printf("Not assigned.\n");
	}
	}
}

int main(){
init_hash_table();
printf("Entrez une chaine\n");
 while(1==1){
 yyparse();
}
 return 0; 
}

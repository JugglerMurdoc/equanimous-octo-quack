%{
	#include <stdio.h>
	#include <stdio.h>
	void yyerror(char*);  
   
struct node
{
        int num;
        struct node *next;
};
typedef struct node NODE;


struct liste {
	char id;
	NODE* elements;	
};   
typedef struct liste LISTE;

LISTE hash_table[52];

//HEADERS
NODE* get_list(char hash_char);
char insert_list(char hash_char, NODE* list);
void print_list(NODE* list);
NODE* add_head(int head, NODE* content);
NODE* empty_list();
NODE* new_list(int content);
void print_hash_table();

%}

%union{
  int valeur;
  char addr_list;
}

%union{
  struct NODE* ptr_liste;
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

liste : instruction '\n' {YYACCEPT;};

instruction :
   IDEN ':''=' expression 
   	{
   	 $$=insert_list($1,$4);
   	 }
 | IDEN 
 	{NODE* list = get_list($1);
 		 if(list != NULL){
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
  	{$$=empty_list();}
| '{' liste_elements '}'
	{$$=$2;};

liste_elements :   
  ENTIER
 	{$$=new_list($1);}
 | ENTIER ',' liste_elements
 	{$$=add_head($1,$3);};


%%

NODE* empty_list(){
	NODE* new_list = malloc(sizeof(NODE));
	new_list->num = -1;
	return new_list;
}

NODE* new_list(int content){	
	NODE* new_list = empty_list();
	if(empty_list != NULL){
	new_list->num = content;
	new_list->next = NULL;
	return new_list;}
	else {
		perror("Error in new_list : got empty pointer\n");
		return NULL;
	}
}

NODE* add_head(int head, NODE* content){
	NODE * h = new_list(head);
	h->next = content;
	return h;
}

void print_list(NODE* list){
	NODE* tmp = list;
	printf("[");
	while(tmp != NULL){
		if((tmp->num >=0) && (tmp-> num < 32)){
		printf(" %d;", tmp->num);
		}
		tmp = tmp -> next;
	}
	printf("]\n");
}

void free_list(NODE* list){
	if(list->next != NULL){
		free_list(list->next);
	}
	free(list);
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

NODE* get_list(char hash_char){
	int index = hash(hash_char);
	return hash_table[index].elements;

}

void init_hash_table(){
	int i;
	for(i = 0; i < 26; i++){
		hash_table[i].id = (char) 'a'+i;
		hash_table[i].elements = NULL;
	}
	
	for(i = 26; i < 52; i++){
		hash_table[i].id = (char)'A'+i - 26;
		hash_table[i].elements = NULL;
	}
}

char insert_list(char hash_char, NODE* list){
	int index = hash(hash_char);
	hash_table[index].id=hash_char;
	hash_table[index].elements = list;
	return hash_char;
}

void print_hash_table(){
	int i;
	printf("============================\n");
	printf("Index |Content             |\n");
	printf("============================\n");
	for(i = 0; i < 52; i++){
	printf("%c    |",hash_table[i].id);
	print_list(hash_table[i].elements);
	}
}

void clean_hash_table(){
 int i;
 for(i = 0; i < 52; i++){
 	if(hash_table[i].elements != NULL){
 	free_list(hash_table[i].elements);
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

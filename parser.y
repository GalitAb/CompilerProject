%{
  #include <stdio.h>
  #include <string.h>
  #include <stdlib.h>
  #include "lex.yy.c"

typedef struct Node
{
    char* tok;
    struct Node *left, *right, *middle1, *middle2;
}Node;

    int counter=0;
    extern int yylex();
    extern char* yytext;
    extern int yylineno;
    extern int yyerror(const char *msg); 
  	void printTree(Node *root,int row);
	Node* mkNode(char* tok, Node* left, Node* right, Node* middle1, Node* middle2);
  	char *catTokens(char* t1,char *t2);
  	char *catNodes(Node *n1,Node *n2);   
%}

%union{
    char *string;
    struct Node* Node;
}


%token <string> BOOL INT INTP REAL REALP CHAR CHARP STRING VAL PROC FUNC RET
%token <string> NONE IF ELSE FOR WHILE
%token <string> AND DIVISION_OP ASSIGN EQUAL BIGGER_THAN BIGGER_OR_EQUAL
%token <string>	SMALLER_THAN SMALLER_OR_EQUAL MINUS LOGICAL_NOT NOT_EQUAL
%token <string>	OR PIPE PLUS MUL ADDRESS_OF POINTER_SIGN
%token <string>	L_BRACKET R_BRACKET L_SQR R_SQR L_BLOCK R_BLOCK COMMA COLON SEMICOLON COMMENT
%token <string>	UNDERSCORE STR_LEN MAIN ID TRUE FALSE
%token <string>	INTEGER REAL_NUM HEX CHAR_TOKEN STR VAR
%token <string>	QUOTE DOUBLE_QUOTES BEGIN_COMMENT END_COMMENT 

%left PLUS MINUS RET
%left MUL DIVISION_OP
%left EQUAL NOT_EQUAL SMALLER_THAN SMALLER_OR_EQUAL BIGGER_THAN BIGGER_OR_EQUAL OR AND 
%left SEMICOLON 
%right LOGICAL_NOT R_BLOCK 

%nonassoc ID 
%nonassoc L_BRACKET
%nonassoc IF
%nonassoc ELSE
  
  
%type <Node> s code_stmt func_body proc_body cond_body codes
%type <Node> exp statmnt code funct condition loop 
%type <Node> args var_decleration inits prom main  
%type <string> declare vars const type
%%
s: codes main{printf("\n"); printTree(mkNode("CODE",$1,$2,NULL,NULL),0);}; //TO DO : add 'main' after 'code'

codes: codes code {$$=mkNode(NULL,$1,$2,NULL,NULL);}| {$$=NULL;};	//new

code:FUNC ID L_BRACKET args R_BRACKET RET type func_body {$$=mkNode("FUNC",mkNode($2,NULL,NULL,NULL,NULL),$4,mkNode(catTokens("RET",$7),NULL,NULL,NULL,NULL),$8);}
      | PROC ID L_BRACKET args R_BRACKET proc_body {$$=mkNode("PROC",mkNode($2,NULL,NULL,NULL,NULL),$4,$6,NULL);}//delete 2 ruls
      ;

type: 	INT		{$$=$1;}
	| REAL 		{$$=$1;}
	| CHAR 		{$$=$1;}
	| STRING 	{$$=$1;}
	| BOOL 		{$$=$1;}
	| CHARP 	{$$=$1;}
	| REALP		{$$=$1;}
	| INTP 		{$$=$1;}
	;

main: PROC MAIN L_BRACKET R_BRACKET proc_body {$$=mkNode("PROC",$5, NULL, NULL, NULL);} | {$$=NULL;};
	;

proc_body: L_BLOCK code_stmt R_BLOCK {counter=0;$$=mkNode("BODY",$2,NULL,NULL,NULL);};

func_body: L_BLOCK code_stmt R_BLOCK {counter=0;$$=mkNode("BODY",$2,NULL,NULL,NULL);};//fix for

const:   declare{$$=$1;}
         |STRING {$$=$1;}  
         |INTEGER {$$=$1;}
         |HEX {$$=$1;}
         |REAL_NUM {$$=$1;}
         |CHAR_TOKEN {$$=$1;}
         |FALSE {$$=$1;}
         |TRUE {$$=$1;}
         |NONE {$$="null";}
        ;


loop:   WHILE L_BRACKET exp R_BRACKET cond_body {counter=0;$$=mkNode("WHILE",$3,$5,NULL,NULL);}
	| FOR L_BRACKET inits SEMICOLON exp SEMICOLON prom R_BRACKET cond_body {counter=0;$$=mkNode("FOR",$3,$7,mkNode("EXP", $5,NULL,NULL,NULL),$9);}
	;

    
condition: IF L_BRACKET exp R_BRACKET cond_body {counter=0;$$=mkNode("IF",$3,$5,NULL,NULL);}%prec IF
	 | IF L_BRACKET exp R_BRACKET cond_body ELSE cond_body {counter=0;$$=mkNode("IF-ELSE",$3,$5,$7,NULL);}
					 ;
		 
cond_body: L_BLOCK code_stmt R_BLOCK {$$=mkNode("BLOCK",$2,NULL,NULL,NULL);}
	 | statmnt {$$=$1;}
	 ;

code_stmt: code_stmt statmnt {$$=mkNode(NULL,$1,$2,NULL,NULL);}
	 |proc_body {Node*node=$1 ;node->tok="BLOCK"; $$=node;}
	 | {$$=NULL;}
	 ;

inits: inits COMMA ID ASSIGN exp {counter=0; Node*tmp=$1; tmp->tok=NULL; $$=mkNode("INITS",tmp,mkNode(catTokens("=",$3),$5,NULL,NULL,NULL),NULL,NULL);}
	| ID ASSIGN exp {counter=0;$$=mkNode("INITS",mkNode(catTokens("=",$1),$3,NULL,NULL,NULL),NULL,NULL,NULL);}
	;
			
	 
	 
statmnt: var_decleration SEMICOLON {$$=$1;}
	 | code	{$$=$1;}
	 | exp SEMICOLON {$$=$1;}
	 | condition {$$=$1;}
	 | loop {$$=$1;}
	 | RET exp SEMICOLON {$$=mkNode("RET",$2,NULL,NULL,NULL);}
	;
	

funct: 	 ID L_BRACKET vars R_BRACKET {$$=mkNode(catTokens($1,$3),NULL,NULL,NULL,NULL);}
         ;
	
var_decleration: declare ASSIGN exp {counter=0;$$=mkNode(catTokens("=",$1),$3,NULL,NULL,NULL);}
                 | VAR vars COLON type L_SQR INTEGER R_SQR {$$=mkNode("VARS",mkNode(catTokens($4,catTokens("[",catTokens($6,catTokens("]",$2)))),NULL,NULL,NULL,NULL),NULL,NULL,NULL);}
                 | VAR vars COLON type {$$=mkNode("VARS",mkNode(catTokens($4,$2),NULL,NULL,NULL,NULL),NULL,NULL,NULL);}
                 | POINTER_SIGN declare ASSIGN exp {counter=0;$$=mkNode(catTokens("=^",$2),$4,NULL,NULL,NULL);}
                    ;
					
vars: 	declare {$$=$1;}
	| vars COMMA declare {$$=catTokens($1,$3);}
	;
					
					
declare: ID {$$=$1;}
	| ID L_SQR exp R_SQR {counter=0;$$=catTokens($1,catTokens("[",catNodes($3,mkNode("]",NULL,NULL,NULL,NULL))));}
					;

args:   {$$=mkNode("ARGS NONE",NULL,NULL,NULL,NULL);}
	| vars COLON type {$$=mkNode("ARGS",mkNode(catTokens($3,$1), NULL,NULL, NULL, NULL),NULL,NULL,NULL);}
	| args SEMICOLON args {	Node* tmp=$3; tmp->tok=NULL; Node* tmp2=$1; tmp2->tok=NULL;  $$=mkNode("ARGS",tmp2,tmp, NULL, NULL); }
		;

prom: 	declare ASSIGN exp {counter=0;$$=mkNode("UPDATES",mkNode(catTokens("=",$1),$3,NULL,NULL,NULL),NULL,NULL,NULL);}
       | prom COMMA declare ASSIGN exp { Node*tmp=$1; tmp->tok=NULL; counter=0;$$=mkNode("UPDATES",tmp,mkNode(catTokens("=",$3),$5,NULL,NULL,NULL),NULL,NULL); }
	;

exp:const {counter++;$$=mkNode($1,NULL,NULL,NULL,NULL);}   
    	|PIPE ID PIPE {counter++;$$=mkNode(catTokens("|",catTokens($2,"|")),NULL,NULL,NULL,NULL);}
    	|ADDRESS_OF declare {counter++;$$=mkNode(catTokens("&",$2),NULL,NULL,NULL,NULL);}   
    	|funct {counter++;$$=$1;}
    	|L_BRACKET exp R_BRACKET {$$=$2;}
    	|PLUS exp {counter++;$$=mkNode($1,$2,NULL,NULL,NULL);}
	|MINUS exp {counter++;$$=mkNode($1,$2,NULL,NULL,NULL);}
	|LOGICAL_NOT exp {counter++;$$=mkNode($1,$2,NULL,NULL,NULL);}
    	|exp PLUS exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens("+",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens("+",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode("+",x,y,NULL,NULL);
	}
}
    	|exp MINUS exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens("-",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens("-",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode("-",x,y,NULL,NULL);
	}
}
    	|exp MUL exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens("*",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens("*",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode("*",x,y,NULL,NULL);
	}
}
    	|exp DIVISION_OP exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens("/",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens("/",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode("/",x,y,NULL,NULL);
	}
}
    	|exp AND exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens("&&",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens("&&",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode("&&",x,y,NULL,NULL);
	}
}
    	|exp OR exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens("||",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens("||",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode("||",x,y,NULL,NULL);
	}
}
    	|exp NOT_EQUAL exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens("!=",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens("!=",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode("!=",x,y,NULL,NULL);
	}
}
    	|exp EQUAL exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens("==",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens("==",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode("==",x,y,NULL,NULL);
	}
}
    	|exp BIGGER_OR_EQUAL exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens(">=",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens(">=",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode(">=",x,y,NULL,NULL);
	}
}
    	|exp SMALLER_OR_EQUAL exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens("<=",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens("<=",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode("<=",x,y,NULL,NULL);
	}
}
    	|exp SMALLER_THAN exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens("<",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens("<",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode("<",x,y,NULL,NULL);
	}
}


    	|exp BIGGER_THAN exp {
	if(counter<2){
		counter=0;
		$$=mkNode(catTokens(">",catNodes($1,$3)),NULL,NULL,NULL,NULL);
	} else {
		Node *x=$1,*y=$3;
		if(!x->left && !y->left)
			$$=mkNode(NULL,mkNode(catTokens(">",catNodes(x,y)),NULL,NULL,NULL,NULL),NULL,NULL,NULL);
		else
			$$=mkNode(">",x,y,NULL,NULL);
	}
}

    ;
%%
  

int yyerror(const char *message)
{
	int yydebug=1; 
	fflush(stdout);
	fprintf(stderr, "Error: %s, unexpected token: [%s] in line %d\n", message,yytext,yylineno);
	exit(1);
}

void printTree(Node *root,int row)
{
    if(root==NULL)
        return;

    char* tok = root->tok;
    int temp_row = row,flag=0;

    if(tok)
        printf("%*s",temp_row,"");

    if(tok&&!root->left&&!root->right&&!root->middle1&&!root->middle2)
    {
        flag=1;
        printf("(%s)\n",root->tok);
    }
    else if(tok)
        printf("(%s\n",root->tok);
    
    if(tok && root->left)
			temp_row+=3;
    printTree(root->left,temp_row);
  
    if(tok && root->right && !strcmp(tok,"PROC") && !strcmp(tok,"CODE"))
			temp_row+=3;
    printTree(root->right,temp_row);
  
    if(tok && root->middle1 && !strcmp(tok,"PROC") && !strcmp(tok,"CODE"))
			temp_row+=3;
    printTree(root->middle1,temp_row);

    if(tok && root->middle2 && !strcmp(tok,"PROC") && !strcmp(tok,"CODE"))
			temp_row+=3;
    printTree(root->middle2,temp_row);

    if(!flag && tok)
    {
        printf("%*s",row,"");
        printf(")\n");
    }
}

Node* mkNode(char* tok, Node* left,Node* right,Node* middle1,Node* middle2)
{
    Node *new_node = (Node*)malloc(sizeof(Node));
    if(tok){
        char *new_tok = (char*)malloc(sizeof(tok)+1);
        strcpy(new_tok,tok);
        new_node->tok = new_tok;
    }
    else{
        new_node->tok =NULL;
    }
    new_node->left = left;
    new_node->right= right;
    new_node->middle1  = middle1;
    new_node->middle2 = middle2;
    return new_node;
}


char *catTokens(char* t1,char *t2)
{
    char*new_str = (char*)malloc(sizeof(t1)+sizeof(t2)+sizeof(char)+1);
    strcpy(new_str,t1);
    strcat(new_str," ");
    strcat(new_str,t2);
    return new_str;
}

char *catNodes(Node *n1,Node *n2)
{
    if (n2->left)
        return catTokens(n1->tok,catTokens("\n",n2->tok));
    else
        return catTokens(n1->tok,n2->tok);

}

int wwyrap()
{
	return 1;
}
  
int main()
{
	yyparse();
	return 0;
}

%x C_COMMENT

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"
	extern int yyval, yylineno;
%}

%%
	/*Variable Types*/
"bool" 						{yylval.string = strdup(yytext);return BOOL;}
"int" 						{yylval.string = strdup(yytext);return INT;}
"int*" 						{yylval.string = strdup(yytext);return INTP;}
"real" 						{yylval.string = strdup(yytext);return REAL;}
"real*" 					{yylval.string = strdup(yytext);return REALP;}
"char" 						{yylval.string = strdup(yytext);return CHAR;}
"char*" 					{yylval.string = strdup(yytext);return CHARP;}
"string" 					{yylval.string = strdup(yytext);return STRING;}
"var" 						return VAR;
"proc" 						return PROC;
"func" 						return FUNC;
"return" 					return RET;

	/*Condition*/
"if" 						return IF;
"else" 						return ELSE;
"while" 					return WHILE;
"for" 						return FOR;
"null" 						return NONE;

	/*Operators*/
"&&" 						return AND;
"/" 						return DIVISION_OP;
"=" 						return ASSIGN;
"==" 						return EQUAL;
">" 						return BIGGER_THAN;
">=" 						return BIGGER_OR_EQUAL;
"<" 						return SMALLER_THAN;
"<=" 						return SMALLER_OR_EQUAL;
"-" 						return MINUS;
"!" 						return LOGICAL_NOT;
"!=" 						return NOT_EQUAL;

	/*Logical Operators*/
"||" 						return OR;
"|" 						return PIPE;
"+" 						return PLUS;
"*" 						return MUL;
"&" 						return ADDRESS_OF;
"^" 						return POINTER_SIGN;

	/*Expression signs*/
"(" 						return L_BRACKET;
")" 						return R_BRACKET;
"[" 						return L_SQR;
"]" 						return R_SQR;
"{" 						return L_BLOCK;
"}" 						return R_BLOCK;
"," 						return COMMA;
":" 						return COLON;
";" 						return SEMICOLON;

"_" 						return UNDERSCORE;
\|[a-zA-Z0-9]+\| 			return STR_LEN;
"Main" 					return MAIN;
"true" 						return TRUE;
"false" 					return FALSE;
	/*Variable name*/
[a-zA-Z]([a-zA-Z]|[0-9]|"_")* 			{yylval.string = strdup(yytext); return ID;}

	/*CONSTS*/
0|([-+]?[1-9][0-9]*([eE][+-][1-9][0-9]*)?) 	{yylval.string = strdup(yytext); return INTEGER;}
[-+]?[0-9]*\.[0-9]*([eE][+-][1-9][0-9]*)? 	{yylval.string = strdup(yytext); return REAL_NUM;}
[0][xX][A-F0-9]+ 				{yylval.string = strdup(yytext); return HEX;}
\'.\' 						{yylval.string = strdup(yytext); return CHAR_TOKEN;}
\"[^\"]*\" 					{yylval.string = strdup(yytext); return STR;}

"'" 						return QUOTE;
\" 						return DOUBLE_QUOTES;
[ \t\r\f]+ ;


"/%"            { BEGIN(C_COMMENT); }
<C_COMMENT>"%/" { BEGIN(INITIAL); }
<C_COMMENT>\n   yylineno++;
<C_COMMENT>.   ;

\n ++yylineno;
. return yytext[0];
%%

int yywrap(void) {	
	return 1;
}

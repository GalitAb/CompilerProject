%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include "y.tab.h"
	extern int yyval, yylineno;
%}

%%
	/*Variable Types*/
"bool" 						return BOOL;
"int" 						return INT;
"int*" 						return INTP;
"real" 						return REAL;
"real*" 					return REALP;
"char" 						return CHAR;
"char*" 					return CHARP;
"string" 					return STRING;
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
\/\%.*\%\/ 					{yylval.string = strdup(yytext); return  COMMENT;}

"_" 						return UNDERSCORE;
\|[a-zA-Z0-9]+\| 			return STR_LEN;
"Main()" 					return MAIN;

	/*Variable name*/
[a-zA-Z]([a-zA-Z]|[0-9]|"_")* 			{yylval.string = strdup(yytext); return ID;}

	/*CONSTS*/
"true" 						return TRUE;
"false" 					return FALSE;
0|([-+]?[1-9][0-9]*([eE][+-][1-9][0-9]*)?) 	{yylval.string = strdup(yytext); return INTEGER;}
[-+]?[0-9]*\.[0-9]*([eE][+-][1-9][0-9]*)? 	{yylval.string = strdup(yytext); return REAL_NUM;}
[0][xX][A-F0-9]+ 				{yylval.string = strdup(yytext); return HEX;}
\'.\' 						{yylval.string = strdup(yytext); return CHAR_TOKEN;}
\"[^\"]*\" 					{yylval.string = strdup(yytext); return STR;}

"'" 						return QUOTE;
\" 						return DOUBLE_QUOTES;
"/%" 						return BEGIN_COMMENT;
"%/" 						return END_COMMENT;
[ \t\r\f]+ ;
\n ++yylineno;
. yyerror("Error, unexpected character enter!");
%%

int yywrap(void) {	
	return 1;
}
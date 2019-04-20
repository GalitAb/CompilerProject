/* A Bison parser, made by GNU Bison 3.0.4.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    BOOL = 258,
    INT = 259,
    INTP = 260,
    REAL = 261,
    REALP = 262,
    CHAR = 263,
    CHARP = 264,
    STRING = 265,
    VAL = 266,
    PROC = 267,
    FUNC = 268,
    RET = 269,
    NONE = 270,
    IF = 271,
    ELSE = 272,
    FOR = 273,
    WHILE = 274,
    AND = 275,
    DIVISION_OP = 276,
    ASSIGN = 277,
    EQUAL = 278,
    BIGGER_THAN = 279,
    BIGGER_OR_EQUAL = 280,
    SMALLER_THAN = 281,
    SMALLER_OR_EQUAL = 282,
    MINUS = 283,
    LOGICAL_NOT = 284,
    NOT_EQUAL = 285,
    OR = 286,
    PIPE = 287,
    PLUS = 288,
    MUL = 289,
    ADDRESS_OF = 290,
    POINTER_SIGN = 291,
    L_BRACKET = 292,
    R_BRACKET = 293,
    L_SQR = 294,
    R_SQR = 295,
    L_BLOCK = 296,
    R_BLOCK = 297,
    COMMA = 298,
    COLON = 299,
    SEMICOLON = 300,
    COMMENT = 301,
    UNDERSCORE = 302,
    STR_LEN = 303,
    MAIN = 304,
    ID = 305,
    TRUE = 306,
    FALSE = 307,
    INTEGER = 308,
    REAL_NUM = 309,
    HEX = 310,
    CHAR_TOKEN = 311,
    STR = 312,
    VAR = 313,
    QUOTE = 314,
    DOUBLE_QUOTES = 315,
    BEGIN_COMMENT = 316,
    END_COMMENT = 317
  };
#endif
/* Tokens.  */
#define BOOL 258
#define INT 259
#define INTP 260
#define REAL 261
#define REALP 262
#define CHAR 263
#define CHARP 264
#define STRING 265
#define VAL 266
#define PROC 267
#define FUNC 268
#define RET 269
#define NONE 270
#define IF 271
#define ELSE 272
#define FOR 273
#define WHILE 274
#define AND 275
#define DIVISION_OP 276
#define ASSIGN 277
#define EQUAL 278
#define BIGGER_THAN 279
#define BIGGER_OR_EQUAL 280
#define SMALLER_THAN 281
#define SMALLER_OR_EQUAL 282
#define MINUS 283
#define LOGICAL_NOT 284
#define NOT_EQUAL 285
#define OR 286
#define PIPE 287
#define PLUS 288
#define MUL 289
#define ADDRESS_OF 290
#define POINTER_SIGN 291
#define L_BRACKET 292
#define R_BRACKET 293
#define L_SQR 294
#define R_SQR 295
#define L_BLOCK 296
#define R_BLOCK 297
#define COMMA 298
#define COLON 299
#define SEMICOLON 300
#define COMMENT 301
#define UNDERSCORE 302
#define STR_LEN 303
#define MAIN 304
#define ID 305
#define TRUE 306
#define FALSE 307
#define INTEGER 308
#define REAL_NUM 309
#define HEX 310
#define CHAR_TOKEN 311
#define STR 312
#define VAR 313
#define QUOTE 314
#define DOUBLE_QUOTES 315
#define BEGIN_COMMENT 316
#define END_COMMENT 317

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 24 "parser.y" /* yacc.c:1909  */

    char *string;
    struct Node* Node;

#line 183 "y.tab.h" /* yacc.c:1909  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */

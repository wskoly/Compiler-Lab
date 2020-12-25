%option noyywrap

%x COMMENT
%x SCOMMENT
%x MULTISTRING

%{

#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "1305115_table.h"
#include "y.tab.h"

using namespace std;


extern YYSTYPE yylval;
extern symbolTable* table;

void yyerror(const char *);

char c[1000000];
int start_l=0;
int line=1;
int error=0;
int i=0;
int j=0;
int check;

%}
whitespace[\t\v\f\r ]+
newline[\n]
digit[0-9]
digits{digit}+
letter[a-zA-Z]
letters{letter}+
alphanum({digit}|{letter})
%%
{newline} {//printf("newline is found\n"); 
//printf("new line is found\n");
line++;}

"println"	{return PRINTLN; //newly added
}

"if" {return IF;}

"else" {return ELSE;}

"for" {return FOR;}

"do" {return 	DO;}

"while" {return WHILE;}

"break" {return BREAK;}

"int" {return INT;}

"char" {return CHAR;}

"double" {return DOUBLE;}

"float" {return FLOAT;}

"void" {return VOID;}

"return" {return RETURN;}

"case" {return CASE;}

"switch" {return SWITCH;}

"default" {return DEFAULT;}

"continue" {return CONTINUE;}

"main" {return MAIN; //NEWLY ADDED
}

"!" {return NOT; //NEWLY ADDED
}

{digits} {//insertion
symbolInfo *s= new  symbolInfo(yytext, "CONST_INT",0);
s->val.i=atoi(yytext);
s->data=integer;
yylval = (YYSTYPE)s;
return CONST_INT;
}

{digits}(\.{digits})?(E[+-]?{digits})? {// .90875 is not taken as a float but 0.90875 is taken??
symbolInfo *s= new  symbolInfo(yytext, "CONST_FLOAT",0);
s->val.f=atof(yytext);
s->data=floating;
yylval = (YYSTYPE)s;
return CONST_FLOAT;
}

\'{alphanum}\' {
symbolInfo *s= new  symbolInfo(yytext, "CONST_CHAR",0);//problem as it is multi character for having quotation
yylval = (YYSTYPE)s;
s->data=character;
s->val.c=yytext[1];
printf("\nin l file %c %c\n",yytext[1],s->val.c);
return CONST_CHAR;
}

\'\\[n|t|0|r|f|b|v|a|r|\"|\\]\' {
symbolInfo *s= new  symbolInfo(yytext,"CONST_CHAR",0);
yylval = (YYSTYPE)s;
s->data=character;
return CONST_CHAR;
}

[+-] {
symbolInfo *s= new  symbolInfo(yytext, "ADDOP",0);
yylval = (YYSTYPE)s;
return ADDOP;
}

[*/%] {
symbolInfo *s= new  symbolInfo(yytext, "MULOP",0);
yylval = (YYSTYPE)s;
return MULOP;
}

"++" {//WHY NOT (++|--)
symbolInfo *s= new  symbolInfo(yytext, "INCOP",0);
yylval = (YYSTYPE)s;
return INCOP;
}

"--" {//WHY NOT (++|--) //NEWLY ADDED
symbolInfo *s= new  symbolInfo(yytext, "DECOP",0);
yylval = (YYSTYPE)s;
return DECOP;
}

(<|<=|>|>=|==|!=) {
symbolInfo *s= new  symbolInfo(yytext, "RELOP",0);
yylval = (YYSTYPE)s;
return RELOP;
}

"=" {return ASSIGNOP;}

"&&"|"||" { // CHANGED // PREVIOUS "&&"|"||"|"!" 
symbolInfo *s= new  symbolInfo(yytext, "LOGICOP",0);
yylval = (YYSTYPE)s;
return LOGICOP;
}

"(" {return LPAREN;}

")" {return RPAREN;}

"{" {return LCURL;}

"}" {return RCURL;}

"[" {return LTHIRD;}

"]" {return RTHIRD;}

"," {return COMMA;}

";" {return SEMICOLON;}

({letter}|_)({alphanum}|_)* {//whether _A_b_c is a variable or not
	symbolInfo *s;
	s= table->lookOut(yytext);
		if(s==Null)
			{				
			s= new symbolInfo(yytext, "ID",0);
			printf("%s\n",s->name.c_str());	
			}
		yylval = (YYSTYPE)s;


return ID;
}

{whitespace} {
//may be for whitespace is ignored 
//printf("white space is found\n");
}

{digits}(.{digits})?E[+-]?({digits}.{digits})  {//for 10.2E0.5675 but not 10.2 E .34567 // \.

error++;
}

{digits}.(E[+-]?{digits})  {//for 12.E // for\.

error++;
}
{digits}(.{digits})?E[+-]?(.{digit}*)  {//for 12E.12345 //problem for\.

error++;
}

{digits}({alphanum}|_)+ {//12abdc
printf("invalid prefix in id,%s\n",yytext);
error++;
}

\'{alphanum}{alphanum}+\' {//'abc'

error++;
}
\'{alphanum}*$ {

error++;
//line++;
}

(({alphanum}*\.{alphanum}*\.{alphanum}*)+)|({alphanum}*\.({alphanum}*\.{alphanum}*\.{alphanum}*)+) {//1.2.3 123.45.667 .... a.s.f.g

error++;
}

"/*" {	//for multiline comment state
	i=0;
	start_l=line;
	BEGIN COMMENT;
	printf("comment is started \n");
	//fprintf(logout,"Line no %d:Token <COMMENT> lexeme %s",line,yytext);
	while(yytext[j]!='\0'){
		c[i]=yytext[j];
	i++;j++;
	}
	j=0;
	//c[i]=yytext;
	//i++;
}
<COMMENT>. {//fprintf(logout,"%s",yytext);
	while(yytext[j]!='\0'){
		c[i]=yytext[j];
	i++;j++;
	}
	j=0;
}
<COMMENT>\n {line++;
}
<COMMENT>"*/" {
	printf("comment is ended \n");
	while(yytext[j]!='\0'){
		c[i]=yytext[j];
	i++;j++;
	}
	j=0;
	while(i!=0){
		c[i]=0;
	i--;
	}
	BEGIN INITIAL;
	i=0;
}
<COMMENT><<EOF>> {//for unfinished comment
	error++;
	printf("no end of comment %s\n",yytext);
	yyterminate();
	i=0;
	//for unfinished comment
}

"//" {//for singleline comment 
	BEGIN SCOMMENT;
	printf("single line comment is started\n");
	//fprintf(logout,"Line no %d:Token <COMMENT> lexeme %s",line,yytext);
	//i=0;
	while(yytext[j]!='\0'){
		c[i]=yytext[j];
	i++;j++;
	}
	j=0;
}
<SCOMMENT>. {//fprintf(logout,"%s",yytext);
	while(yytext[j]!='\0'){
		c[i]=yytext[j];
	i++;j++;
	}
	j=0;
}
<SCOMMENT>\n {
	j=0;
	line++; 
	
	while(i!=0){
		c[i]=0;
	i--;
	}
	BEGIN INITIAL;
	//end of single line comment
}



\".*\" {//single line string
	
	//s.insertItem(yytext,"STRING");
	//return STRING; //NEWLY ADDED
}

\" {	//both for multi line string
	start_l=line;
	BEGIN MULTISTRING;
	while(yytext[j]!='\0'){
		c[i]=yytext[j];
	i++;j++;
	}
	j=0;
	printf("start of a string %s\n",yytext);
}
<MULTISTRING>\\\n {
	printf("newline in string is found");
	while(yytext[j]!='\0'){
		c[i]=' ';
	i++;j++;
	}
	j=0;
	line++;
}
<MULTISTRING>\n {
	
	while(i!=0){
		c[i]=0;
	i--;
	}
	line++;
	error++;
	BEGIN INITIAL;
}

<MULTISTRING>\" {
	printf("\nstring is ended %s\n",yytext);
	while(yytext[j]!='\0'){
		c[i]=yytext[j];
	i++;j++;
	}
	j=0;
	
	//s.insertItem(c,"STRING");
	//return STRING; //NEWLY ADDED
	while(i!=0){
		c[i]=0;
	i--;
	}
	BEGIN INITIAL;
	//end of string	
}
<MULTISTRING>. {
	printf("%s",yytext);
	while(yytext[j]!='\0'){
		c[i]=yytext[j];
	i++;j++;
	}
	j=0;
}
. {

error++;
}






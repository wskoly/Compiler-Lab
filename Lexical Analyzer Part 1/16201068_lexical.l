%option noyywrap
%{
#include<stdio.h>
#include<stdlib.h>
#include "SymbolTable.h"

int lineCount = 0;
int line=1;
int error=0;
symbolTable s(31);
FILE *logout;
FILE *token;

%}

whitespace[\t\v\f\r]+
newline[\n]
digit[0-9]
digits{digit}+
letter[a-zA-Z]
letters{letter}+
alphanum({letter}|{digit})
id({letter}({digit}|{letter}|_)*)
exeptions(\\[nt\\\"afrbv0])

%%
{newline} {
	line++;
}

"if" {
printf("<IF>\n");
fprintf(token,"<IF>");
fprintf(logout,"Line no %d:Token <IF> lexeme %s is found\n",line,yytext);
}
"else" {
printf("<ELSE>\n");
fprintf(token,"<ELSE>");
fprintf(logout,"Line no %d:Token <ELSE> lexeme %s is found\n",line,yytext);
}
"for" {
printf("<FOR>\n");
fprintf(token,"<FOR>");
fprintf(logout,"Line no %d:Token <FOR> lexeme %s is found\n",line,yytext);
}
"while" {
printf("<WHILE>\n");
fprintf(token,"<WHILE>");
fprintf(logout,"Line no %d:Token <WHILE> lexeme %s is found\n",line,yytext);
}
"do" {
printf("<DO>\n");
fprintf(token,"<DO>");
fprintf(logout,"Line no %d:Token <DO> lexeme %s is found\n",line,yytext);
}
"break" {
printf("<BREAK>\n");
fprintf(token,"<BREAK>");
fprintf(logout,"Line no %d:Token <BREAK> lexeme %s is found\n",line,yytext);
}
"int" {
printf("<INT>\n");
fprintf(token,"<INT>");
fprintf(logout,"Line no %d:Token <INT> lexeme %s is found\n",line,yytext);
}
"char" {
printf("<CHAR>\n");
fprintf(token,"<CHAR>");
fprintf(logout,"Line no %d:Token <CHAR> lexeme %s is found\n",line,yytext);
}
"float" {
printf("<FLOAT>\n");
fprintf(token,"<FLOAT>");
fprintf(logout,"Line no %d:Token <FLOAT> lexeme %s is found\n",line,yytext);
}
"double" {
printf("<DOUBLE>\n");
fprintf(token,"<DOUBLE>");
fprintf(logout,"Line no %d:Token <DOUBLE> lexeme %s is found\n",line,yytext);
}
"void" {
printf("<VOID>\n");
fprintf(token,"<VOID>");
fprintf(logout,"Line no %d:Token <VOID> lexeme %s is found\n",line,yytext);
}
"return" {
printf("<RETURN>\n");
fprintf(token,"<RETURN>");
fprintf(logout,"Line no %d:Token <RETURN> lexeme %s is found\n",line,yytext);
}
"switch" {
printf("<SWITCH>\n");
fprintf(token,"<SWITCH>");
fprintf(logout,"Line no %d:Token <SWITCH> lexeme %s is found\n",line,yytext);
}
"case" {
printf("<CASE>\n");
fprintf(token,"<CASE>");
fprintf(logout,"Line no %d:Token <CASE> lexeme %s is found\n",line,yytext);
}
"default" {
printf("<DEFAULT>\n");
fprintf(token,"<DEFAULT>");
fprintf(logout,"Line no %d:Token <DEFAULT> lexeme %s is found\n",line,yytext);
}
"continue" {
printf("<CONTINUE>\n");
fprintf(token,"<CONTINUE>");
fprintf(logout,"Line no %d:Token <CONTINUE> lexeme %s is found\n",line,yytext);
}
[+-] {
printf("<ADDOP,%s>\n",yytext);
fprintf(token,"<ADDOP,%s>",yytext);
fprintf(logout,"Line no %d:Token <ADDOP> lexeme %s is found\n",line,yytext);
}
[*/%] {
printf("<MULOP,%s>\n",yytext);
fprintf(token,"<MULOP,%s>",yytext);
fprintf(logout,"Line no %d:Token <MULOP> lexeme %s is found\n",line,yytext);
}
"++"|"--" {
printf("<INCOP,%s>\n",yytext);
fprintf(token,"<INCOP,%s>",yytext);
fprintf(logout,"Line no %d:Token <INCOP> lexeme %s is found\n",line,yytext);
}
"<"|"<="|">"|">="|"=="|"!=" {
printf("<RELOP,%s>\n",yytext);
fprintf(token,"<RELOP,%s>",yytext);
fprintf(logout,"Line no %d:Token <RELOP> lexeme %s is found\n",line,yytext);
}
"=" {
printf("<ASSIGNOP,%s>\n",yytext);
fprintf(token,"<ASSIGNOP,%s>",yytext);
fprintf(logout,"Line no %d:Token <ASSIGNOP> lexeme %s is found\n",line,yytext);
}
"&&"|"||"|"!" {
printf("<LOGICOP,%s>\n",yytext);
fprintf(token,"<LOGICOP,%s>",yytext);
fprintf(logout,"Line no %d:Token <LOGICOP> lexeme %s is found\n",line,yytext);
}
[\(\)] {
printf("<PAREN,%s>\n",yytext);
fprintf(token,"<PAREN,%s>",yytext);
fprintf(logout,"Line no %d:Token <PAREN> lexeme %s is found\n",line,yytext);
}
[\{\}] {
printf("<CURL,%s>\n",yytext);
fprintf(token,"<CURL,%s>",yytext);
fprintf(logout,"Line no %d:Token <CURL> lexeme %s is found\n",line,yytext);
}
[\[\]] {
printf("<BRACKET,%s>\n",yytext);
fprintf(token,"<BRACKET,%s>",yytext);
fprintf(logout,"Line no %d:Token <BRACKET> lexeme %s is found\n",line,yytext);
}
"," {
printf("<COMMA>\n");
fprintf(token,"<COMMA>");
fprintf(logout,"Line no %d:Token <COMMA> lexeme %s is found\n",line,yytext);
}
";" {
printf("<SEMICOLON>\n");
fprintf(token,"SEMICOLON>");
fprintf(logout,"Line no %d:Token <SEMICOLON> lexeme %s is found\n",line,yytext);
}
{id} {
printf("<ID,%s>\n",yytext);
fprintf(token,"<ID,%s>",yytext);
fprintf(logout,"Line no %d:Token <ID> lexeme %s is found\n",line,yytext);
}
{digits} {
printf("<CONST_INT,%s>\n",yytext);
fprintf(token,"<CONST_INT,%s>",yytext);
fprintf(logout,"Line no %d:Token <CONST_INT> lexeme %s is found\n",line,yytext);
}
{digits}(\.|(E(\+|-)|E))({digits}|({digits}(E(\+|-)|E){digits})) {
printf("<CONST_FLOAT,%s>\n",yytext);
fprintf(token,"<CONST_FLOAT,%s>",yytext);
fprintf(logout,"Line no %d:Token <CONST_FLOAT> lexeme %s is found\n",line,yytext);
}
\'{alphanum}\' {
printf("<CONST_CHAR,%s>\n",yytext);
fprintf(token,"<CONST_CHAR,%s>",yytext);
fprintf(logout,"Line no %d:Token <CONST_CHAR> lexeme %s is found\n",line,yytext);
}
\'{exeptions}\' {
printf("<CONST_CHAR,%s>\n",yytext);
fprintf(token,"<CONST_CHAR,%s>",yytext);
fprintf(logout,"Line no %d:Token <CONST_CHAR> lexeme %s is found\n",line,yytext);
}
%%

int main(int argc,char *argv[])
{
	if(argc!=2)
		{
		printf("Please provide input file name and try again\n");
		return 0;
		}
	FILE *input=fopen(argv[1],"r");
	if(input==NULL){
		printf("cannot open the file\n");
		return 0;
		}

	logout= fopen("16201068_log.txt","w");
	token= fopen("16201068_token.txt","w");
	yyin= input;
	yylex();
	fprintf(logout,"\nline number is %d\n",line-1);
	fprintf(logout,"error number is %d\n",error);
	fclose(yyin);
	fclose(token);
	fclose(logout);
	return 0;

	
}

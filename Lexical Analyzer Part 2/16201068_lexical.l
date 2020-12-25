%option noyywrap
%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#include "SymbolTable.h"

int lineCount = 0;
int line=1;
int error=0;
int i=0;
symbolTable s(31);
FILE *logout;
FILE *token;
%}

whitespace[\t\v\f\r ]+
newline[\n]
digit[0-9]
digits{digit}+
letter[a-zA-Z]
letters{letter}+
alphanum({letter}|{digit})
exeptions(\\[nt\\\"afrbv0])
const_char({alphanum}|{exeptions})
id(({letter}|_)({digit}|{letter}|_)*)
string .*
invalid_float({digits}.{digits}(\.{digits})+)
ill_formed({digits}(\.{digits})?[Ee]{digits}?(\.{digits}))
invalid_suff({digits}({digit}|{letter}|_)+)
multi_char({alphanum}|{exeptions})+

%%
{newline} {
	line++;
}
\/\*({string}{newline})*{string}\*\/ {
for(i=0; i<strlen(yytext);i++) {
if(yytext[i]=='\n')
lineCount++;
}
printf("<MULTIPLE_LINE_COMMENT>\n");
fprintf(token,"<MULTIPLE_LINE_COMMENT>");
fprintf(logout,"Line no %d:Token <MULTIPLE_LINE_COMMENT> lexeme %s is found\n",line,yytext);
line+=lineCount;
}
\/\/{string} {
printf("<SINGLE_LINE_COMMENT>\n");
fprintf(token,"<SINGLE_LINE_COMMENT>\n");
fprintf(logout,"Line no %d:Token <SINGLE_LINE_COMMENT> lexeme %s is found\n",line,yytext);
}
"if" {
printf("<IF>\n");
fprintf(token,"<IF>\n");
fprintf(logout,"Line no %d:Token <IF> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"else" {
printf("<ELSE>\n");
fprintf(token,"<ELSE>\n");
fprintf(logout,"Line no %d:Token <ELSE> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"for" {
printf("<FOR>\n");
fprintf(token,"<FOR>\n");
fprintf(logout,"Line no %d:Token <FOR> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"while" {
printf("<WHILE>\n");
fprintf(token,"<WHILE>\n");
fprintf(logout,"Line no %d:Token <WHILE> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"do" {
printf("<DO>\n");
fprintf(token,"<DO>\n");
fprintf(logout,"Line no %d:Token <DO> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"break" {
printf("<BREAK>\n");
fprintf(token,"<BREAK>\n");
fprintf(logout,"Line no %d:Token <BREAK> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"int" {
printf("<INT>\n");
fprintf(token,"<INT>\n");
fprintf(logout,"Line no %d:Token <INT> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"char" {
printf("<CHAR>\n");
fprintf(token,"<CHAR>\n");
fprintf(logout,"Line no %d:Token <CHAR> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"float" {
printf("<FLOAT>\n");
fprintf(token,"<FLOAT>\n");
fprintf(logout,"Line no %d:Token <FLOAT> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"double" {
printf("<DOUBLE>\n");
fprintf(token,"<DOUBLE>\n");
fprintf(logout,"Line no %d:Token <DOUBLE> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"void" {
printf("<VOID>\n");
fprintf(token,"<VOID>\n");
fprintf(logout,"Line no %d:Token <VOID> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"return" {
printf("<RETURN>\n");
fprintf(token,"<RETURN>\n");
fprintf(logout,"Line no %d:Token <RETURN> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"switch" {
printf("<SWITCH>\n");
fprintf(token,"<SWITCH>\n");
fprintf(logout,"Line no %d:Token <SWITCH> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"case" {
printf("<CASE>\n");
fprintf(token,"<CASE>\n");
fprintf(logout,"Line no %d:Token <CASE> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"default" {
printf("<DEFAULT>\n");
fprintf(token,"<DEFAULT>\n");
fprintf(logout,"Line no %d:Token <DEFAULT> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
"continue" {
printf("<CONTINUE>\n");
fprintf(token,"<CONTINUE>\n");
fprintf(logout,"Line no %d:Token <CONTINUE> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"KEYWORD");
}
[+-] {
printf("<ADDOP,%s>\n",yytext);
fprintf(token,"<ADDOP,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <ADDOP> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"ADDOP");
}
[*/%] {
printf("<MULOP,%s>\n",yytext);
fprintf(token,"<MULOP,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <MULOP> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"MULOP");
}
"++"|"--" {
printf("<INCOP,%s>\n",yytext);
fprintf(token,"<INCOP,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <INCOP> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"INCOP");
}
"<"|"<="|">"|">="|"=="|"!=" {
printf("<RELOP,%s>\n",yytext);
fprintf(token,"<RELOP,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <RELOP> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"RELOP");
}
"=" {
printf("<ASSIGNOP,%s>\n",yytext);
fprintf(token,"<ASSIGNOP,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <ASSIGNOP> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"ASSIGNOP");
}
"&&"|"||"|"!" {
printf("<LOGICOP,%s>\n",yytext);
fprintf(token,"<LOGICOP,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <LOGICOP> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"LOGICOP");
}
[\(\)] {
printf("<PAREN,%s>\n",yytext);
fprintf(token,"<PAREN,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <PAREN> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"PAREN");
}
[\{\}] {
printf("<CURL,%s>\n",yytext);
fprintf(token,"<CURL,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <CURL> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"CURL");
}
[\[\]] {
printf("<BRACKET,%s>\n",yytext);
fprintf(token,"<BRACKET,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <BRACKET> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"BRACKET");
}
"," {
printf("<COMMA>\n");
fprintf(token,"<COMMA>\n");
fprintf(logout,"Line no %d:Token <COMMA> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"COMMA");
}
";" {
printf("<SEMICOLON>\n");
fprintf(token,"SEMICOLON>\n");
fprintf(logout,"Line no %d:Token <SEMICOLON> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"SEMICOLON");
}
\"{string}\" {
printf("<STRING,%s>\n",yytext);
fprintf(token,"<STRING,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <STRING> lexeme %s is found\n",line,yytext);
}
{id} {
printf("<ID,%s>\n",yytext);
fprintf(token,"<ID,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <ID> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"ID");
}
[+-]?{digits} {
printf("<CONST_INT,%s>\n",yytext);
fprintf(token,"<CONST_INT,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <CONST_INT> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"CONST_INT");
}
[+-]?{invalid_float} {
error++;
printf("<MUTIPLE_DECIMAL_ERROR,%s>\n",yytext);
fprintf(token,"<MUTIPLE_DECIMAL_ERROR,%s>\n",yytext);
fprintf(logout,"Line no %d:Error <MUTIPLE_DECIMAL_ERROR> lexeme %s is found\n",line,yytext);
}
[+-]?{ill_formed} {
error++;
printf("<ILL_FORMED_NUMBER,%s>\n",yytext);
fprintf(token,"<ILL_FORMED_NUMBER,%s>\n",yytext);
fprintf(logout,"Line no %d:Error <ILL_FORMED_NUMBER> lexeme %s is found\n",line,yytext);
}
[+-]?{digits}(\.|(E(\+|-)|E))({digits}|({digits}(E(\+|-)|E){digits})) {
printf("<CONST_FLOAT,%s>\n",yytext);
fprintf(token,"<CONST_FLOAT,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <CONST_FLOAT> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"CONST_FLOAT");
}
\'{const_char}\' {
printf("<CONST_CHAR,%s>\n",yytext);
fprintf(token,"<CONST_CHAR,%s>\n",yytext);
fprintf(logout,"Line no %d:Token <CONST_CHAR> lexeme %s is found\n",line,yytext);
s.insertItem(logout,yytext,"CONST_CHAR");
}
\'{multi_char}\' {
error++;
printf("<MULTIPLE_CHARACTER_ERROR,%s>\n",yytext);
fprintf(token,"<MULTIPLE_CHARACTER_ERROR,%s>\n",yytext);
fprintf(logout,"Line no %d:Error <MULTIPLE_CHARACTER_ERROR> lexeme %s is found\n",line,yytext);
}
{invalid_suff} {
error++;
printf("<INVALID_SUFFIX_or_PREFIX,%s>\n",yytext);
fprintf(token,"<INVALID_SUFFIX_or_PREFIX,%s>\n",yytext);
fprintf(logout,"Line no %d:Error <INVALID_SUFFIX_or_PREFIX> lexeme %s is found\n",line,yytext);
}
{whitespace} {
}
. {
error++;
printf("<UNRECOGNIZED_CHAR,%s>\n",yytext);
fprintf(token,"<UNRECOGNIZED_CHAR,%s>\n",yytext);
fprintf(logout,"Line no %d:Error <UNRECOGNIZED_CHAR> lexeme %s is found\n",line,yytext);
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

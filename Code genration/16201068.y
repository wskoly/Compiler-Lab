
%{
#include<iostream>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sstream>
#include<bits/stdc++.h>
#include "16201068_table.h"
#include "16201068_optimization.cpp"
#define YYSTYPE symbolInfo*
using namespace std;

FILE *output;
//FILE *out;
string cmp;

string n="";
symbolInfo* notget;
symbolInfo* idcheck;
symbolInfo* ix;
symbolInfo* idprint;
symbolTable* table=new symbolTable(31);

extern int line;
extern int error;
ofstream fout;
void yyerror(const char *s){
	printf("%s\n",s);
	fprintf(output,"Error at line %d : %s \n",line,s);
	error++;
}


int labelCount=0;
int tempCount=0;


char *newLabel()
{
	// add your code like newTemp
	char *l= new char[4];
	strcpy(l,"l");
	char b[3];
	sprintf(b,"%d", labelCount);
	labelCount++;
	strcat(l,b);
	return l;
}

char *newTemp()
{
	char *t= new char[4];
	strcpy(t,"t");
	char b[3];
	sprintf(b,"%d", tempCount);
	tempCount++;
	strcat(t,b);
	return t;
}

int yylex(void);

%}
%error-verbose
%token  INT MAIN LPAREN RPAREN LCURL RCURL SEMICOLON FLOAT CHAR COMMA ID LTHIRD RTHIRD CONST_INT CONST_FLOAT CONST_CHAR FOR IF WHILE PRINTLN RETURN LOGICOP RELOP ASSIGNOP ADDOP NOT MULOP INCOP DECOP STRING ELSE DO BREAK DOUBLE VOID CASE SWITCH CONTINUE DEFAULT
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE


%%

Program : INT MAIN LPAREN RPAREN compound_statement { fprintf(output,"program : INT MAIN LPAREN RPAREN compound_statement\n\n");
			fout.open("16201068_code.asm"); //Change as per your ID
			fout<<"TITLE: Code Generation\n";
			fout<<".MODEL SMALL\n";
			fout<<".STACK 100H\n";
			fout<<".DATA\n";
			for(int i=0;i<tempCount;i++)
			{
				//add codes here for generation
				fout<<"t"<<i<<" DW ?\n";
			}
			$$=$5;
			$$->code+="MAIN ENDP\n";
$$->code+="\n\nOUTDEC PROC\nPUSH AX\nPUSH BX\nPUSH CX\nPUSH DX\nOR AX,AX\nJGE @END_IF1\nPUSH AX\nMOV DL,'-'\nMOV AH,2\nINT 21H\nPOP AX\nNEG AX\n\n@END_IF1:\nXOR CX,CX\nMOV BX,10D\n\n@REPEAT1:\nXOR DX,DX\nDIV BX\nPUSH DX\nINC CX\nOR AX,AX\nJNE @REPEAT1\n\nMOV AH,2\n\n@PRINT_LOOP:\n\nPOP DX\nOR DL,30H\nINT 21H\nLOOP @PRINT_LOOP\n\nPOP DX\nPOP CX\nPOP BX\nPOP AX\nRET\nOUTDEC ENDP\n\n";
			$$->code+="END MAIN\n";
			fout<<$$->code;		
	};

compound_statement : LCURL var_declaration statements RCURL { fprintf(output,"compound_statement : LCURL var_declaration statements RCURL\n\n");
							//add your code generation
							$$=$3;
							$$->code = $2->code+".CODE\nMAIN PROC\nMOV AX, @DATA\nMOV DS, AX\n"+$3->code;
			}
		   | LCURL statements RCURL { fprintf(output,"compound_statement : LCURL statements RCURL\n\n");$$=$2;}
		   | LCURL RCURL { //$$->code=""; 
		   cout<<"c statement";
		   fprintf(output,"compound_statement : LCURL RCURL \n\n");}
		   ;			 
var_declaration	: type_specifier declaration_list SEMICOLON 
		{ fprintf(output,"var_declaration : type_specifier declaration_list SEMICOLON\n\n"); 
			$$=$2;
		}
		|  var_declaration type_specifier declaration_list SEMICOLON 
		{ fprintf(output,"var_declaration : var_declaration type_specifier declaration_list SEMICOLON  \n\n"); 
						$$=$1;
						$$->code+=$3->code;
		};

type_specifier	: INT { fprintf(output,"type_specifier  : INT \n\n"); {cmp="int";}}
		| FLOAT { fprintf(output,"type_specifier  : FLOAT\n\n");   {cmp="float";}}
		| CHAR { fprintf(output,"type_specifier : CHAR \n\n"); {cmp="char";}}
		| VOID { fprintf(output,"type_specifier : VOID \n\n"); }
		;
			
declaration_list : declaration_list COMMA ID { 
		fprintf(output,"declaration_list  : declaration_list COMMA ID\n%s\n\n",$3->name.c_str()); 
		
		idcheck=table->lookOut($3->name);
	if(idcheck==Null){
					$$=$1;
					
				
					if(strcmp(cmp.c_str(),"int")==0)
					{
					//add code for generation part
					$$->code+=($3->getName()+" DW ?\n");
					$3->data=integer;
					$3->val.i=-99999;
					$3->position=0;
					table->insertItem($3);
					}
					else if(strcmp(cmp.c_str(),"float")==0)
					{
					$$->code+=($3->getName()+" DW ?\n");
					$3->data=floating;
					$3->val.f=-99999.0;
					$3->position=0;
					table->insertItem($3);
					}
					else if(strcmp(cmp.c_str(),"char")==0)
					{
					$$->code+=($3->getName()+" DW ? $\n");
					$3->data=character;
					$3->val.c=-99999;
					$3->position=0;
					table->insertItem($3);
					}
					
			}
			else{
				char errorarr[30]="Multiple Declaration";
				strcat(errorarr,$3->name.c_str());							
				yyerror(errorarr);}
					
					}
		 | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD 
			{fprintf(output,"declaration_list  : declaration_list COMMA ID LTHIRD CONST_INT RTHIRD\n %s\n\n",
				$3->name.c_str());
				
		idcheck=table->lookOut($3->name);
		if(idcheck==Null){
				$$=$1;
				int length=$5->val.i;
				
				if(strcmp(cmp.c_str(),"int")==0)
				{
				//add code for generation part
				$$->code+=($3->getName()+" DW ");
				for(int i=0; i<length; i++)
				  {
				    $$->code+="? ";
				  }
				  $$->code+="\n";
				$3->data=integer; 
				$3->arraysz=$5->val.i;
				$3->val.arrayi=(int*)malloc(($3->arraysz)*sizeof(int));
				for(int k=0;k<$3->arraysz;k++){$3->val.arrayi[k]=-1;}
				}
				else if(strcmp(cmp.c_str(),"float")==0)
				{
				$$->code+=($3->getName()+" DW ");
				for(int i=0; i<length; i++)
				  {
				    $$->code+="? ";
				  }
				  $$->code+="\n";
				$3->data=floating; 
				$3->arraysz=$5->val.i;
				$3->val.arrayf=(float*)malloc(($3->arraysz)*sizeof(float));
				for(int k=0;k<$3->arraysz;k++){$3->val.arrayf[k]=-1.0;}
				}
				else if(strcmp(cmp.c_str(),"char")==0)
				{	
				$$->code+=($3->getName()+" DW ");
				for(int i=0; i<length; i++)
				  {
				    $$->code+="? ";
				  }
				  $$->code+=" $\n";
				$3->data=character; 
				$3->arraysz=$5->val.i;
				$3->val.arrayc=(char*)malloc(($3->arraysz)*sizeof(char));
				for(int k=0;k<$3->arraysz;k++){$3->val.arrayc[k]=-1;}
				}
				
				table->insertItem($3);	
			}
	else{
		char errorarr[30]="Multiple Declaration : ";
		strcat(errorarr,$3->name.c_str());							
		yyerror(errorarr);	
	}	
		}
		 | ID { 
			fprintf(output,"declaration_list  : ID \n%s\n\n",$1->name.c_str());
	
	idcheck=table->lookOut($1->name);
	if(idcheck==Null){ 
				$$=new symbolInfo();
				if(strcmp(cmp.c_str(),"int")==0)
				{
				// add codes for generation part
				$$->code+=($1->getName()+" DW ?\n");
				$1->data=integer; 
				$1->val.i=-99999;
				table->insertItem($1);
				}
				else if(strcmp(cmp.c_str(),"float")==0)
				{
				$$->code+=($1->getName()+" DW ?\n");
				$1->data=floating; 
				$1->val.f=-99999.000;
				table->insertItem($1);
				}
				else if(strcmp(cmp.c_str(),"char")==0)
				{
				$$->code+=($1->getName()+" DW ? $\n");
				$1->data=character; 
				$1->val.c=-999;
				table->insertItem($1);
				}
			}
		else{
			char errorarr[30]="Multiple Declaration : ";
			strcat(errorarr,$1->name.c_str());							
			yyerror(errorarr);			
			}
		      }
		 | ID LTHIRD CONST_INT RTHIRD { 
			fprintf(output,"declaration_list  : ID LTHIRD CONST_INT RTHIRD \n%s\n\n",$1->name.c_str()); 
			printf("%s\n",$1->name.c_str());
	
	idcheck=table->lookOut($1->name);
	if(idcheck==Null){
			$$=new symbolInfo();
			int length=$3->val.i;
			if(strcmp(cmp.c_str(),"int")==0)
				{	
				//add codes for generation part
				$$->code+=($3->getName()+" DW ");
				for(int i=0; i<length; i++)
				  {
				    $$->code+="? ";
				  }
				  $$->code+="\n";
				$1->data=integer; 
				$1->arraysz=$3->val.i;
				$1->val.arrayi=(int*)malloc(($1->arraysz)*sizeof(int));
				for(int k=0;k<$1->arraysz;k++){$1->val.arrayi[k]=-1;}
				}
				else if(strcmp(cmp.c_str(),"float")==0)
				{
				//add codes
				$$->code+=($1->getName()+" DW ");
				for(int i=0; i<length; i++)
				  {
				    $$->code+="? ";
				  }
				  $$->code+="\n";
				$1->data=floating; 
				$1->arraysz=$3->val.i;
				$1->val.arrayf=(float*)malloc(($1->arraysz)*sizeof(float));
				for(int k=0;k<$1->arraysz;k++){$1->val.arrayf[k]=-1.0;}
				}
				else if(strcmp(cmp.c_str(),"char")==0)
				{	
				//add codes
				$$->code+=($1->getName()+" DW ");
				for(int i=0; i<length; i++)
				  {
				    $$->code+="? ";
				  }
				  $$->code+=" $\n";
				$1->data=character; 
				$1->arraysz=$3->val.i;
				$1->val.arrayc=(char*)malloc(($1->arraysz)*sizeof(char));
				for(int k=0;k<$1->arraysz;k++){$1->val.arrayc[k]=-1;}
				}
			
			
		table->insertItem($1);
		}
else{

	char errorarr[30]="Multiple Declaration : ";
	strcat(errorarr,$1->name.c_str());							
	yyerror(errorarr);
	}
};

statements : statement { fprintf(output,"statements  : statement\n\n");$$=$1; }
	   | statements statement { fprintf(output,"statements  : statements statement\n\n"); 
				$$=$1;
				$$->code += $2->code;
		};
	  

statement  : expression_statement { fprintf(output,"statement  : expression_statement\n\n"); $$=$1;}
	   | compound_statement { fprintf(output,"statement  : compound_statement \n\n");$$=$1; }
	   | IF error LPAREN error RPAREN statement %prec LOWER_THAN_ELSE 
	    | IF LPAREN error RPAREN statement ELSE statement 
	   | WHILE LPAREN error RPAREN statement 
	   | RETURN error SEMICOLON 
	   | FOR LPAREN expression_statement expression_statement error RPAREN statement 
	   | FOR LPAREN expression_statement expression_statement expression RPAREN statement  
		{ fprintf(output,"statement  : FOR LPAREN expression_statement expression_statement expression RPAREN statement \n\n");
			$$=$3;
			char *label=newLabel();
			char *label1=newLabel();
			$$->code+=string(label)+": \n";
			$$->code+=$4->code;
			$$->code+="MOV AX,"+$4->name+"\n";
			$$->code+="CMP AX, 1 \n";
			$$->code+="JNE "+string(label1)+"\n";
			$$->code+=$7->code;
			$$->code+=$5->code;
			$$->code+="JMP "+string(label)+"\n";
			$$->code+=string(label1)+": \n";
 }
	   | IF LPAREN expression RPAREN statement 
		{ fprintf(output,"statement  : IF LPAREN expression RPAREN statement \n\n"); 
					$$=$3;
					//add codes here
					char *label=newLabel();
					$$->code+=$3->code;
					$$->code+="MOV AX,"+$3->name+"\n";
					$$->code+="CMP AX, 1\n";
					$$->code+="JNE "+string(label)+"\n";
					$$->code+=$5->code;
					$$->code+=string(label)+": \n";

		} %prec LOWER_THAN_ELSE 
	   | IF LPAREN expression RPAREN statement ELSE statement 
		{ fprintf(output,"statement  : IF LPAREN expression RPAREN statement ELSE statement \n\n"); 
					//fout<<"in if-else\n";
					// add codes for generation part
					char *label=newLabel();
					char *label1=newLabel();
					$$->code+=$3->code;
					$$->code+="MOV AX,"+$3->name+"\n";
					$$->code+="CMP AX, 1\n";
					$$->code+="JNE "+string(label)+"\n";
					$$->code+=$5->code;
					$$->code+=string(label)+": \n";
					$$->code+=$7->code;
					$$->code+=string(label1)+": \n";
		}
	   | WHILE LPAREN expression RPAREN statement { fprintf(output,"statement  : WHILE LPAREN expression RPAREN statement \n\n"); 
		$$=new symbolInfo();
		// add codes for generation part
		char *label=newLabel();
		char *label1=newLabel();
		$$->code+=string(label)+": \n";
		$$->code+=$3->code;
		$$->code+="MOV AX,"+$3->name+"\n";
		$$->code+="CMP AX, 1 \n";
		$$->code+="JNE "+string(label1)+"\n";
		$$->code+=$5->code;
		$$->code+="JMP "+string(label)+"\n";
		$$->code+=string(label1)+": \n";
		}
	   | PRINTLN LPAREN ID RPAREN SEMICOLON { 
		fprintf(output,"statement  : PRINTLN LPAREN ID RPAREN SEMICOLON \n\n");
		idprint=table->lookOut($3->name);
		if(idprint!=Null)
		{	
			if(idprint->data==integer){
				printf("\n\n\nPRINTLN LPAREN ID RPAREN SEMICOLON  %d\n\n\n",idprint->val.i);
				$$=$3;
				printf("data type:%d\n",$$->data);
				$$->code+="MOV AX, "+string($3->getName())+ "\n";
				//add codes for generation part
				$$->code+="CALL outDec\n";
						}
			else if(idprint->data==floating)
				printf("\n\n\nPRINTLN LPAREN ID RPAREN SEMICOLON  %f\n\n\n",idprint->val.f); 
			else if(idprint->data==character){
				printf("\n\n\nPRINTLN LPAREN ID RPAREN SEMICOLON  %c\n\n\n",idprint->val.c);
					    $$=$3;
					    //add codes for generation part
					    $$->code+="LEA DX, "+$3->getName()+"\n";
					    $$->code+="MOV AH, 09h \n";
					    $$->code+="INT 21h\n";
					}
		}
		else {
			char errorarr[30]="Undeclared ID: ";
			strcat(errorarr,$3->name.c_str());							
			yyerror(errorarr);
		}
		}
	   | RETURN expression SEMICOLON  { fprintf(output,"statement  : RETURN expression SEMICOLON \n\n");
		$$=$2;
		//add codes for generatin part
		$$->code+="MOV AH, 4CH\nINT 21H\n";
		
 	};

		
expression_statement	: SEMICOLON { fprintf(output,"expression_statement  : SEMICOLON \n\n"); $$->code="";}		
			| expression SEMICOLON { fprintf(output,"expression_statement  : expression SEMICOLON \n\n"); $$=$1;}	
			| error SEMICOLON 
			;
						
variable : ID 	{ fprintf(output,"variable  : ID \n\n"); 
			notget=table->lookOut($1->name);
			if(notget!=Null)
			{
				$$=new symbolInfo(notget);
				if($$->arraysz!=0){yyerror("Identifier to an array");}

			}
			else
			{
			char errorarr[30]="Undeclared ID: ";
			strcat(errorarr,$1->name.c_str());							
			yyerror(errorarr);
			}
		}
	 | ID LTHIRD error RTHIRD 
	 | ID error LTHIRD expression RTHIRD 	
	 | ID LTHIRD expression RTHIRD 
		{ fprintf(output,"variable  : ID LTHIRD expression RTHIRD\n\n"); 
			notget=table->lookOut($1->name);
			if(notget!=Null)
			{
				
				if(notget->arraysz>0) 
				{
					ix=$3;
					n=$3->name;
					$$=new symbolInfo(notget);
					$$->code=$3->code;
					if($3->data==floating){yyerror("invalid index");}
					else if($3->val.i>=$$->arraysz || $3->val.i<0){yyerror("Array Index out of bound");}
				}
				else if(notget->arraysz==0)
					{
					char errorarr[30]="Not an array : ";
					strcat(errorarr,$1->name.c_str());							
					yyerror(errorarr);
					}
			}
			else
			{
			char errorarr[30]="Undeclared ID: ";
			strcat(errorarr,$1->name.c_str());							
			yyerror(errorarr);
			}
		};
			
expression : logic_expression { fprintf(output,"expression : logic_expression\n\n");
	 	$$=$1;
		}	
	   | variable ASSIGNOP logic_expression 
		{ fprintf(output,"expression : variable ASSIGNOP logic_expression\n\n"); 
		if($3->data==invalid){}
		else if(($1->data==integer||$1->data==character)&&$3->data==floating)
 		{yyerror("Type mismatch");}
		//fprintf(output,"Warning::Casting float to integer/character\n\n");}
		else{
		$$=$1;
		$$->code=$3->code+$1->code;
			if($1->arraysz==0){
				// add codes for generation part
				$$->code+="MOV AX, "+$3->name+"\n";
				$$->code+="MOV "+$1->name+", AX\n";
				
				if($1->data==integer && $3->data==integer)
				{
					//$1->val.i=What will be here??
					$1->val.i=$3->val.i;
					$1->data=$3->data;
				}
				// add codes for others
				 if($1->data==floating && $3->data==integer)
				{
					$1->val.f=$3->val.i;
					fprintf(output,"is it even working?");

				}
				if($1->data==floating && $3->data==floating)
				{
					$1->val.f=$3->val.f;
				}
				if($1->data==floating && $3->data==character)
				{
					$1->val.f=$3->val.c;
				}
				if($1->data==integer && $3->data==character)
				{

					$1->val.i=$3->val.c;
				}
				if($1->data==character && $3->data==character)
				{
					$1->val.c=$3->val.c;
					$1->data=$3->data;
				}
				if($1->data==character && $3->data==integer)
				{
					$1->val.c=$3->val.i;
				}				
				table->print(output);
					}
			else if($1->arraysz>0)
			{
				
				
				if($3->data==integer)
				{
					$1->val.arrayi[ix->val.i]=$3->val.i;
					$1->data=$3->data;
				}
				
			table->print(output);	
			}
		}
		};
			
logic_expression : rel_expression { fprintf(output,"logic_expression : rel_expression\n\n");
			$$=$1; 
			}	
		 | rel_expression LOGICOP rel_expression 
			{ fprintf(output,"logic_expression : rel_expression LOGICOP rel_expression\n\n");
				$$=$1;
				$$->code+=$3->code;
				$$->code+="MOV AX, " + $1->getName()+"\n";
				$$->code+="MOV BX, " + $3->getName()+"\n";
				char *temp=newTemp();
				char *label1=newLabel();
				char *label2=newLabel();
				//char *label3=newLabel();
				if((strcmp($2->name.c_str(),"&&"))==0)
				{
				//add codes here for generation part
				$$->code+="CMP AX, 1\n";
				$$->code+="JNE "+string(label1)+"\n";
				$$->code+="CMP BX, 1\n";
				$$->code+="JNE "+string(label1)+"\n";
				$$->code+="MOV "+string(temp)+", 1\n";
				$$->code+="JMP "+string(label2)+"\n";
				$$->code+=string(label1)+": \n";
				$$->code+="MOV "+string(temp)+", 0\n";
				$$->code+=string(label2)+": \n";
				$$->name=temp;

					if ($1->data==integer&&$3->data==integer)//int&&int
					{
							printf("%d",$1->val.i);
							if($1->val.i==0||$3->val.i==0)
							{
							$$->val.i=0;
							$$->data=integer;
							}
							else
							{
							$$->val.i=1;
							$$->data=integer;
							}
							printf("&&%d=%d\n",$3->val.i,$$->val.i);
					}
					else if ($1->data==integer&&$3->data==floating)//int&&float
					{
						printf("%d",$1->val.i);
						if(static_cast<float>($1->val.i)==0||$3->val.f==0)
						{
						$$->val.i=0;
						$$->data=integer;
						}
						else
						{
						$$->val.i=1;
						$$->data=integer;
						}
						printf("&&%f=%d\n",$3->val.f,$$->val.i);
					}
					else if ($1->data==floating&&$3->data==integer)//float&&int
					{
						printf("%f",$1->val.f);
						if($3->val.i==0||$1->val.f==0)
						{
						$$->val.i=0;
						$$->data=integer;
						}
						else
						{
						$$->val.i=1;
						$$->data=integer;
						}
						printf("&&%d=%d\n",$3->val.i,$$->val.i);
					}
					else if ($1->data==floating&&$3->data==floating)//float&&float
					{
						printf("%f",$1->val.f);
						if($1->val.f==0||$3->val.f==0)
						{
						$$->val.i=0;
						$$->data=integer;
						}
						else
						{
						$$->val.i=1;
						$$->data=integer;
						}
						printf("&&%f=%d\n",$3->val.f,$$->val.i);
					}
						
				}
				else if((strcmp($2->name.c_str(),"||"))==0)
				{
					//add codes here for generation part
					$$->code+="CMP AX, 0\n";
				$$->code+="JNE "+string(label1)+"\n";
				$$->code+="CMP BX, 0\n";
				$$->code+="JNE "+string(label1)+"\n";
				$$->code+="MOV "+string(temp)+", 0\n";
				$$->code+="JMP "+string(label2)+"\n";
				$$->code+=string(label1)+": \n";
				$$->code+="MOV "+string(temp)+", 1\n";
				$$->code+=string(label2)+": \n";
				$$->name=temp;
				if ($1->data==integer&&$3->data==integer)//int&&int
					{
							printf("%d",$1->val.i);
							if($1->val.i==0 && $3->val.i==0)
							$$->val.i=0;
							else
							$$->val.i=1;
							printf("||%d=%d\n",$3->val.i,$$->val.i);
							$$->data=integer;
					}
					else if ($1->data==integer&&$3->data==floating)//int||float
					{
						printf("%d",$1->val.i);
						//static_cast<float>($1->val.i) just convert the int to float type and then compare simply
						if(static_cast<float>($1->val.i)==0 && $3->val.f==0)
							$$->val.i=0;
						else
							$$->val.i=1;
						printf("||%f=%d\n",$3->val.f,$$->val.i);
						$$->data=integer;
					}
					else if ($1->data==floating&&$3->data==integer)//float||int
					{
						printf("%f",$1->val.f);
						if($1->val.f==0 && static_cast<float>($3->val.i)==0)
							$$->val.i=0;
						else
							$$->val.i=1;
						printf("||%d=%d\n",$3->val.i,$$->val.i);
						$$->data=integer;
					}
					else if ($1->data==floating&&$3->data==floating)//float||float
					{
						printf("%f",$1->val.f);
						if($1->val.f==0 && $3->val.f==0)
							$$->val.i=0;
						else
							$$->val.i=1;
						printf("||%f=%d\n",$3->val.f,$$->val.i);
						$$->data=integer;
					}	
											
				} 
			};
			
rel_expression	: simple_expression { fprintf(output,"rel_expression : simple_expression\n\n"); 
				$$= $1;}
		| simple_expression RELOP simple_expression
			{ fprintf(output,"rel_expression : simple_expression RELOP simple_expression\n\n"); 
				$$=$1;
				$$->code+=$3->code;
				$$->code+="MOV AX, " + $1->getName()+"\n";
				$$->code+="CMP AX, " + $3->getName()+"\n";
				char *temp=newTemp();
				char *label1=newLabel();
				char *label2=newLabel();
				if((strcmp($2->name.c_str(),"<"))==0)
				{
					$$->code+="JL " + string(label1)+"\n";					
					if ($1->data==integer&&$3->data==floating)//int<float
					{
						printf("%d",$1->val.i);
						if(static_cast<float>($1->val.i)<$3->val.f)
						{
						$$->val.i=1;
						$$->data=integer;
						}
						else
						{
						$$->val.i=0;
						$$->data=integer;
						}
						printf("<%f=%d\n",$3->val.f,$$->val.i);
					}
					else if ($1->data==floating&&$3->data==integer)//float<int
					{
						printf("%f",$1->val.f);
						if(static_cast<float>($3->val.i)>$1->val.f)
						{
						$$->val.i=1;
						$$->data=integer;
						}
						else
						{
						$$->val.i=0;
						$$->data=integer;
						}
						printf("<%d=%d\n",$3->val.i,$$->val.i);
					}
					else if ($1->data==integer&&$3->data==integer)//int<int
					{
						printf("%d",$1->val.i);
						if($1->val.i<$3->val.i)
						{
						$$->val.i=1;
						$$->data=integer;
						}
						else
						{
						$$->val.i=0;
						$$->data=integer;
						}
						printf("<%d=%d\n",$3->val.i,$$->val.i);
					}
					else if ($1->data==floating&&$3->data==floating)//float<float
					{
						printf("%f",$1->val.f);
						if($1->val.f<$3->val.f)
						{
						$$->val.i=1;
						$$->data=integer;
						}
						else
						{
						$$->val.i=0;
						$$->data=integer;
						}
						printf("<%f=%d\n",$3->val.f,$$->val.i);
					}				
											
				}
				else if((strcmp($2->name.c_str(),">")==0))
				{
					$$->code+="JG " + string(label1)+"\n";	
				}
				else if((strcmp($2->name.c_str(),"<="))==0)
				{
					$$->code+="JLE " + string(label1)+"\n";	
				}
				else if((strcmp($2->name.c_str(),">="))==0)
				{
					$$->code+="JGE " + string(label1)+"\n";	
				}
				else if((strcmp($2->name.c_str(),"!="))==0)
				{
					$$->code+="JNE " + string(label1)+"\n";	
				
				}
				$$->code+="MOV "+string(temp) +", 0\n";
				$$->code+="JMP "+string(label2) +"\n";
				$$->code+=string(label1)+":\nMOV "+string(temp)+", 1\n";
				$$->code+=string(label2)+":\n";
				$$->name=temp;
				};

				
simple_expression : term 
	{ fprintf(output,"simple_expression : term\n\n");
		$$= $1;
	}
		  | simple_expression ADDOP term 
	{ fprintf(output,"simple_expression : simple_expression ADDOP term  \n\n"); 
		$$=$1;
		$$->code+=$3->code;
		$$->code+="MOV AX, " + $1->getName()+"\n";
		$$->code+="MOV BX, " + $3->getName()+"\n";
		if((strcmp($2->name.c_str(),"+"))==0)
		{
		$$->code+="ADD AX, BX\n";
			//add codes for generation part
			if($1->data==integer&&$3->data==integer)//integer+integer
			{printf("%d",$1->val.i);
			$$->val.i=$1->val.i+$3->val.i;
			$$->data==$1->data;
			printf("+%d:%d\n",$3->val.i,$$->val.i);
			}
			else if ($1->data==floating&&$3->data==floating)//float+float
			{
			printf("%f",$1->val.f);
			$$->val.f=$1->val.f+$3->val.f;
			$$->data==$1->data;
			printf("+%f:%f\n",$3->val.f,$$->val.f);
			}
			else if ($1->data==integer&&$3->data==floating)//int+float=float
			{
			printf("%f",static_cast<float>($1->val.i));
			$$->val.f=static_cast<float>($1->val.i)+$3->val.f;
			$$->data==$3->data;
			printf("+%f:%f\n",$3->val.f,$$->val.f);
			}
			else if ($1->data==floating&&$3->data==integer)//int+float=float
			{
			printf("%f",$1->val.f);
			$$->val.f=static_cast<float>($3->val.i)+$1->val.f;
			$$->data==$1->data;
			printf("+%f:%f\n",static_cast<float>($3->val.i),$$->val.f);
			}
			char *temp=newTemp();
			$$->code+="MOV "+string(temp)+", AX\n";
			$$->name=temp;
				
		} 
		else if((strcmp($2->name.c_str(),"-"))==0)
		{
			//add codes for generation as per the + 
		 $$->code+="SUB AX, BX\n";
		 char *temp=newTemp();
			$$->code+="MOV "+string(temp)+", AX\n";
			$$->name=temp;
 
		} } ;
					
term :	unary_expression { fprintf(output,"term : unary_expression\n\n");
				$$= $1;
			}
     |  term MULOP unary_expression { fprintf(output,"term : term MULOP unary_expression\n\n");
						$$=$1;
						$$->code += $3->code;
						//add codes for multiplication
		$$->code+="MOV AX, " + $1->getName()+"\n";
		$$->code+="MOV BX, " + $3->getName()+"\n";
		if((strcmp($2->name.c_str(),"*")==0))
			{

				//add codes for multiplication
				$$->code+="MUL BX\n";

				if($1->data==integer&&$3->data==integer)//integer is multipllied by integer
				{
				printf("%d",$1->val.i);
				$$->val.i=$1->val.i*$3->val.i;$$->data=$1->data;
				printf("*%d=%d\n",$3->val.i,$$->val.i);
				}
			char *temp=newTemp();
			$$->code+="MOV "+string(temp)+", AX\n";
			$$->name=temp;				
					
			} 
		else if (strcmp($2->name.c_str(),"%")==0)
			{
				$$->code += "MOV DX, 0\n";
				$$->code += "MOV AX, "+ $1->getName()+"\n";
				$$->code += "MOV BX, "+ $3->getName()+"\n";
				char *temp=newTemp();
				$$->code += "DIV BX\n";
				$$->code += "MOV "+ string(temp) + ", DX\n";
				$$->name=temp;
				if ($1->data!=integer||$3->data!=integer){$$->data=invalid;yyerror("invalid operands for modulo");}
				else if ($1->data==integer&&$3->data==integer)//other cases are not acceptable
				{
				printf("%d",$1->val.i);
				$$->val.i=($1->val.i)%($3->val.i);
				$$->data=$1->data;
				printf(" %d=%d\n",$3->val.i,$$->val.i);
				};
			}
		else {
				//add codes for generation part
				$$->code += "MOV AX, "+ $1->getName()+"\n";
				$$->code += "MOV DX, 0\n";
				$$->code += "MOV BX, "+ $3->getName()+"\n";
				$$->code += "DIV BX\n";
				char *temp=newTemp();
				$$->code += "MOV "+ string(temp) + ", AX\n";
				$$->name=temp;
				
		      }	};

unary_expression : ADDOP unary_expression 
		{ fprintf(output,"unary_expression : ADDOP unary_expression \n\n"); 
		if((strcmp($1->name.c_str(),"+")==0))
			{
				$$=$2;
				if($2->data==integer)
				{
				$$->val.i=$2->val.i;
				$$->data==$2->data;
				}
				else if ($2->data==floating)
				{
				$$->val.f=$2->val.f;
				$$->data==$2->data;
				}
			} 
		else {
				char *temp= newTemp();
				$$=$2;
				//add codes for generation part
				$$->code += "MOV AX, "+ $2->getName()+"\n";
				$$->code += "NEG AX\n";
				$$->code += "MOV "+ string(temp) + ", AX\n";
				$$->name=temp;
				if($2->data==integer)
				{
				$$->val.i=($2->val.i)*(-1);
				$$->data==$2->data;
				}
				else if ($2->data==floating)	
				{
				$$->val.f=($2->val.f)*(-1);
				$$->data==$2->data;
				}
		     }
		} 
		 | NOT unary_expression 
			{ fprintf(output,"unary_expression : NOT unary_expression \n\n");
				$$=$2;
				$$->data==$2->data;
				char *temp=newTemp();
				$$->code="MOV AX, " + $2->getName() + "\n";
				$$->code+="NOT AX\n";
				$$->code+="MOV "+string(temp)+", AX";
				$$->name=temp;
				if($2->data==integer)//!5=0 !0=1
				{
					if($2->val.i==0)
					{
					$$->val.i=1;
					}
					else
					{
					$$->val.i=0;
					}
				}
				else if ($2->data==floating)
				{
					if($2->val.f==0)
					{
					$$->val.f=1.0;
					}
					else
					{
					$$->val.f=0;
					}
				}
			}
		 | factor { fprintf(output,"unary_expression : factor\n\n");
				$$=new symbolInfo($1->name,$1->type,$1->position);
				$$->data=$1->data;
				$$->arraysz=$1->arraysz;
				$$->code=$1->code;
				if($$->arraysz==0)
				{
					printf("normal factor\n ");
					if($1->data==integer)
					{
					$$->val.i=$1->val.i;
					}
					else if($1->data==floating)
					{
					$$->val.f=$1->val.f;
					}
					else if($1->data==character)
					{
					$$->val.c=$1->val.c;
					}
				}
				else
				{
					printf("array factor\n ");
					if($1->data==integer)
					{
					$$->val.i=$1->val.arrayi[ix->val.i];
					}
					else if($1->data==floating)
					{
					$$->val.f=$1->val.arrayf[ix->val.i];
					}
					else if($1->data==character)
					{
					$$->val.c=$1->val.arrayc[ix->val.i];
					}
			} };
	
factor	: variable { fprintf(output,"factor : variable\n\n");
		$$=$1;
		if($1->arraysz==0)
		{
		}
		else
		{
				$$->code+="LEA DI, " + $1->getName()+"\n";
				for(int s=0;s<2;s++){
					//ostringstream sin;
					//sin << ix->val.i;
					$$->code += "ADD DI, " + n +"\n";
				}
				char *temp= newTemp();
				//$$->code+= "MOV " + string(temp) + ", [DI]\n";
				//$$->name=temp;
				$$->code+= "MOV AX, [DI]\n";
				$$->code+= "MOV " + string(temp) + ", AX\n";
				$$->name=temp;
				n="";
		}
}
	| LPAREN expression RPAREN {
				 fprintf(output,"factor : LPAREN expression RPAREN\n\n");
				 $$=$2;
				   }
	| CONST_INT { 
			fprintf(output,"factor : CONST_INT\n%d\n\n",$1->val.i);
			$$=$1;
			
		    }
	| CONST_FLOAT	{ 
			fprintf(output,"factor : CONST_FLOAT\n%s\n\n",$1->name.c_str());
			$$=$1;
			}
	| CONST_CHAR	{ 
		fprintf(output,"factor : CONST_CHAR\n%s\n\n",$1->name.c_str());
			$$=$1;
			}
	| variable INCOP { fprintf(output,"variale : variable INCOP\n\n\n"); 

	if($1->arraysz==0){
		if($1->data==integer)
			{
			$1->val.i++;
			$$=$1;
			printf("\nfactor++ %d\n",$$->val.i);
			}
		else if($1->data==floating)
			{
			$1->val.f++;
			$$=$1;
			}
		else if($1->data==character)
			{
			$1->val.c++;
			$$=$1;
			}
		$$->code += "INC " + $1->getName() + "\n";
	}

	else
		{
				$$=$1;
				$$->code+="LEA DI, " + $1->getName()+"\n";
				for(int s=0;s<2;s++){
					//ostringstream sin;
					//sin << ix->val.i;
					$$->code += "ADD DI, " + n +"\n";
				}
				//char *temp= newTemp();
				$$->code+= "MOV AX, [DI]\n";
				//$$->name=temp;
				n="";
				cout<<ix->val.i<<endl;
				if($1->data==integer)
					{
					$1->val.arrayi[ix->val.i]++;
					cout<<"here1"<<endl;
					//$$=$1;
					cout<<"here2"<<endl;
					printf("\nfactor-- %d\n",$$->val.i);
					}
				else if($1->data==floating)
					{
					$1->val.arrayf[ix->val.i]++;
					//$$=$1;
					printf("\nfactor-- %f\n",$$->val.f);
					}
				else if($1->data==character)
					{
					$1->val.arrayc[ix->val.i]++;
					//$$=$1;
					printf("\nfactor-- %c\n",$$->val.c);
					}
					$$->code += "INC AX \n";
					$$->code+= "MOV [DI], AX\n";
		}
						
 			}
	| variable DECOP { fprintf(output,"variale : variable DECOP\n\n");
		if($1->arraysz==0){ 
				if($1->data==integer)
					{
					$1->val.i--;
					$$=$1;
					}
				else if($1->data==floating)
					{
					$1->val.f--;
					$$=$1;
					}
				else if($1->data==character)
					{
					$1->val.c--;
					$$=$1;
					}
					$$->code += "DEC " + $1->getName() + "\n";
				}
		else
		{
				//add codes as per the INC operation
				if($1->data==integer)
					{
					$1->val.arrayi[ix->val.i]--;
					$$=$1;
					printf("\nfactor-- %d\n",$$->val.i);
					}
				if($1->data==floating)
					{
					$1->val.arrayf[ix->val.i]--;
					$$=$1;
					}
				if($1->data==character)
					{
					$1->val.arrayc[ix->val.i]--;
					$$=$1;
					}
                }
		
			};

%%

int main(int argc,char *argv[])
{

	extern FILE* yyin;	
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
	output= fopen("16201068_output.txt","w");
	yyin= input;
    	yyparse();
	printf("\nline   %d\n",line);
	fprintf(output,"\nLine   : %d\n\n",line);
	fprintf(output,"\nError   : %d\n\n",error);
	fprintf(output,"\n\nSymbol Table\n\n");
	table->print(output);
	fclose(yyin);
	fclose(output);
	optimization("16201068_code.asm");
    exit(0);
return 0;
}

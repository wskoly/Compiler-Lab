#include<iostream>
#include<string>
#include<stdio.h>
#include<stdlib.h>
#include<fstream>
using namespace std;

#define Null 0
#define SIZE 200
#define integer 115
#define floating 119
#define character 105
#define invalid 10


union value 
{
	int i;
	float f;
	char c;
	int* arrayi;
	float* arrayf;
	char* arrayc;
};

class symbolInfo
{
    public:
    int data;
    int arraysz=0;
    string name;
    string type;
    string code;//newly added
    int position;
    value val; 
    symbolInfo *next;
symbolInfo(string n,string t,int p)
{
    data=-111; //data type for int float and char let int=115 char=105 float=119
    name=n;
    type=t;
    position=p;
    next=Null;
    code="";
}
symbolInfo()
{
    data=0; //data type for int float and char let int=115 char=105 float=119
    name="";
    type="";
    position=0;
    next=Null;
    code="";
}
symbolInfo(const symbolInfo* s)
{
    data=s->data; //data type for int float and char let int=115 char=105 float=119
    name=s->name;
    type=s->type;
    position=s->position;
    next=Null;
    arraysz=s->arraysz;
    code=s->code;
	if(s->arraysz==0)
	{
		if(s->data==integer)val.i=s->val.i;
		else if(s->data==floating)val.f=s->val.f;
		else val.c=s->val.c;
	}
	else
	{
		if(s->data==integer)
			{
				val.arrayi=(int*)malloc((s->arraysz)*sizeof(int));
				for(int i=0;i<arraysz;i++)val.arrayi[i]=s->val.arrayi[i];
			}
		else if(s->data==floating)
			{
				val.arrayf=(float*)malloc((s->arraysz)*sizeof(float));
				for(int i=0;i<arraysz;i++)val.arrayf[i]=s->val.arrayf[i];
			}
		else 
			{
				val.arrayc=(char*)malloc((s->arraysz)*sizeof(char));
				for(int i=0;i<arraysz;i++)val.arrayc[i]=s->val.arrayc[i];
			}
	}
}
string getName(){return name;}
string getType(){return type;}
};




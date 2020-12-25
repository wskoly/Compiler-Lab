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
}
};




#include<iostream>
#include<string>
#include<stdio.h>
#include<stdlib.h>
#include<fstream>
using namespace std;

#define Null 0
#define SIZE 200


//ofstream outText("output.txt");
class symbolInfo
{
    public:
    string name;
    string type;
    int position;
    symbolInfo *next;
    symbolInfo(string n,string t,int p);
};
symbolInfo::symbolInfo(string n,string t,int p)
{
    name=n;
    type=t;
    position=p;
    next=Null;
}


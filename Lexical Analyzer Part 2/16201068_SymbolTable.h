/*#include<iostream>
#include<string>
#include<stdio.h>
#include<stdlib.h>
#include<fstream>*/
#include"1305115_SymbolInfo.h"
using namespace std;

#define Null 0
#define SIZE 200


ofstream outText("output.txt");

class symbolTable
{
    symbolInfo **smbl;
    int sz;
public:
    symbolTable(int sz);
    ~symbolTable();
    string getType(string name);
    int getKey(string name);
    void insertItem(FILE *s,string name,string type);
    int lookOut(string name);
    void deleteItem(string name);
    void print(FILE *s);
};
symbolTable::symbolTable(int sz)
{
    //smbl=new symbolInfo*[SIZE];
    this->sz=sz;
    smbl=new symbolInfo*[sz];
    for(int i=0;i<sz;i++)
        smbl[i]=Null;

}
symbolTable::~symbolTable()
{
    for(int i=0;i<sz;i++)
    {
        symbolInfo *start=smbl[i],*prev;
        while(start!=Null)
        {
            prev=start;
            start=start->next;
            delete prev;
        }
    }
    delete *smbl;
}
string symbolTable::getType(string name)
{
    int key=getKey(name);
    symbolInfo *temp=smbl[key];
    while(temp!=Null)
    {
        if(temp->name==name)
            return temp->type;
        else
            temp=temp->next;
    }
}
int symbolTable::getKey(string name)
{
    int len=name.length();
    int sum=0;
    for(int i=0;i<len;i++)
    {
        sum=sum+name[i];
    }
    return sum%sz;
}
void symbolTable::insertItem(FILE *s,string n,string t)
{
    cout<<"I"<<endl;
    //outText<<"I"<<endl;
    int key=getKey(n);
    int check=lookOut(n);
    if(check!=-1)
    {
        cout<<"< "<<n<<","<<t<<" > already exists"<<endl<<endl;
        outText<<"< "<<n<<","<<t<<" > already exists\n"<<endl<<endl;
	fprintf(s,"<%s, %s> already exits\n\n",n.c_str(),t.c_str());
	print(s);
    }
    else if(check==-1)
    {
        symbolInfo *newNode;
        newNode=new symbolInfo(n,t,0);
        if(smbl[key]==Null)
                smbl[key]=newNode;
        else
            {
                symbolInfo *temp=smbl[key];
                symbolInfo *prev;
                while(temp!=Null)
                    {
                        prev=temp;
                        temp=temp->next;
                    }
                prev->next=newNode;
                newNode->position=prev->position+1;
            }
	print(s);
            cout<<"< "<<newNode->name<<","<<newNode->type<<" > "<<"inserted at position"<<" "<<key<<","<<newNode->position<<endl<<endl<<endl;
           // outText<<"< "<<newNode->name<<","<<newNode->type<<" > "<<"inserted at position"<<" "<<key<<","<<newNode->position<<endl<<endl<<endl;
	
    }
}
int symbolTable::lookOut(string name)
{
   // cout<<"L"<<endl;
   // outText<<"L"<<endl;
    int key=getKey(name);
    symbolInfo *temp=smbl[key];
    if(temp==Null)
         return -1;


    while(temp!=Null)
    {
        if(temp->name==name){
            //cout<<"< "<<temp->name<<","<<temp->type<<" > "<<"found at position "<<key<<","<<temp->position<<endl<<endl<<endl;
            //outText<<"< "<<temp->name<<","<<temp->type<<" > "<<"found at position "<<key<<","<<temp->position<<endl<<endl<<endl;
            return temp->position;
            break;
        }
        else
            temp=temp->next;
    }
    //cout<<"not found"<<endl<<endl<<endl;
    //outText<<"not found"<<endl<<endl<<endl;
    return -1;
}
void symbolTable::deleteItem(string name)
{
    cout<<"D"<<endl;
    outText<<"D"<<endl;
    int key=getKey(name);
    int c=lookOut(name);
    if(c==-1)
    {
        cout<<name<<" is not found for deletion"<<endl<<endl;
        outText<<name<<" is not found for deletion"<<endl<<endl;
        return;
    }
    if(smbl[key]!=Null)
    {
        symbolInfo *temp=smbl[key];
        symbolInfo *start=temp;
        symbolInfo *prev;
        if(start->name==name)
            {
                int sv=start->position;
                smbl[key]=start->next;
                while(temp!=Null)
                {
                    temp->position=temp->position-1;
                    temp=temp->next;
                }
                //delete temp;
                cout<<name<<" is Deleted from position "<<key<<","<<sv<<endl<<endl<<endl;
                outText<<name<<" is Deleted from position "<<key<<","<<sv<<endl<<endl<<endl;
                return;
            }
        while(temp!=Null)
        {
            if(temp->name!=name)
            {
                prev=temp;
                temp=temp->next;
            }
            else
                break;
        }
       // if(temp==Null)return;
        prev->next=temp->next;
        int save=temp->position;
        symbolInfo *s=temp->next;
        while(s!=Null)
        {
            s->position=s->position-1;
            s=s->next;
        }
        cout<<name<<" is Deleted from position "<<key<<","<<save<<endl<<endl<<endl;
        outText<<name<<" is Deleted from position "<<key<<","<<save<<endl<<endl<<endl;
    }
}
void symbolTable::print(FILE *s)
{
    cout<<"P"<<endl;
    outText<<"P"<<endl;
        for(int i=0;i<sz;i++)
        {
            if(smbl[i]!=Null)
            {
                symbolInfo *temp=smbl[i];
                while(temp->next!=Null)
                {
                    if(temp->position==0)
                    {
                        cout<<i<<"-> ";
                        outText<<i<<"-> ";
			fprintf(s,"%d -> ",i);
                    }
                    cout<<" < "<<temp->name<<":"<<temp->type<<" > ";
                   outText<<" < "<<temp->name<<":"<<temp->type<<" > ";
		fprintf(s,"<%s : %s> ",temp->name.c_str(),temp->type.c_str());
                   temp=temp->next;
                }
                if(temp->position==0)
                {
                    cout<<i<<"->";
                    outText<<i<<"-> ";
		    fprintf(s,"%d -> ",i);
                }
                    outText<<" <"<<temp->name<<":"<<temp->type<<" > ";
                    cout<<" <"<<temp->name<<":"<<temp->type<<" > ";
			fprintf(s,"<%s : %s> ",temp->name.c_str(),temp->type.c_str());
			fprintf(s,"\n");

            }
            else
            {
               // cout<<i<<"-> ";
               // outText<<i<<"-> ";
//break;
            }

           // cout<<endl;
          // outText<<endl;
	
        }
        cout<<endl;
        outText<<endl;
}




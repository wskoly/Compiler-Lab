#ifndef TABLE_H
#define TABLE_H

#include<iostream>
#include<string>
#include<stdio.h>
#include<stdlib.h>
#include<fstream>
#include"1305115_info.h"
using namespace std;

#define Null 0
#define SIZE 200




class symbolTable
{
    symbolInfo **smbl;
    int sz;
public:
    symbolTable(int sz)
{
    //smbl=new symbolInfo*[SIZE];
    this->sz=sz;
    smbl=new symbolInfo*[sz];
    for(int i=0;i<sz;i++)
        smbl[i]=Null;

}
    symbolTable()
{
    this->sz=0;
    
}
    ~symbolTable()
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
    string getType(string name)
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
    int getKey(string name)
{
    int len=name.length();
    int sum=0;
    for(int i=0;i<len;i++)
    {
        sum=sum+name[i];
    }
    return sum%sz;
}
    void insertItem(symbolInfo *newNode)
{
    int key=getKey(newNode->name);
    symbolInfo* check=lookOut(newNode->name);
    if(check==Null)
    {
        if(smbl[key]==Null){
                smbl[key]=newNode;
		
}
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
    }
}
    symbolInfo* lookOut(string name)
{
    int key=getKey(name);
    symbolInfo *temp=smbl[key];
    if(temp==Null)
         return Null;


    while(temp!=Null)
    {
        if(temp->name==name){
            return temp;
            break;
        }
        else
            temp=temp->next;
    }
    return Null;
}
    /*void deleteItem(string name)
{
    cout<<"D"<<endl;
    int key=getKey(name);
    int c=lookOut(name);
    if(c==-1)
    {
        cout<<name<<" is not found for deletion"<<endl<<endl;
       // outText<<name<<" is not found for deletion"<<endl<<endl;
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
                //outText<<name<<" is Deleted from position "<<key<<","<<sv<<endl<<endl<<endl;
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
        //outText<<name<<" is Deleted from position "<<key<<","<<save<<endl<<endl<<endl;
    }
}*/
    void print(FILE *s)
{
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
			fprintf(s,"%d -> ",i);
                    }

		fprintf(s,"<%s , %s,",temp->name.c_str(),temp->type.c_str());
		if(temp->arraysz==0){
				if(temp->data==integer)fprintf(s," %d> ",temp->val.i);
				else if(temp->data==floating)fprintf(s," %f> ",temp->val.f);
				else  fprintf(s," %c> ",temp->val.c);
				}
		else {
				if(temp->data==integer)
				{
					fprintf(s," { ");
					for(int h=0;h<temp->arraysz-1;h++)
					{
						fprintf(s,"%d,",temp->val.arrayi[h]);
					}
				fprintf(s,"%d> ",temp->val.arrayi[temp->arraysz-1]);
				}
				else if(temp->data==floating)
				{
					fprintf(s," { ");
					for(int h=0;h<temp->arraysz-1;h++)
					{
						fprintf(s,"%f,",temp->val.arrayf[h]);
					}
				fprintf(s,"%f> ",temp->val.arrayf[temp->arraysz-1]);
				}
				else if(temp->data==character)
				{
					fprintf(s," { ");
					for(int h=0;h<temp->arraysz-1;h++)
					{
						fprintf(s,"%c,",temp->val.arrayc[h]);
					}
				fprintf(s,"%c> ",temp->val.arrayc[temp->arraysz-1]);
				}
			}
                   temp=temp->next;
                }
                if(temp->position==0)
                {
                   
		    fprintf(s,"%d -> ",i);
                }
                  
			fprintf(s,"<%s , %s,",temp->name.c_str(),temp->type.c_str());
		if(temp->arraysz==0){
			if(temp->data==integer)fprintf(s," %d> ",temp->val.i);
			else if(temp->data==floating)fprintf(s," %f> ",temp->val.f);
			else  fprintf(s," %c> ",temp->val.c);
			fprintf(s,"\n");
				   }
		else {
				if(temp->data==integer)
				{
					fprintf(s," { ");
					for(int h=0;h<temp->arraysz-1;h++)
					{
						fprintf(s,"%d,",temp->val.arrayi[h]);
					}
				fprintf(s,"%d}> ",temp->val.arrayi[temp->arraysz-1]);
				}
				else if(temp->data==floating)
				{
					fprintf(s," { ");
					for(int h=0;h<temp->arraysz-1;h++)
					{
						fprintf(s,"%f,",temp->val.arrayf[h]);
					}
				fprintf(s,"%f}> ",temp->val.arrayf[temp->arraysz-1]);
				}
				else if(temp->data==character)
				{
					fprintf(s," { ");
					for(int h=0;h<temp->arraysz-1;h++)
					{
						fprintf(s,"%c,",temp->val.arrayc[h]);
					}
				fprintf(s,"%c}> ",temp->val.arrayc[temp->arraysz-1]);
				}
			fprintf(s,"\n");
			}
			

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
        //outText<<endl;
}
};






#endif


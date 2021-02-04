#include<iostream>
#include<string>
#include<stdio.h>
#include<stdlib.h>
#include<fstream>
using namespace std;

#define Null 0

ofstream outText("out.txt");
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

class symbolTable
{
    symbolInfo **smbl;//array of class symbolinfo to store info
    int sz;//size of info table
public:
    symbolTable(int sz);
    ~symbolTable();
    int hashValue(string n); // function for calculating hash of symbol
    void lookUp(string n); // function for searching symbol
    int lookOut(string n); // function for checking if smbl[key] is null or the symbol exist
    void insertSymbol(string n, string t); // function for inserting a symbol
    void printSymbol(); // function for printing the symbols in symbol table
    void delSymbol(string n); // function for delete a symbol


};
symbolTable::symbolTable(int sz)//constructor
{
    //smbl=new symbolInfo*[SIZE];
    this->sz=sz;//size is defined by user
    smbl=new symbolInfo*[sz];//allocating memory
    for(int i=0; i<sz; i++)
        smbl[i]=Null;

}
symbolTable::~symbolTable()//destructor
{
    for(int i=0; i<sz; i++)
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
int symbolTable::lookOut(string n)//function for searching a symbol is existed or not
{
    int key=hashValue(n);
    if(smbl[key]==Null)
    {
        return -1;
    }
    else
    {
        if(smbl[key]->name==n)
            return 1;
        else
        {
            symbolInfo *temp;
            temp=smbl[key];
            int flag=0;
            while(temp->next!=Null)
            {
                temp=temp->next;
                if(temp->name==n)
                {
                    flag++;
                    return 1;
                    break;
                }
            }
            if(flag==0)
                return -1;
        }
    }

}
void symbolTable::lookUp(string n) //function for searching a symbol
{
    int key=hashValue(n);
    if(smbl[key]==Null)
    {
        cout<<"<"<<n<<">is nowhere to be found"<<endl;//for output in console
        outText<<"<"<<n<<">is nowhere to be found"<<endl;//for output in text
    }
    else
    {
        if(smbl[key]->name==n)//comparing the first value
        {
            cout<<"<"<<n<<">Found at position <"<<key<<","<<smbl[key]->position<<">"<<endl;//for output in console
            outText<<"<"<<n<<">Found at position <"<<key<<","<<smbl[key]->position<<">"<<endl;//for output in text
        }
        else
        {
            symbolInfo *temp;
            temp=smbl[key];
            int flag=0;
            while(temp->next!=Null)
            {
                temp=temp->next;
                if(temp->name==n)
                {
                    cout<<"<"<<n<<">Found at position <"<<key<<","<<temp->position<<">"<<endl;//for output in console
                    outText<<"<"<<n<<">Found at position <"<<key<<","<<temp->position<<">"<<endl;//for output in text
                    flag++;
                    break;
                }
            }
            if(flag==0)
            {
                cout<<"<"<<n<<">is nowhere to be found"<<endl;//for output in console
                outText<<"<"<<n<<">is nowhere to be found"<<endl;//for output in text
            }
        }
    }

}
int symbolTable::hashValue(string n) // function for calculating hash value of a symbol
{
    int len= n.size(),sum=0;
    for(int i=0; i<len; i++)
    {
        sum+=n[i];
    }
    return sum%sz;//returning the calculated hash value
}
void symbolTable::insertSymbol(string n, string t)// function for inserting a symbol
{
    int key = hashValue(n);
    int look = lookOut(n);
    if (look == -1)
    {
        symbolInfo *symbol;
        symbol= new symbolInfo(n,t,0);
        if (smbl[key]==Null)
        {
            smbl[key]=symbol;//inserted at the beginning
            cout<<" < "<<n<<","<<t<<" >Inserted at position <"<<key<<","<<symbol->position<<">"<<endl; //for output in console
            outText<<" < "<<n<<","<<t<<" >Inserted at position <"<<key<<","<<symbol->position<<">"<<endl;//for output in text
        }
        else
        {
            symbolInfo *temp;
            temp=smbl[key];
            while(temp->next!=Null)
            {
                temp=temp->next;
            }
            symbol->position=(temp->position)+1;//assigning the position
            temp->next=symbol;
            cout<<" < "<<n<<","<<t<<" >Inserted at position <"<<key<<","<<symbol->position<<">"<<endl;//for output in console
            outText<<" < "<<n<<","<<t<<" >Inserted at position <"<<key<<","<<symbol->position<<">"<<endl;//for output in text
        }
    }
    else
    {
        cout<<"<"<<n<<","<<t<<">symbol is existed in the table"<<endl;//for output in console
        outText<<"<"<<n<<","<<t<<">symbol is existed in the table"<<endl;//for output in text
    }
}
void symbolTable::printSymbol()
{
    cout<<"Current SymbolTable:"<<endl;
    for(int i=0; i<sz ; i++)
    {
        if(smbl[i]!=Null)
        {
            cout<<i<<"->";
            outText<<i<<"->";
            if(smbl[i]!=Null)
            {
                symbolInfo *temp;
                temp=smbl[i];
                cout<<" < "<<temp->name<<":"<<temp->type<<" >";//for output in console
                outText<<" < "<<temp->name<<":"<<temp->type<<" >";//for output in text
                while(temp->next !=Null)
                {
                    temp=temp->next;
                    cout<<" < "<<temp->name<<":"<<temp->type<<" >";//for output in console
                    outText<<" < "<<temp->name<<":"<<temp->type<<" >";//for output in text
                }
            }
            cout<<endl;
            outText<<endl;
        }
    }
    cout<<endl;
    outText<<endl;
}
void symbolTable::delSymbol(string n)
{
    int key=hashValue(n);
    if(smbl[key]==Null)
    {
        cout<<"This symbol is not existed in the table"<<endl;//for output in console
        outText<<"This symbol is not existed in the table"<<endl;//for output in text
    }
    else
    {
        symbolInfo *temp;
        symbolInfo *prev;
        symbolInfo *pos;
        temp=smbl[key];
        if(temp->name==n)//comparing the first symbol
        {
            smbl[key]=temp->next;
            cout<<"< "<<n<<" > Deleted from position <"<<key<<","<<temp->position<<">"<<endl;//for output in console
            outText<<"< "<<n<<" > Deleted from position <"<<key<<","<<temp->position<<">"<<endl;//for output in text
            if(smbl[key]!=Null)
            {
                pos=smbl[key];
                pos->position=(pos->position)-1;// re adjusting the positions of remaining symbols
                while(pos->next!=Null)
                {
                    pos=pos->next;
                    pos->position=(pos->position)-1;// re adjusting the positions of remaining symbols
                }
            }
        }
        else
        {
            int flag=0;
            while(temp->next!=Null)
            {
                prev=temp;
                temp=temp->next;
                if(temp->name==n)
                {
                    cout<<" < "<<n<<" > Deleted from position <"<<key<<","<<temp->position<<">"<<endl;//for output in console
                    outText<<" < "<<n<<" > Deleted from position <"<<key<<","<<temp->position<<">"<<endl;//for output in text
                    flag++;
                    break;
                }
            }
            if(flag==0)
            {
                cout<<" < "<<n<<" > is nowhere to be found"<<endl;//for output in console
                outText<<" < "<<n<<" > is nowhere to be found"<<endl;//for output in text
            }
            else
            {
                prev->next=temp->next;
                while(prev->next!=Null)
                {
                    prev=prev->next;
                    prev->position=(prev->position)-1;// re adjusting the positions of remaining symbols
                }
            }
        }

    }
}
int main()
{
    ifstream  inText("input.txt");
    freopen("input.txt","r",stdin);
    int n;
    inText>>n;
    symbolTable s(n);
    char c;
    while(inText>>c)
    {
        if(c=='I')
        {
            string name;
            inText>>name; // read name from the input
            string type;
            inText>>type; // read type from the input
            cout<<"I"<<endl;//for output in console
            outText<<"I"<<endl;
            s.insertSymbol(name, type); // call function for inserting symbol
            cout<<endl;
            outText<<endl;
        }
        else if(c=='L')
        {
            string name;
            inText>>name; // read name from the input
            cout<<"L"<<endl;//for output in console
            outText<<"L"<<endl;
            s.lookUp(name);// call function for look up
            cout<<endl;
            outText<<endl;
        }
        else if(c=='P')
        {
            cout<<"P"<<endl;//for output in console
            outText<<"P"<<endl;
            s.printSymbol();// call function to print existing symbols
            cout<<endl;
            outText<<endl;
        }
        else if(c=='D')
        {
            string name;
            inText>>name;
            cout<<"D"<<endl;//for output in console
            outText<<"D"<<endl;
            s.delSymbol(name);// call function to delete a symbol
            cout<<endl;
            outText<<endl;
        }
    }
    inText.close();
    outText.close();
    return 0;
}


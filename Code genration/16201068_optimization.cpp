//#ifndef TABLE_H
//#define TABLE_H
#include <bits/stdc++.h>
#include<iostream>
#include<fstream>
#include<string>
using namespace std;


void optimization(const char *s)
{
 int flag1=0,flag2=0,flagmul=0,ln=0;
 ifstream myFile;
 ofstream optFile;
 optFile.open("16201068_final.asm");



 myFile.open(s);
 string line1="";
 string preLine="";
	 if (myFile.is_open())
	{
		 while (!myFile.eof())
		 {
			getline(myFile,line1);
            if((preLine.find("ADD")!= string::npos)||(preLine.find("SUB")!= string::npos))//Add or sub with zero
            {
                if(preLine[8]=='0')
                    flag1++;
            }
            if((preLine.find("MOV")!= string::npos) && (line1.find("MOV")!= string::npos))//Moving one register to another and again another to that register
			{
			    if((preLine.substr(4,2) == line1.substr(8,2)) && (preLine.substr(8,2) == line1.substr(4,2)))
                    {
                     flag2=2; cout<<"matched";
                    }
                else if((preLine.substr(4,1) == line1.substr(8,1)) && (preLine.substr(7,2) == line1.substr(4,2)))
                {
                    flag2=2;cout<<"matched";
                }
                else if((preLine.substr(4,2) == line1.substr(7,2)) && (preLine.substr(8,1) == line1.substr(4,1)))
                {
                    flag2=2;cout<<"matched";
                }
                else if((preLine.substr(4,1) == line1.substr(7,1)) && (preLine.substr(7,1) == line1.substr(4,1)))
                {
                    flag2=2;cout<<"matched";
                }
			}
			if((preLine.find("MOV")!= string::npos) && ((line1.find("MUL")!= string::npos)||(line1.find("DIV")!= string::npos)))//Division or Multiplication with 1
            {
             if(preLine[8]=='1');
              flag2=2;
            }
			cout<<line1<<" "<<line1.length()<<endl;

			if(ln>0 && flag1==0 && flag2==0){
			optFile<<preLine<<endl;
			}
			else
                flag1=0;
            preLine=line1;
               if(flag2>0)
                flag2--;
			ln++;
		}
		optFile<<preLine<<endl;
	}

 myFile.close();

return ;
}


//#endif


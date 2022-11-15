#include <iostream>
#include <iomanip>
#include <cstring>
#include <cctype>
using namespace std;

//Menu function
int menu();

//Function in option 1 and return the membership cost back to main function
double calc_mem();

//Minor function in option 2 which check member type and return member discount
double mem_func();

//Printing function
void prt_list();								//Print the list of items and pricing in option 2
void prt_sum(struct inventory_temp);			//Print summary of current purchase in option 2
void prt_end(struct inventory,int,double);		//Print daily summary in option 3 and option 4

//Function in option 2 which receive input, calculate, print and return inventory back to main function
struct inventory_temp fill_inventory(double);
struct inventory temp_convert(struct inventory_temp,struct inventory);

//Functions for error checking
int menu_check();
char YN_check();
int int_check();
char member_check();
int item_number_check();

//This source file included some code or function obtained from the web.
//Those code or function are "cin.clear()", "cin.fail()" and "cin.ignore()".
//These code or function used in error and invalid cin checking.

struct item_struct_a
{
	int item1a,			//variables for item amount
		item2a,			//small letter stand for temp variables
		item3a,
		item4a,
		item5a,
		item6a,
		item7a;
};

struct item_struct_b
{
	double item1b,		//variables for item cost
		item2b,			//item cost = item amount * item price
		item3b,
		item4b,
		item5b,
		item6b,
		item7b;
};

struct inventory_temp		//Combine structure item_a and item_b
{
	struct item_struct_a item_list_A;
	struct item_struct_b item_list_B;
};

struct inventory			//Final variables used in daily summary
{
	int item1A,
		item2A,
		item3A,
		item4A,
		item5A,
		item6A,
		item7A;
	double item1B,
		item2B,
		item3B,
		item4B,
		item5B,
		item6B,
		item7B;
};

int main()
{
	int option;
	char reply;

	int membership_number=0;
	double	membership_cost=0,
			membership_cost_temp=0;

	double member_discount=0;

	struct inventory_temp inventory_temp;
	struct inventory inventory = {0,0,0,0,0,0,0,0,0,0,0,0,0,0};

	do	{
		option = menu();		//Run function menu() and return option
		switch (option)	
		{
			case 1 :			//Case 1 is option 1 which is "Calculate Membership"
				{
					membership_cost_temp = calc_mem();							//Return value from calc_mem()
					membership_cost = membership_cost + membership_cost_temp;	//Temp value stack up
					++membership_number;										//Number of member increases 1 whenever option 1 choosen
					break;
				}
			case 2 :
				{
					prt_list();													//Print the list of item and pricing
					member_discount = mem_func();								//Return member_discount value
					inventory_temp = fill_inventory(member_discount);			//Giving member_discount to calculate item cost
					inventory = temp_convert(inventory_temp,inventory);			//Temp value stack up
					break;
				}
			case 3 : prt_end(inventory, membership_number,membership_cost);break;	//Print daily summary
			case 4 : break	;													//Break out of the loop without doing anything
		}
		if (option != 4)		//Skip this when option is 4
		{
			cout<<"Do you want to continue? (Y/N)";			//Ask user if he/she wishes to continue
			reply = YN_check();
		}
		else
			break;
	} while (reply == 'Y') ;	//Get out of while loop when reply is "Y"

	prt_end(inventory, membership_number,membership_cost);	//Print daily summary

	system ("pause");
	return 0;
}

int menu()			//Menu Function
{
	int option;
	cout<<"Stay Healty and Fit menu"<<endl
		<<endl
		<<"You may choose 1 of the choices below:"<<endl
		<<"Please only enter 1,2,3 or 4"<<endl
		<<"1. Calculate membership"<<endl
		<<"2. Calculate product purchase"<<endl
		<<"3. Print summary of transactions"<<endl
		<<"4. Exit application"<<endl
		<<endl ;

	option = menu_check();
	
	return option;			//Return option back to main function
}

double mem_func()		//Minor function in option 2 which check member type and return member discount
{
	char member;
	double member_discount;

	cout<<"Are you a member?, Please enter M-member, N-non-member"<<endl;
	member = member_check();
	switch (toupper(member))
	{
	case 'M' : member_discount = 1-0.1;		//item_cost = item_amount * item_price * member_discount
	case 'N' : member_discount = 1;			//member_discount = 0.9 if member, member_discount = 1 if non-member
	}
	return member_discount;
}

double calc_mem()			//Function in option 1 and return the membership cost back to main function
{
	char senior;
	int month,
		session;

	cout<<endl
		<<"Are you a senior citizen (Y/N) ";
	senior = YN_check();
	cout<<endl
		<<"Enter the number of personal training sessions bought ";
	session = int_check();
	cout<<endl
		<<"Enter the number of month you are paying for ";
	month = int_check();

	//Using the same type of calculation as above to simplify condition
	double member_cost;
	double senior_discount,
		twelve_month_discount,
		five_training_discount;
	const int month_fee = 60;
	const int session_fee = 20;

	if (toupper(senior) == 'Y')
		senior_discount = 1-0.3;				//30% discount for senior
	else
		senior_discount = 1;					//else no discount

	if (session > 5)
		five_training_discount = 1-0.20;		//20% discount if more than 5 sessions bought
	else
		five_training_discount = 1;				//else no discount

	if (month >= 12)
		twelve_month_discount = 1-0.15;			//15% discount if more than 12 months paid
	else
		twelve_month_discount = 1;				//else no discount

	member_cost = senior_discount*((month_fee*month*twelve_month_discount)+(session_fee*session*five_training_discount));

	cout<<endl
		<<"Membership cost is RM"<<fixed<<setprecision(2)<<member_cost
		<<endl;

	return member_cost;
}

struct inventory_temp fill_inventory(double member_discount)
//Main function in option 2 which fill temporary inventory
{
	int item_amount,		//Number of item bought, decides looping times
		item_number,		//Item NUMBER (simliar to item code)
		item_temp;			//Temporary storage for buying quantity

	double item_temp2,		//Temporary storage for item cost
		item_price;			//Item price

	char item_name[40];		//Item name for printing purpose

	struct item_struct_a item_a = {0,0,0,0,0,0,0};			//Variables of item amount
	struct item_struct_b item_b = {0,0,0,0,0,0,0};			//Variables of item cost
	struct inventory_temp inventory;						//For structure convert

	cout<<"How many different items to be purchased?"
		<<endl;
	item_amount = int_check();
	for (int i = 1; i <= item_amount ; ++i)			//How many purchase decides looping times
	{
		cout<<endl
			<<"Enter item number ";
		item_number = item_number_check();
		switch (item_number)						//Choosing which item goes to which case
		{
		case 1 :
			{
				strcpy(item_name,"Aviva Female Leggings");
				item_price = 49.90;
				break;
			}
		case 2 :
			{
				strcpy(item_name,"Aviva Female Sleeveless Top");
				item_price = 89.90;
				break;
			}
		case 3 :
			{
				strcpy(item_name,"Reebok Male Sport Fitness T-Shirt");
				item_price = 69.00;
				break;
			}
		case 4 :
			{
				strcpy(item_name,"Nike 2-in-1 Male Shorts");
				item_price = 159.00;
				break;
			}
		case 5 :
			{
				strcpy(item_name,"Cardio Workout CD");
				item_price = 20.00;
				break;
			}
		case 6 :
			{
				strcpy(item_name,"BSN Muscle Stack");
				item_price = 150.00;
				break;
			}
		case 7 :
			{
				strcpy(item_name,"Bodybuilding.com Mass Stack");
				item_price = 200.00;
				break;
			}
		}

		cout<<endl
			<<"Enter quantity for item "<<item_number<<"  ";
		item_temp = int_check();
		item_temp2 = item_temp * item_price * member_discount;
		cout<<endl
			<<endl
			<<"Total for "<<item_temp<<" "<<item_name<<" is RM"<<fixed<<setprecision(2)<<item_temp2
			<<endl;

		switch (item_number)			//Convert temporary variables to temporary inventory variables
		{
		case 1 : item_a.item1a = item_temp; item_b.item1b = item_temp2; break;
		case 2 : item_a.item2a = item_temp; item_b.item2b = item_temp2; break;
		case 3 : item_a.item3a = item_temp; item_b.item3b = item_temp2; break;
		case 4 : item_a.item4a = item_temp; item_b.item4b = item_temp2; break;
		case 5 : item_a.item5a = item_temp; item_b.item5b = item_temp2; break;
		case 6 : item_a.item6a = item_temp; item_b.item6b = item_temp2; break;
		case 7 : item_a.item7a = item_temp; item_b.item7b = item_temp2; break;
		}
		item_temp = 0, item_temp2 = 0;		//Initialize after looping
	}

	inventory.item_list_A = item_a;			//Convert to inventory structure
	inventory.item_list_B = item_b;			//so that return value should be valid

	prt_sum(inventory);

	return inventory;
}

struct inventory temp_convert(struct inventory_temp inventory_temp, struct inventory inventory)
//Function stacking up temporary variables to final variables used in daily summary
{
	inventory.item1A = inventory.item1A + inventory_temp.item_list_A.item1a;
	inventory.item2A = inventory.item2A + inventory_temp.item_list_A.item2a;
	inventory.item3A = inventory.item3A + inventory_temp.item_list_A.item3a;
	inventory.item4A = inventory.item4A + inventory_temp.item_list_A.item4a;
	inventory.item5A = inventory.item5A + inventory_temp.item_list_A.item5a;
	inventory.item6A = inventory.item6A + inventory_temp.item_list_A.item6a;
	inventory.item7A = inventory.item7A + inventory_temp.item_list_A.item7a;

	inventory.item1B = inventory.item1B + inventory_temp.item_list_B.item1b;
	inventory.item2B = inventory.item2B + inventory_temp.item_list_B.item2b;
	inventory.item3B = inventory.item3B + inventory_temp.item_list_B.item3b;
	inventory.item4B = inventory.item4B + inventory_temp.item_list_B.item4b;
	inventory.item5B = inventory.item5B + inventory_temp.item_list_B.item5b;
	inventory.item6B = inventory.item6B + inventory_temp.item_list_B.item6b;
	inventory.item7B = inventory.item7B + inventory_temp.item_list_B.item7b;

	return inventory;
}

void prt_list()			//Simple function printing item list and pricing
{
	cout<<endl
		<<"Item No.     Item Description                     Price per unit"<<endl
		<<"   1         Avida Female Leggings                       RM49.90"<<endl
		<<"   2         Avida Female Sleeveless Top                 RM89.90"<<endl
		<<"   3         Reebok Sport Style Fitness T-Shirt          RM69.00"<<endl
		<<"   4         Nike 2-in-1 Shorts                         RM159.00"<<endl
		<<"   5         Cardio Workout CD                           RM20.00"<<endl
		<<"   6         BSN Muscle Stack                           RM150.00"<<endl
		<<"   7         Bodybuilding.com Mass Stack                RM200.00"<<endl
		<<endl
		<<endl;
}

void prt_sum(struct inventory_temp inventory)			//Print Summary of Current Purchase
{
	double total;
	total = inventory.item_list_B.item1b
			+inventory.item_list_B.item2b
			+inventory.item_list_B.item3b
			+inventory.item_list_B.item4b
			+inventory.item_list_B.item5b
			+inventory.item_list_B.item6b
			+inventory.item_list_B.item7b;
	cout<<endl
		<<endl
		<<"Summary of current purchase"<<endl
		<<"Avida Female Leggings              - Quantity "<<inventory.item_list_A.item1a<<"   RM"<<fixed<<setprecision(2)<<inventory.item_list_B.item1b<<endl
		<<"Avida Female Sleeveless Top        - Quantity "<<inventory.item_list_A.item2a<<"   RM"<<fixed<<setprecision(2)<<inventory.item_list_B.item2b<<endl
		<<"Reebok Sport Style Fitness T-Shirt - Quantity "<<inventory.item_list_A.item3a<<"   RM"<<fixed<<setprecision(2)<<inventory.item_list_B.item3b<<endl
		<<"Nike 2-in-1 Shorts                 - Quantity "<<inventory.item_list_A.item4a<<"   RM"<<fixed<<setprecision(2)<<inventory.item_list_B.item4b<<endl
		<<"Cardio Workout CD                  - Quantity "<<inventory.item_list_A.item5a<<"   RM"<<fixed<<setprecision(2)<<inventory.item_list_B.item5b<<endl
		<<"BSN Muscle Stack                   - Quantity "<<inventory.item_list_A.item6a<<"   RM"<<fixed<<setprecision(2)<<inventory.item_list_B.item6b<<endl
		<<"Bodybuilding.com Mass Stack        - Quantity "<<inventory.item_list_A.item7a<<"   RM"<<fixed<<setprecision(2)<<inventory.item_list_B.item7b<<endl
		<<"TOTAL is                                          RM"<<fixed<<setprecision(2)<<total<<endl
		<<endl;
}

void prt_end(struct inventory inventory, int membership_number, double membership_cost)
//Print Summary of the Day
{
	double total;
	total = membership_cost
			+inventory.item1B
			+inventory.item2B
			+inventory.item3B
			+inventory.item4B
			+inventory.item5B
			+inventory.item6B
			+inventory.item7B;
	cout<<endl
		<<endl
		<<"Summary of the day"<<endl
		<<"Number of New membership                      "<<membership_number<<endl
		<<"Total membership cost                             RM"<<fixed<<setprecision(2)<<membership_cost<<endl
		<<"Product Sale:"<<endl
		<<"Avida Female Leggings              - Quantity "<<inventory.item1A<<"   RM"<<fixed<<setprecision(2)<<inventory.item1B<<endl
		<<"Avida Female Sleeveless Top        - Quantity "<<inventory.item2A<<"   RM"<<fixed<<setprecision(2)<<inventory.item2B<<endl
		<<"Reebok Sport Style Fitness T-Shirt - Quantity "<<inventory.item3A<<"   RM"<<fixed<<setprecision(2)<<inventory.item3B<<endl
		<<"Nike 2-in-1 Shorts                 - Quantity "<<inventory.item4A<<"   RM"<<fixed<<setprecision(2)<<inventory.item4B<<endl
		<<"Cardio Workout CD                  - Quantity "<<inventory.item5A<<"   RM"<<fixed<<setprecision(2)<<inventory.item5B<<endl
		<<"BSN Muscle Stack                   - Quantity "<<inventory.item6A<<"   RM"<<fixed<<setprecision(2)<<inventory.item6B<<endl
		<<"Bodybuilding.com Mass Stack        - Quantity "<<inventory.item7A<<"   RM"<<fixed<<setprecision(2)<<inventory.item7B<<endl
		<<"Grand Total for the day                           RM"<<fixed<<setprecision(2)<<total<<endl;
}

char YN_check()			//Function forces user to type "y" or "n" only
{						//Input checking used in whether user is senior and
	char check;			//whether user wishes to continue
	check='\0';

	do
	{
		cin>>check;
		check = toupper(check);
		if (!isalpha(check))				//Execute when cin is not character
		{
			cout<<"Please only enter character"<<endl;
		}
		else if ((check != 'Y') && (check != 'N'))		//Execute when cin is not "y" or "n"
		{
			cout<<"Please only enter \"Y\" or \"N\""<<endl;
		}
		cin.ignore(CHAR_MAX, '\n');			//Ignore any more than 1 character in cin
											//This is to ensure that cin wont receive multiple value in 1 time
	}	while ((check != 'Y') && (check != 'N'));

	return check;		//Return cin result
}

int menu_check()		//Input checking used in menu() function
{
	double check;		//Stores decimal input so that input validation blocks decimal input
	check=0;			//Otherwise, decimal input will automatically convert to integer
						//and pass through cin checking
	do
	{
		cin>>check;
		if (cin.fail())			//Execute when cin is failed
		{						//cin fails when character is stored in variable int, double, float
			cin.clear();
			cout<<"Please only enter integer"<<endl;
		}
		else if ((check != 1) && (check != 2) && (check != 3) && (check != 4))
		{
			cout<<"Please enter 1,2,3 or 4 only"<<endl;
		}
		cin.ignore(INT_MAX, '\n');		//Ignore more than 1 value in cin

	} 	while ((check != 1) && (check != 2) && (check != 3) && (check != 4));	//Only accept 1,2,3 or 4

	return check;		//Variable convert from double to int doesn't matter
}

int int_check()			//Input checking used in all input required to be integer
{
	double check;
	int check2;
	check=0;

	cin>>check;
	check2 = check;		//Data loss if "check" is a decimal input
	while (cin.fail() || (check != check2))		//"check" not equal to "check2" if check is a decimal input
	{
		cin.clear();
		cin.ignore(INT_MAX, '\n');
		cout<<"Please only enter integer"<<endl;
		cin>>check;
		check2 = check;
	}

	return check;
}

char member_check()		//Function forces user to type "y" or "n" only
{						//Input checking used in option 2
	char check;			//Same as above
	check='\0';

	do
	{
		cin>>check;
		check = toupper(check);
		if (!isalpha(check))
		{
			cout<<"Please only enter character"<<endl;
		}
		else if ((check != 'M') && (check != 'N'))
		{
			cout<<"Please only enter \"M\" or \"N\""<<endl;
		}
		cin.ignore(CHAR_MAX, '\n');

	}	while ((check != 'M') && (check != 'N'));

	return check;
}

int item_number_check()		//Input checking used in fill_inventory() function
{							//Only valid item NUMBER passby this checking
	double check;
	check=0;

	cin>>check;
	while (cin.fail() || ((check != 1) && (check != 2) && (check != 3) && (check != 4) && (check != 5) && (check != 6) && (check != 7)))
	{

		cin.clear();
		cin.ignore(INT_MAX, '\n');
		cout<<"Please enter 1,2,3,4,5,6 or 7 only"<<endl;
		cin>>check;
	} 	

	return check;
}
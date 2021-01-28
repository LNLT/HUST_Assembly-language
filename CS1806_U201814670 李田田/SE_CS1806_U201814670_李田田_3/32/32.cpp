#include <stdio.h>
#include <stdlib.h>
#include <string.h>



typedef struct good          //保存商品信息结构
{
	char name[10];
	short discount;
	short inprice;
	short outprice;
	short innum;
	short outnum;
	short recommendation;
} GA;

extern "C" int C1(char *BNAME,char * BPASS,int AUTH);
extern "C" int C2(GA *GA1 );
extern "C" int C3();
extern "C" int C4(GA *GA1);

int main(int argc, char* argv[])
{
	GA GA1[5];
	char BNAME[10] = "TIANTIAN";
	char BPASS[6] = "TEST";
	char g0[10] = "PEN";
	char g1[10] = "BOOK";
	char g2[10] = "TEMVALUE";
	char g3[10] = "PAPER";
	char g4[10] = "PENCIL";
	int AUTH = 0;
	int N = 10;
	int i;
	int t = 0;
	strcpy_s(GA1[0].name,4, g0);
	GA1[0].discount = 10;
	GA1[0].inprice = 35;
	GA1[0].outprice = 56;
	GA1[0].innum = 70;
	GA1[0].outnum = 25;
	GA1[0].recommendation = 0;

	strcpy_s(GA1[1].name, 5,g1);
	GA1[1].discount = 9;
	GA1[1].inprice = 12;
	GA1[1].outprice = 30;
	GA1[1].innum = 25;
	GA1[1].outnum = 5;
	GA1[1].recommendation = 0;

	strcpy_s(GA1[2].name,9, g2);
	GA1[2].discount = 8;
	GA1[2].inprice = 15;
	GA1[2].outprice = 20;
	GA1[2].innum = 30;
	GA1[2].outnum = 2;
	GA1[2].recommendation = 0;

	strcpy_s(GA1[3].name,6, g3);
	GA1[3].discount = 10;
	GA1[3].inprice = 10;
	GA1[3].outprice = 30;
	GA1[3].innum = 20;
	GA1[3].outnum = 5;
	GA1[3].recommendation = 0;

	strcpy_s(GA1[4].name,7, g4);
	GA1[4].discount = 10;
	GA1[4].inprice = 15;
	GA1[4].outprice = 40;
	GA1[4].innum = 60;
	GA1[4].outnum = 10;
	GA1[4].recommendation = 0;
	while (t != 9)
	{
		printf("HP : ");
		printf("%s\n", BNAME);
		printf("1. Login/Re-Login					2. Find good\n");
		printf("3. Place an order					4. Calculate\n");
		printf("5. Ranking						6. Modify product information\n");
		printf("7. Migrate the store operating environment		8. Display the first address\n");
		printf("9. Exit \n");
		printf("Input your choice(1~9) :\n");
		scanf_s("%d", &t, 1);
		switch (t) {
			case 1:
				C1(BNAME, BPASS, AUTH);
				break;
			case 2:
				C2(GA1);
				break;
			case 3:
				C3();
				break;
			case 4:
				C4(GA1);
				for (i = 0; i < 5; i++) {
					printf("%-10s %2d %2d %2d %2d %2d %3d\n", GA1[i].name, GA1[i].discount, GA1[i].innum, GA1[i].inprice, GA1[i].outnum, GA1[i].outprice, GA1[i].recommendation);
				}
				break;
			case 9:
				break;
		}
	}
	return 0;
}


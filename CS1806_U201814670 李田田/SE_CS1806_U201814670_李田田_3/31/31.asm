NAME  WAN1
EXTRN  PRINT:NEAR, C6:NEAR
PUBLIC  GA1, N, GOOD, AUTH

.386
INCLUDE  MACRO.LIB

STACK 	SEGMENT USE16  STACK
	DB 200 DUP(0)
STACK 	ENDS

DATA	SEGMENT USE16 PARA PUBLIC 'DATA'
	BNAME  	DB  'TIANTIAN',0DH,0
	BPASS    	DB  'TEST',0DH,0
	NAME_A 	DB  'TIANTIAN$'
	AUTH	DB  0
	GOOD	DW  'Q','$'
	N       	EQU  10
	SNAME	DB  'SHOP',0
	GA1	DB  'PEN$',0DH,5 DUP(0),10
		DW  35,56,70,25,?
	GA2	DB  'BOOK$',0DH,4 DUP(0),9
		DW  12,30,25,5,?
	GAN	DB  N-2 DUP('Temvalue$',0DH,8,15,0,20,0,30,0,2,0,?,?)
	IN_NAME		DB  11
			DB  ?
			DB  11 DUP(0)
	IN_PWD		DB  7
			DB  ?
			DB  7 DUP(0)
	IN_GOOD	DB  11
			DB  ?
			DB  11 DUP(0)
	HP		DB  'HP : $'
	GOODNOW	DB  'Good now : $'
	MEUM		DB  '1. Login/Re-Login',0AH
			DB  '2. Find good',0AH
			DB  '3. Place an order',0AH
			DB  '4. Calculate',0AH
			DB  '5. Ranking',0AH
			DB  '6. Modify product information',0AH
			DB  '7. Migrate the store operating environment',0AH
			DB  '8. Display the first address',0AH
			DB  '9. Exit',0AH
			DB  'Input your choice(1~9) : $'
	PROMPTHP	DB  'Input the name : $'
	ERROR		DB  'The name/pass is wrong!$'
	PROMPTPWD	DB  'Input the pass : $'
	PROMPTGOOD	DB  'Input the good : $'
	ERRORGOOD	DB  'Not Exist!$'
	ERRORBUY	DB  'Nothing!$'
	SUCCESS		DB  'Success!$'
	MEUM_A		DW  OFFSET C0
DATA	ENDS

CODE	SEGMENT USE16 PARA PUBLIC 'CODE'
	ASSUME  CS:CODE, SS:STACK, DS:DATA
START:	MOV  AX, DATA
	MOV  DS, AX		
C0:	OUT9 HP	;输出用户名
	OUT9 NAME_A	;输出名字
	CRLF	;回车
	OUT9 GOODNOW	;输出当前商品
	LEA  SI, GOOD
	MOV  SI, [SI]		
	CMP SI, 'Q'
	JNE OUTGOOD
	JE OUTMEUM
OUTGOOD:
	MOV DX,GOOD
	MOV AH,9
	INT 21H		;输出商品名，有问题！
	CRLF	;回车
OUTMEUM:
	OUT9 MEUM	;输出菜单
	CRLF	;回车
	MOV  AX, 0
	MOV  AH, 1	;选择功能
	INT  21H
	CRLF	;回车
	CMP  AL, '1'
	JE G1
	CMP  AL, '2'
	JE G2
	CMP  AL, '3'
	JE G3
	CMP  AL, '4'
	JE G4
	CMP  AL, '5'
	JE C5
	CMP  AL, '6'
	JE G6
	CMP  AL, '7'
	JE C7
	CMP  AL, '8'
	JE C8
	CMP  AL, '9'
	JNE C0
	JE C9
	CRLF	;回车
	
	G1:	CALL  C1
		JMP C0
	G2:	CALL  C2
		JMP C0
	G3:	CALL  C3
		JMP C0
	G4:	CALL  C4
		JMP C0
	G6:	CALL  C6
		JMP C0

C5:	JMP  C0
C7:	JMP  C0
C8:	MOV  BX, CS
	MOV  CX, CS
	MOV  SI, 4
	AND  BH, 0F0H
	SHR  BH, 4

PUT:	CMP  BH, 9
	JE OUT_2
	JS OUT_2
	ADD BH, 7H
	OUT_2:	ADD  BH, 30H
	OUT2 BH
	SHL  CX, 4
	MOV  BX, CX
	AND BH, 0F0H
	SHR  BH, 4
	DEC SI
	CMP SI, 0
	JE EXIT
	JNE PUT
	EXIT:	CRLF		;回车
		JMP C0
C9:	MOV  AH, 4CH
	INT  21H	

C1 PROC
GOHP:	OUT9  PROMPTHP		;用户名提示
	IN10  IN_NAME		;输入用户名
	CRLF			;回车

	LEA  SI, BNAME		;比较用户名
	LEA  DI, IN_NAME+2
	MOV  CX, 10
	CMP  IN_NAME+1, 0
	JE  GOHP			;只有回车
	LOPA1:	MOV  AL, [SI]
		MOV  BL, [DI]
		CMP  AL, BL
		JNE  ERROR1	;输入不正确，跳转
		INC  SI
		INC  DI
		DEC  CX
		JNE  LOPA1	;CX不等于0，跳转

	OUT9  PROMPTPWD	;密码提示
	IN10  IN_PWD		;输入密码
	CRLF		;回车

	LEA  SI, BPASS		;比较密码
	LEA  DI, IN_PWD+2
	MOV  CX, 6
	LOPA2:	MOV  AL, [SI]
		MOV  BL, [DI]
		CMP  AL, BL
		JNE  ERROR1	;输入不正确，跳转
		INC  SI
		INC  DI
		DEC  CX
		JNE  LOPA2	;CX不等于0，跳转
		MOV  AUTH, 1
		RET
	ERROR1:	OUT9 ERROR
		CRLF		;回车
		JMP  GOHP
C1 ENDP

C2  PROC
	OUT9  PROMPTGOOD	;商品名提示
	IN10  IN_GOOD		;输入商品名
	CRLF		;回车

	MOV  BX, 30
	LEA  SI, GA1		;比较商品名
	LEA  DI, IN_GOOD+2
	LBX:	MOV  CX, 10
	LCX:	MOV  AL, [SI]
		MOV  AH, [DI]
		CMP  AL, AH
		JNE  NEXTG	;输入不正确，跳转
		INC  SI
		INC  DI
		DEC  CX
		JNE  LCX		;CX不等于0，跳转
		SUB  SI, 10
		MOV GOOD, SI	;类型要保持一致
		CALL  PRINT
		RET
	NEXTG:	ADD SI, CX
		ADD SI, 11	;偏移地址改变用加，不能MOV SI,[SI+BP+11]
		LEA DI, IN_GOOD+2
		DEC BX;
		CMP  BX, 0
		JE  ERROR2
		JNE  LBX
	ERROR2:	OUT9  ERRORGOOD
		CRLF		;回车
		RET
C2 ENDP

C3 PROC
	LEA  SI, GOOD
	MOV  SI, [SI]		;注意[SI]才是good的数据
	CMP SI, 'Q'
	JE  ERROR3
	MOV  AX, WORD PTR [SI+15]
	MOV  BX,  WORD PTR[SI+17]
	SUB AX, BX
	CMP AX, 0
	JE  ERROR3
	INC BX
	MOV  WORD PTR[SI+17], BX
	CALL C4
	JMP BACK
	ERROR3:	OUT9  ERRORBUY
BACK:	RET
C3 ENDP

C4 PROC
	PUSH	AX
	PUSH	BX
	PUSH	CX
	PUSH	DX
	PUSH	DI
	PUSH	SI
	LEA  DI, GA1
	MOV BP, N
	LCOUNT:
		MOV AX, WORD PTR [DI]+11
		MOV CX, 1280
		IMUL CX
		MOV SI, WORD PTR [DI]+13
	
		MOV BX,0
		MOV BL, BYTE PTR[DI]+10
		IMUL SI, BX
		MOV DX,0		;记得清0
		DIV SI
		MOV SI, AX
		MOV AX, WORD PTR [DI]+17
		MOV CX, 64
		IMUL CX
		MOV DX,0
		DIV WORD PTR [DI]+15
		ADD SI,AX
		MOV WORD PTR [DI]+19, SI
	
		ADD DI, 21
		DEC BP
		CMP BP,0
		JE SUC
		JNE LCOUNT
	SUC:	OUT9  SUCCESS		;成功
		CRLF		;回车
		POP	SI
		POP	DI
		POP	DX
		POP	CX
		POP	BX
		POP	AX
		RET
C4 ENDP

CODE	ENDS
	END  START

.386
STACK 	SEGMENT USE16 STACK
	DB 200 DUP(0)
STACK 	ENDS

DATA	SEGMENT USE16	
	BNAME  	DB  'TIANTIAN',0DH,0
	BPASS    	DB  'TEST',0DH,0
	NAME_A 	DB  'TIANTIAN$'
	AUTH	DB  0
	GOOD	DW  'Q','$'
	N	EQU  30
	M      	DD  300000
	SNAME	DB  'SHOP',0
	GA1	DB  'PEN',0DH,6 DUP(0),10
		DW  35,56,10000,0,?
	GA2	DB  'BOOK',0DH,5 DUP(0),9
		DW  12,30,25,5,?
	GAN	DB  N-2 DUP('Tempvalue',0DH,8,15,0,20,0,30,0,2,0,?,?)
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
	CRLF		DB  0DH,0AH,'$'		;注意要加$结尾
	MEUM_A		DW  OFFSET C0
DATA	ENDS

CODE	SEGMENT USE16
	ASSUME  CS:CODE, SS:STACK, DS:DATA, ES:DATA
MAIN 	PROC
START:	MOV  AX, DATA
	MOV  DS, AX		
C0:	LEA  DX, HP	;输出用户名
	MOV  AH, 9
	INT  21H
	LEA  DX, NAME_A	;输出名字
	MOV  AH, 9
	INT  21H
	LEA  DX, CRLF	;回车
	MOV  AH, 9
	INT  21H
	LEA  DX, GOODNOW	;输出当前商品
	MOV  AH, 9
	INT  21H
	LEA  DX, CRLF	;回车
	MOV  AH, 9
	INT  21H
	LEA  SI, GOOD
	MOV  SI, [SI]		
	CMP SI, 'Q'
	JNE OUTGOOD
	JE OUTMEUM
OUTGOOD:
	LEA  DX, GOOD	;输出商品名，有问题！
	MOV  AH, 9
	INT  21H
	LEA  DX, CRLF	;回车
	MOV  AH, 9
	INT  21H
OUTMEUM:
	LEA  DX, MEUM	;输出菜单
	MOV  AH, 9
	INT  21H
	LEA  DX, CRLF	;回车
	MOV  AH, 9
	INT  21H
	MOV  AH, 1	;选择功能
	INT  21H
	LEA  DX, CRLF	;回车
	MOV  AH, 9
	INT  21H
	CMP  AL, '1'
	JE  C1
	CMP  AL, '2'
	JE  C2
	CMP  AL, '3'
	JE  C3
	CMP  AL, '4'
	JE  C4
	CMP  AL, '5'
	JE  C5
	CMP  AL, '6'
	JE  C6
	CMP  AL, '7'
	JE  C7
	CMP  AL, '8'
	JE  C8
	CMP  AL, '9'
	JE  C9
	JNE C0
	LEA  DX, CRLF	;回车
	MOV  AH, 9
	INT  21H

C1:	LEA  DX, PROMPTHP	;用户名提示
	MOV  AH, 9
	INT  21H
	LEA  DX, IN_NAME		;输入用户名
	MOV  AH, 10
	INT  21H
	LEA  DX, CRLF		;回车
	MOV  AH, 9
	INT  21H

	LEA  SI, BNAME		;比较用户名
	LEA  DI, IN_NAME+2
	MOV  CX, 10
	CMP  IN_NAME+1, 0
	JE  C0			;只有回车，跳回主菜单
	LOPA1:	MOV  AL, [SI]
		MOV  BL, [DI]
		CMP  AL, BL
		JNE  ERROR1	;输入不正确，跳转
		INC  SI
		INC  DI
		DEC  CX
		JNE  LOPA1	;CX不等于0，跳转

	LEA  DX, PROMPTPWD	;密码提示
	MOV  AH, 9
	INT  21H
	LEA  DX, IN_PWD		;输入密码
	MOV  AH, 10
	INT  21H
	LEA  DX, CRLF		;回车
	MOV  AH, 9
	INT  21H

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
		JMP  C0
	ERROR1:	LEA  DX, ERROR
		MOV  AH, 9
		INT  21H
		LEA  DX, CRLF		;回车
		MOV  AH, 9
		INT  21H
		JMP  C1
	
C2:	LEA  DX, PROMPTGOOD	;商品名提示
	MOV  AH, 9
	INT  21H
	LEA  DX, IN_GOOD		;输入商品名
	MOV  AH, 10
	INT  21H
	LEA  DX, CRLF		;回车
	MOV  AH, 9
	INT  21H

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
		JMP  C0
	NEXTG:	ADD SI, CX
		ADD SI, 11	;偏移地址改变用加，不能MOV SI,[SI+BP+11]
		LEA DI, IN_GOOD+2
		DEC BX;
		CMP  BX, 0
		JE  ERROR2
		JNE  LBX
	ERROR2:	LEA  DX, ERRORGOOD
		MOV  AH, 9
		INT  21H
		LEA  DX, CRLF		;回车
		MOV  AH, 9
		INT  21H
		JMP  C0
C3:	MOV  AX, 0
	CALL  TIMER
C3_1:	LEA  SI, GOOD
	MOV  SI, [SI]		;注意[SI]才是good的数据
	CMP SI, 'Q'
	JE  ERROR3
	MOV  AX, WORD PTR [SI+15]
	MOV  BX,  WORD PTR[SI+17]
	SUB AX, BX
	CMP AX, 0
	JE  ERROR3
	;INC BX
	MOV  WORD PTR[SI+17], BX
	JMP C4
	ERROR3:	LEA  DX, ERRORBUY
		MOV  AH, 9
		INT  21H
		LEA  DX, CRLF		;回车
		MOV  AH, 9
		INT  21H
		JMP  C0
C4:	LEA  DI, GA1
	MOV BP, 30
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
	SUC:	DEC  M
		CMP  M, 0
		JNE  C3_1
		MOV  AX, 1
		CALL  TIMER
		JMP ERROR3
C5:	JMP  C0
C6:	JMP  C0
C7:	JMP  C0
C8:	MOV  BX, CS
	MOV  CX, CS
	MOV  SI, 4
	AND  BH, 0F0H
	SHR  BH, 4

PUT:	CMP  BH, 9
	JE OUT2
	JS OUT2
	ADD BH, 7H
	OUT2:	ADD  BH, 30H
	MOV  DL, BH
	MOV  AH, 2
	INT  21H
	SHL  CX, 4
	MOV  BX, CX
	AND BH, 0F0H
	SHR  BH, 4
	DEC SI
	CMP SI, 0
	JE EXIT
	JNE PUT
	EXIT:	LEA  DX, CRLF		;回车
		MOV  AH, 9
		INT  21H
		JMP C0
C9:	MOV  AH, 4CH
	INT  21H	
MAIN	ENDP

TIMER	PROC
	PUSH  DX
	PUSH  CX
	PUSH  BX
	MOV   BX, AX
	MOV   AH, 2CH
	INT   21H	     ;CH=hour(0-23),CL=minute(0-59),DH=second(0-59),DL=centisecond(0-100)
	MOV   AL, DH
	MOV   AH, 0
	IMUL  AX,AX,1000
	MOV   DH, 0
	IMUL  DX,DX,10
	ADD   AX, DX
	CMP   BX, 0
	JNZ   _T1
	MOV   CS:_TS, AX
_T0:	POP   BX
	POP   CX
	POP   DX
	RET
_T1:	SUB   AX, CS:_TS
	JNC   _T2
	ADD   AX, 60000
_T2:	MOV   CX, 0
	MOV   BX, 10
_T3:	MOV   DX, 0
	DIV   BX
	PUSH  DX
	INC   CX
	CMP   AX, 0
	JNZ   _T3
	MOV   BX, 0
_T4:	POP   AX
	ADD   AL, '0'
	MOV   CS:_TMSG[BX], AL
	INC   BX
	LOOP  _T4
	PUSH  DS
	MOV   CS:_TMSG[BX+0], 0AH
	MOV   CS:_TMSG[BX+1], 0DH
	MOV   CS:_TMSG[BX+2], '$'
	LEA   DX, _TS+2
	PUSH  CS
	POP   DS
	MOV   AH, 9
	INT   21H
	POP   DS
	JMP   _T0
_TS	DW    ?
 	DB    'Time elapsed in ms is '
_TMSG	DB    12 DUP(0)
TIMER    	ENDP

CODE	ENDS
	END  START

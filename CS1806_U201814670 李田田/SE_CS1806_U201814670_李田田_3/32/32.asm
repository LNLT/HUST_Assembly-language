.386
;.MODEL FLAT, STDCALL
.model flat, c
public C1, C2, C3, C4
INCLUDELIB kernel32.lib
INCLUDELIB ucrt.lib
INCLUDELIB legacy_stdio_definitions.lib
INCLUDE  F:\asm\MACRO.LIB
printf    PROTO C : dword,:vararg;对printf函数声明.
scanf    PROTO C : dword,:vararg;对scanf函数声明.


.STACK

.DATA
	INNAME	DB  11
			DB  ?
			DB  11 DUP(0)
	INPASS	DB  7
			DB  ?
			DB  7 DUP(0)
	IN_GOOD	DB  11
			DB  ?
			DB  11 DUP(0)
	NUM     DB 4,5,9,6,7
	GOD		DD ?
	GOD1	DD ?
	GOOD	DD 0
	format byte '%s',0;用于printf函数格式化输出.
	msg1 byte 'Input the name :',10,0;用于printf函数直接输出.
	msg2 byte 'Input the pass :',10,0;用于printf格式化输出.
	ERROR		byte  'The name/pass is wrong!',10,0
	PROMPTPWD	byte  'Input the pass : ',10,0
	PROMPTGOOD	byte  'Input the good : ',10,0
	ERRORGOOD	byte  'Not Exist!',10,0
	ERRORBUY	byte  'Nothing!',10,0
	SUCCESS		byte  'Success!',10,0
	format2		byte '%s',0;用于scanf函数格式化输入.

.CODE	
C1 	PROC BNAME:DWORD,BPASS:DWORD,AUTH:DWORD
GOHP:
	invoke printf,offset msg1
	invoke scanf,offset format2,offset INNAME+2
	MOV  ESI, BNAME		;比较用户名
	LEA  EDI, INNAME+2
	MOV  CX, 10
LOPA1:	
	MOV  AL, [ESI]
	MOV  BL, [EDI]
	CMP  AL, BL
	JNE  ERROR1	;输入不正确，跳转
	INC  ESI
	INC  EDI
	DEC  CX
	JNE  LOPA1	;CX不等于0，跳转

	invoke printf,offset msg2
	invoke scanf,offset format2,offset INPASS+2

	MOV  ESI, BPASS		;比较密码
	LEA  EDI, INPASS+2
	MOV  CX, 6
LOPA2:	
	MOV  AL, [ESI]
	MOV  BL, [EDI]
	CMP  AL, BL
	JNE  ERROR1	;输入不正确，跳转
	INC  ESI
	INC  EDI
	DEC  CX
	JNE  LOPA2	;CX不等于0，跳转
	MOV  AUTH, 1
	RET
ERROR1:	
	invoke printf,offset ERROR
	JMP  GOHP

C1 ENDP

C2  PROC	GA1:DWORD
	invoke printf,offset PROMPTGOOD
	invoke scanf,offset format2,offset IN_GOOD+2

	MOV  EBX, 0
	MOV  ESI, GA1		;比较商品名
	MOV	 GOD1,ESI
	LEA  EDI, IN_GOOD+2
LBX:MOV  EAX,0
	LEA  EAX,NUM
	MOV  ECX,0
	MOV  CX, [EAX+EBX]
	MOV	 GOD, ESI
LCX:	
	MOV  AL, [ESI]
	MOV  AH, [EDI]
	CMP  AL, AH
	JNE  NEXTG	;输入不正确，跳转
	INC  ESI
	INC  EDI
	DEC  CL
	JNE  LCX		;CX不等于0，跳转
	MOV EAX,GOD
	MOV GOOD, EAX	;类型要保持一致
	RET
NEXTG:	
	ADD	GOD1,22
	MOV ESI, GOD1	;偏移地址改变用加，不能MOV SI,[SI+BP+11]
	LEA EDI, IN_GOOD+2
	INC BX;
	CMP BX, 5
	JE  ERROR2
	JNE  LBX
ERROR2:
	invoke printf,offset ERRORGOOD
	RET
C2 	ENDP

C3 	PROC 
	MOV  ESI, GOOD
	CMP ESI, 0
	JE  ERROR3
	MOV  AX, [ESI+16]
	MOV  BX, [ESI+18]
	SUB AX, BX
	CMP AX, 0
	JE  ERROR3
	INC BX
	MOV [ESI+18], BX
	JMP BACK
ERROR3:	
	invoke printf,offset ERRORBUY
BACK:	
	RET
C3 	ENDP

C4 	PROC GA1:DWORD
	PUSHA
	MOV  EDI, GA1
	MOV BP, 5
	LCOUNT:
		MOV AX,[EDI+12]
		MOV CX, 1280
		IMUL CX
		MOV SI, [EDI+14]
	
		MOV BX,0
		MOV BL,[EDI+10]
		IMUL SI, BX
		MOV DX,0		;记得清0
		DIV SI
		MOV SI, AX
		MOV AX, [EDI+18]
		MOV CX, 64
		IMUL CX
		MOV DX,0
		DIV WORD PTR [EDI+16]
		ADD SI,AX
		MOV WORD PTR [EDI+20], SI
	
		ADD EDI, 22
		DEC BP
		CMP BP,0
		JE SUC
		JNE LCOUNT
	SUC:invoke printf,offset SUCCESS		;成功
		POPA
		RET
C4 	ENDP

	END

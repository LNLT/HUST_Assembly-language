.386
.MODEL FLAT,STDCALL
OPTION CASEMAP:NONE
INCLUDE F:\vs\masm32\INCLUDE\windows.inc
INCLUDE F:\vs\masm32\INCLUDE\GDI32.inc
INCLUDE F:\vs\masm32\INCLUDE\user32.inc
INCLUDE F:\vs\masm32\INCLUDE\kernel32.inc
INCLUDELIB GDI32.lib
INCLUDELIB user32.lib
INCLUDELIB kernel32.lib
GOOD	STRUCT
	GNAME		DB	10 DUP(0)
	DISCOUNT	DB	0
	INMONEY		DW	0
	OUTMONEY	DW	0
	IN_NUM		DW	0
	OUT_NUM		DW	0
	RECOMMENDATION	DW	0
GOOD	ENDS

WinMain		PROTO :DWORD, :DWORD, :DWORD, :DWORD
WinProc		PROTO :DWORD, :DWORD, :DWORD, :DWORD
REM			PROTO :WORD
LIST		PROTO :DWORD

.STACK

.DATA
	ClassName	DB	"SimpleWinClass", 0
	AppName		DB	"Our First Window", 0
	MenuName	DB	"MyMenu", 0
	AboutMsg	DB	"I AM CS1806 LTT",0
	hInstance	DD   0
	CommandLine	DD   0
	
	SHOP	GOOD	<'PEN',10,35,56,75,25,'0'>
			GOOD	<'BOOK',9,12,30,25,5,'0'>
			GOOD	<'Temvalue',8,15,20,30,2,'0'>
			GOOD	<'Paper',8,2,4,50,25,'0'>
			GOOD	<'Ruler',9,3,5,70,20,'0'>
	goodname		DB		'GoodName',0
	discount		DB		'Discount',0
	inprice			DB		'InPrice',0
	outprice		DB		'OutPrice',0
	innum			DB		'InNum',0
	outnum			DB		'OutNum',0
	recommendation	DB		'Recommendation',0
	Discount		DB		2,1,1,1,1, '10','9','8','8','9'
	Inprice			DB		2,2,2,1,1, '35','12','15','2','3'
	Outprice		DB		2,2,2,1,1, '56','30','20','4','5'
	Innum			DB		2,2,2,2,2, '75','25','30','50','70'
	Outnum			DB		2,1,1,2,2, '25','5','2','25','20'
	R1		DB	10 DUP(0)
	strlength DB ?
	MAX				DB		1,2,3,4,5
	MID				DB		5 DUP(0)
	NUM				EQU		1

.CONST
	IDM_DISP EQU 1
	IDM_MAX EQU 2
	IDM_MIN	EQU 3
	IDM_AVG	EQU 4
	IDM_EXIT EQU 5
	MyMenu EQU 600
		
.CODE
START:
    INVOKE  GetModuleHandle, NULL     ;获得并保存本程序的句柄
    MOV		hInstance,EAX
    INVOKE  GetCommandLine
    MOV		CommandLine,EAX
    INVOKE  WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT
    INVOKE  ExitProcess,EAX
    
WinMain PROC hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
	LOCAL  wc:WNDCLASSEX     ;创建主窗口时所需要的信息由该结构说明
	LOCAL  msg:MSG                    ;消息结构变量用于存放获取的消息
	LOCAL  hwnd:HWND               ;存放窗口句柄，给WNDCLASSEX结构变量wc的各字段赋值
	MOV    wc.cbSize,SIZEOF WNDCLASSEX                   ;WNDCLASSE结构类型的字节数
	MOV    wc.style, CS_HREDRAW or CS_VREDRAW    ;窗口风格(当窗口高度和宽度变  
                                                                                      ;化时则重画窗口)
	MOV    wc.lpfnWndProc, OFFSET WndProc    ;本窗口过程的入口地址（偏移地址）
	MOV    wc.cbClsExtra,NULL                             ;不使用自定义数据则不需OS预留空间，
	MOV    wc.cbWndExtra,NULL                          ;同上
	PUSH   hInst                                                     ;本应用程序句柄→wc.hInstance
	POP    wc.hInstance
	MOV    wc.hbrBackground,COLOR_WINDOW+1  ;窗口的背景颜色为白色
	MOV    wc.lpszMenuName,NULL                             ;窗口上不带菜单，置为NULL
	MOV    wc.lpszClassName,OFFSET ClassName       ;窗口类名"TryWinClass"的地址
	INVOKE LoadIcon,NULL,IDI_APPLICATION          ;装入系统默认的图标
	MOV    wc.hIcon,EAX                                                ;保存图标的句柄
 	MOV    wc.hIconSm,0                                              ;窗口不带小图标
	INVOKE LoadCursor,NULL,IDC_ARROW        ;装入系统默认的光标
 	MOV    wc.hCursor,EAX   
	INVOKE   RegisterClassEx, ADDR wc 			;注册窗口类 
	INVOKE CreateWindowEx, NULL, ADDR ClassName, ;建立TryWinClass类窗口  
                ADDR AppName, 					;窗口标题"Our First Window"的地址
                WS_OVERLAPPEDWINDOW+ WS_VISIBLE,	;创建可显示的窗口
                CW_USEDEFAULT,CW_USEDEFAULT,	;窗口左上角坐标默认值
                CW_USEDEFAULT,CW_USEDEFAULT,	;窗口宽度，高度默认值
                NULL,NULL, 						;无父窗口，无菜单
                hInst,NULL 						;本程序句柄，无参数传递给窗口
    MOV    hwnd,EAX  ;保存窗口的句柄
    invoke	LoadMenu, hInst, MyMenu
    invoke	SetMenu, hwnd, eax
StartLoop:                                     ;进入消息循环
    INVOKE GetMessage, ADDR msg,NULL,0,0      ;从Windows获取消息
    CMP EAX, 0                             ;如果（EAX）不为0 则要转换并分发消息
    JE     ExitLoop                             ;如果（EAX）为0 则转ExitLoop
    INVOKE TranslateMessage, ADDR msg     ;从键盘接受按键并转换为消息
    INVOKE DispatchMessage, ADDR msg       ;将消息分发到窗口的消息处理程序a
   	JMP StartLoop                          ;再循环获取消息
ExitLoop:
   	MOV     EAX,msg.wParam           ;设置返回（退出）码
   	RET
WinMain ENDP    

WndProc	PROC  hWnd: HWND, uMsg: UINT, wParam: WPARAM, lParam: LPARAM
	LOCAL hdc :HDC
	LOCAL nX :DWORD
	LOCAL nY :DWORD
	LOCAL nCount :DWORD
	.IF uMsg == WM_DESTROY
		INVOKE PostQuitMessage, NULL
	.ELSEIF uMsg == WM_COMMAND
		.IF wParam == 1
			INVOKE SendMessage, hWnd, WM_CLOSE, 0,0
		.ELSEIF wParam == 2
			INVOKE REM,5
		.ELSEIF wParam == 3
			invoke GetDC,hWnd
			MOV	hdc,eax
			INVOKE LIST,hdc
		.ELSEIF wParam == 4
			INVOKE MessageBox, hWnd, ADDR AboutMsg, OFFSET AppName, 0
		.ENDIF
	.ELSE
		INVOKE DefWindowProc, hWnd, uMsg, wParam, lParam
		RET
	.ENDIF
	MOV EAX, 0
	RET
WndProc ENDP

REM		PROC GOODNUM :WORD
			PUSHAD
			LEA  EDI, SHOP
			MOV BP, GOODNUM
		LCOUNT:
			MOV AX, DS:[EDI+11]
			MOV CX, 1280
			IMUL CX
			MOV SI,DS: [EDI+13]
	
			MOV BX,0
			MOV BL, DS:[EDI+10]
			IMUL SI, BX
			MOV DX,0		;记得清0
			DIV SI
			MOV SI, AX
			MOV AX, DS:[EDI+17]
			MOV CX, 64
			IMUL CX
			MOV DX,0
			DIV WORD PTR DS:[EDI+15]
			ADD SI,AX
			MOV DS: [EDI+19], SI
			
			
	
			ADD DI, 21
			DEC BP
			CMP BP,0
			JE SUC
			JNE LCOUNT
	SUC:	POPAD
			RET
REM		ENDP

F2T10 PROC             ;入口参数为要输出的数字保存在EAX中，功能将转化后的数据保存到特地址
	PUSH ESI
	PUSH ECX
	PUSH EBX
	PUSH EDX
	XOR ECX,ECX          ;计数器清零
	MOV EBX,10         ;基数
F2T1:
	XOR EDX,EDX
	DIV EBX
	PUSH DX
	INC CX
	OR EAX,EAX
	JNZ F2T1
	
	LEA ESI,R1
	MOV strlength,CL       ;保存串长度
	MOV EDX,0
F2T3:
	POP BX
	ADD BX,30H
	MOV BYTE PTR [ESI+EDX],BL  ;将转换后的ASCII码保存到地址中
	INC EDX
	LOOP F2T3
	POP EDX
	POP EBX
	POP ECX
	POP ESI
	RET
F2T10 ENDP

LIST		PROC hdc :HDC
			PUSHAD
			 X  equ  10
             Y  equ  10
			 XX	 equ  100
			 YY	 equ  30
             INVOKE TextOut,hdc,X+0*XX,Y,offset goodname,8
             INVOKE TextOut,hdc,X+1*XX,Y,offset discount,8
             INVOKE TextOut,hdc,X+2*XX,Y,offset inprice,7
             INVOKE TextOut,hdc,X+3*XX,Y,offset outprice,8
             INVOKE TextOut,hdc,X+4*XX,Y,offset innum,5
             INVOKE TextOut,hdc,X+5*XX,Y,offset outnum,6
             INVOKE TextOut,hdc,X+6*XX,Y,offset recommendation,14
             
			 MOV AX,SHOP[0*21].RECOMMENDATION
			 MOV MID,AL
			 MOV AX,SHOP[1*21].RECOMMENDATION
			 MOV MID+1,AL
			 MOV AX,SHOP[2*21].RECOMMENDATION
			 MOV MID+2,AL
			 MOV AX,SHOP[3*21].RECOMMENDATION
			 MOV MID+3,AL
			 MOV AX,SHOP[4*21].RECOMMENDATION
			 MOV MID+4,AL

			 MOV ECX,5
			 LEA EBX,MID
			 LEA EDX,MAX
			 MOV ESI,0
			 MOV EDI,0
 
		LP1: 
			 PUSH ECX
			 MOV ECX,4             ;比较次数
			 SUB ECX,ESI                      
			 MOV EDI,0  
		LP2:  
			 MOV AL,[EBX+EDI]
			 MOV AH,[EBX+EDI+1]
			 CMP AL,AH
			 JB  CHANGE                 ;无符号数比较
		EXIT1:
			 INC EDI
			 LOOP LP2
			 POP ECX
			 LOOP LP1
 
			 JMP LAST
		CHANGE: 
			 MOV AL,[EBX+EDI+1]
			 MOV AH,[EBX+EDI]
			 MOV [EBX+EDI+1],AH
			 MOV [EBX+EDI],AL
			 MOV AL,[EDX+EDI+1]
			 MOV AH,[EDX+EDI]
			 MOV [EDX+EDI+1],AH
			 MOV [EDX+EDI],AL
			 JMP EXIT1

	LAST:	MOV EDI,0
			LEA ECX,MAX
	FIRST:	CMP EDI,5
			JE  EXIT
			MOV BL,[ECX+EDI]
			PUSH ECX
			CMP BL,1
			JE NUM1
			CMP BL,2
			JE NUM2
			CMP BL,3
			JE NUM3
			CMP BL,4
			JE NUM4
			CMP BL,5
			JE NUM5
	
			
    NUM1:    INVOKE TextOut,hdc,X+0*XX,Y+4*YY,offset SHOP[0].GNAME,3
		     INVOKE TextOut,hdc,X+1*XX,Y+4*YY,offset Discount+5,Discount
             INVOKE TextOut,hdc,X+2*XX,Y+4*YY,offset Inprice+5,Inprice
             INVOKE TextOut,hdc,X+3*XX,Y+4*YY,offset Outprice+5,Outprice
             INVOKE TextOut,hdc,X+4*XX,Y+4*YY,offset Innum+5,Innum
             INVOKE TextOut,hdc,X+5*XX,Y+4*YY,offset Outnum+5,Outnum
			 MOV AX,SHOP[0].RECOMMENDATION
			 CALL F2T10
             INVOKE TextOut,hdc,X+6*XX,Y+4*YY,offset R1,strlength
			 INC EDI
			 POP ECX
			 JMP FIRST
             
	NUM2:	 INVOKE TextOut,hdc,X+0*XX,Y+5*YY,offset SHOP[1*21].GNAME,4
             INVOKE TextOut,hdc,X+1*XX,Y+5*YY,offset Discount+7,Discount+1
             INVOKE TextOut,hdc,X+2*XX,Y+5*YY,offset Inprice+7,Inprice+1
             INVOKE TextOut,hdc,X+3*XX,Y+5*YY,offset Outprice+7,Outprice+1
             INVOKE TextOut,hdc,X+4*XX,Y+5*YY,offset Innum+7,Innum+1
             INVOKE TextOut,hdc,X+5*XX,Y+5*YY,offset Outnum+7,Outnum+1
			 MOV AX,SHOP[1*21].RECOMMENDATION
			 CALL F2T10
             INVOKE TextOut,hdc,X+6*XX,Y+5*YY,offset R1,strlength
			 INC EDI
			 POP ECX
			 JMP FIRST
             
    NUM3:    INVOKE TextOut,hdc,X+0*XX,Y+1*YY,offset SHOP[2*21].GNAME,8
             INVOKE TextOut,hdc,X+1*XX,Y+1*YY,offset Discount+8,Discount+2
             INVOKE TextOut,hdc,X+2*XX,Y+1*YY,offset Inprice+9,Inprice+2
             INVOKE TextOut,hdc,X+3*XX,Y+1*YY,offset Outprice+9,Outprice+2
             INVOKE TextOut,hdc,X+4*XX,Y+1*YY,offset Innum+9,Innum+2
             INVOKE TextOut,hdc,X+5*XX,Y+1*YY,offset Outnum+8,Outnum+2
			 MOV AX,SHOP[2*21].RECOMMENDATION
			 CALL F2T10
             INVOKE TextOut,hdc,X+6*XX,Y+1*YY,offset R1,strlength
			 INC EDI
			 POP ECX
			 JMP FIRST
             
      NUM4:  INVOKE TextOut,hdc,X+0*XX,Y+2*YY,offset SHOP[3*21].GNAME,5
             INVOKE TextOut,hdc,X+1*XX,Y+2*YY,offset Discount+9,Discount+3
             INVOKE TextOut,hdc,X+2*XX,Y+2*YY,offset Inprice+10,Inprice+3
             INVOKE TextOut,hdc,X+3*XX,Y+2*YY,offset Outprice+10,Outprice+3
             INVOKE TextOut,hdc,X+4*XX,Y+2*YY,offset Innum+11,Innum+3
             INVOKE TextOut,hdc,X+5*XX,Y+2*YY,offset Outnum+9,Outnum+3
			 MOV AX,SHOP[3*21].RECOMMENDATION
			 CALL F2T10
             INVOKE TextOut,hdc,X+6*XX,Y+2*YY,offset R1,strlength
			 INC EDI
			 POP ECX
			 JMP FIRST
             
      NUM5:  INVOKE TextOut,hdc,X+0*XX,Y+3*YY,offset SHOP[4*21].GNAME,4
             INVOKE TextOut,hdc,X+1*XX,Y+3*YY,offset Discount+10,Discount+4
             INVOKE TextOut,hdc,X+2*XX,Y+3*YY,offset Inprice+11,Inprice+4
             INVOKE TextOut,hdc,X+3*XX,Y+3*YY,offset Outprice+11,Outprice+4
             INVOKE TextOut,hdc,X+4*XX,Y+3*YY,offset Innum+13,Innum+4
             INVOKE TextOut,hdc,X+5*XX,Y+3*YY,offset Outnum+11,	Outnum+4
			 MOV AX,SHOP[4*21].RECOMMENDATION
			 CALL F2T10
             INVOKE TextOut,hdc,X+6*XX,Y+3*YY,offset R1,strlength
			 INC EDI
			 POP ECX
			 JMP FIRST

	EXIT:	POPAD
			RET
LIST		ENDP
		
END START
.386
STACK   SEGMENT  USE16 STACK
        DB  200 DUP(0)
STACK   ENDS
DATA    SEGMENT USE16
BUF1    DB 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
BUF2    DB 10 DUP(0)
BUF3    DB 10 DUP(0)
BUF4    DB 10 DUP(0)
DATA    ENDS
CODE    SEGMENT USE16
        ASSUME CS: CODE, DS: DATA, SS: STACK
START:  MOV AX, DATA    ;这两句完成将数据段首址DATA置入数据段寄存器DS中
        MOV DS, AX
        MOV SI, OFFSET BUF1     ;OFFSET为取偏移地址算符
        MOV DI, OFFSET BUF2     ;此四句为取BUF1……BUF4的偏移地址送入寄存器之中
        MOV BX, OFFSET BUF3
        MOV BP, OFFSET BUF4
        MOV CX, 10      ;将立即数10送入CX寄存器中，作接下来作循环操作时的计数量，起到类似于高级语言（例如C语言）中for循环中i的作用
LOPA:   MOV AL, [SI]    ;此句用了寄存器间接寻址的方法，将SI中所存地址对应的内存中的数据送入寄存器AL之中
        MOV [DI], AL    ;此句将AL之中的数据，送入DI对应的的偏移地址的内存单元中
        INC AL          ;AL自增
        MOV [BX], AL    ;将自增后的AL中存储的数送入送入BX对应的的偏移地址的内存单元中
        ADD AL, 3       ;将AL中的数据再加上3，然后存储在AL中
        MOV DS:[BP], AL ;将AL中存储的数送入BP对应的的偏移地址的内存单元中
        INC SI          ;此四句将SI、DI、BP、CX分别自增，指向各自其后面的一个内存存储单元
        INC DI
        INC BP
        INC BX
        DEC CX          ;对CX自减
        JNZ LOPA        ;当CX不等于零时跳转到LOPA标号对应的地方继续执行指令
        MOV AH, 4CH     ;此两句为DOS功能调用指令，执行完该指令以后，计算机将结束本程序的运行，返回DOS状态
        INT 21H
CODE    ENDS
        END START
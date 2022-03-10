M8251_DATA  EQU 0600H           ;端口定义
M8251_CON       EQU 0602H
M8254_2     EQU 06C4H
M8254_CON       EQU 06C6H
SSTACK  SEGMENT STACK
        DW 64 DUP(?)
SSTACK  ENDS
CODE        SEGMENT
        ASSUME CS:CODE
START:  MOV AX, 0000H
        MOV DS, AX
    ;初始化8254，得到收发时钟
        MOV AL, 0B6H
        MOV DX, M8254_CON
        OUT DX, AL
        MOV AL, 0CH
        MOV DX, M8254_2
        OUT DX, AL
        MOV AL, 00H
        OUT DX, AL
    ;复位8251
        CALL INIT
        CALL DALLY
    ;8251方式字
        MOV AL,7EH
        MOV DX, M8251_CON                      
        OUT DX, AL
        CALL DALLY
    ;8251控制字              
        MOV AL, 34H
        OUT DX, AL
        CALL DALLY
        MOV DI, 3020H
        MOV SI, 3000H
        MOV CX, 000AH
A1:     MOV AL, [SI]
        PUSH AX
        MOV AL, 37H
        MOV DX, M8251_CON
        OUT DX, AL 
        POP AX                      
        MOV DX, M8251_DATA
        OUT DX, AL              ;发送数据
        MOV DX, M8251_CON 
A2:     IN AL, DX                   ;判断发送缓冲是否为空
        AND AL, 01H
        JZ A2
        CALL DALLY
A3:     IN AL, DX                   ;判断是否接收到数据
        AND AL, 02H
        JZ A3
        MOV DX, M8251_DATA
        IN AL, DX                   ;读取接收到的数据
        MOV [DI], AL
        INC DI
        INC SI
        LOOP A1
        MOV AX,4C00H
        INT 21H                 ;程序终止
INIT:   MOV AL, 00H             ;复位8251子程序
        MOV DX, M8251_CON
        OUT DX, AL
        CALL DALLY
        OUT DX, AL
        CALL DALLY
        OUT DX, AL
        CALL DALLY
        MOV AL, 40H
        OUT DX, AL
        RET
DALLY:  PUSH CX
        MOV CX,3000H
A5:     PUSH AX
        POP AX
        LOOP A5
        POP CX
        RET     
CODE        ENDS
        END START








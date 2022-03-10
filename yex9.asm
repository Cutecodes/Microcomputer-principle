SSTACK	SEGMENT STACK
		DW 32 DUP(?)
SSTACK	ENDS
CODE   	SEGMENT
	   	ASSUME CS:CODE
START: 	PUSH DS
		MOV AX, 0000H
		MOV DS, AX
		MOV AX, OFFSET MIR7		;取中断入口地址
		MOV SI, 003CH				;中断矢量地址
		MOV [SI], AX				;填IRQ7的偏移矢量
		MOV AX, CS				;段地址
		MOV SI, 003EH
		MOV [SI], AX				;填IRQ7的段地址矢量
		CLI
		POP DS
		;初始化主片8259
		MOV AL, 11H
		OUT 20H, AL				;ICW1
		MOV AL, 08H
		OUT 21H, AL				;ICW2
		MOV AL, 04H
		OUT 21H, AL				;ICW3
		MOV AL, 01H
		OUT 21H, AL				;ICW4
		MOV AL, 6FH				;OCW1
		OUT 21H, AL
		STI

        MOV DX,0646H            ;流水灯
        MOV AL,80H 	;OUTPUT
        OUT DX,AL
        MOV BL,10000000B
        MOV BH,00000001B
      L:
        MOV DX,0640H ;A
        MOV AL,BL
        OUT DX,AL

        MOV DX,0642H ;B
        MOV AL,BH
        OUT DX,AL
                        
        CALL DELAY

        ROR BL,1
        ROL BH,1
        JMP L

MIR7:	STI
		CALL DELAY

		MOV AL,11111111B
		MOV DX,0640H
		OUT DX,AL

		MOV DX,0640H
		OUT DX,AL

		MOV AL, 20H
		OUT 20H, AL				;中断结束命令
		IRET		
DELAY:	PUSH CX
		MOV CX, 0F00H
AA0:		PUSH AX
		POP  AX
		LOOP AA0
		POP CX
		RET		
CODE		ENDS
		END  START

STACKS  SEGMENT   STACK
        DB        128 DUP(?)
STACKS  ENDS
DATE SEGMENT
        TABLE DB 40H,79H,24H,30H,19H,12H,02H,78H
              DB 00H,18H,80H,03H,43H,21H,06H,0EH
DATE ENDS       
;
CODES  SEGMENT
        ASSUME    CS:CODES,SS:STACKS,DS:DATA
                

        MAIN:
                        MOV AX,DATA
                        MOV DS,AX

                	MOV DX,0646H
                	MOV AL,80H 	;OUTPUT
                	OUT DX,AL
                	MOV BL,01111111B
                	;MOV BH,00000001B
                        MOV SI,0

                L:
                	MOV DX,0640H ;A
                	MOV AL,BL
                        OUT DX,AL

                        MOV DX,0642H ;B
                        MOV AL,TABLE[SI]
                        OUT DX,AL
                        INC SI
                        CMP SI,8
                        JNZ T
                        SUB SI,8
                T:
                        CALL DELAY

                        ROR BL,1
                        ;ROL BH,1

                        JMP L

DELAY:  PUSH CX
                MOV CX, 0F00H
AA0:            PUSH AX
                POP  AX
                LOOP AA0
                POP CX
                RET
                		
                        MOV AX,4C00H
                        INT 21H
                
                ;
        CODES  ENDS
                END MAIN 
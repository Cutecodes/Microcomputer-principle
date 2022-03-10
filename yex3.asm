        STACKS  SEGMENT   STACK
                DB        128 DUP(?)
        STACKS  ENDS        
        ;
        CODES  SEGMENT
                ASSUME    CS:CODES,SS:STACKS                
                MAIN:
                	MOV DX,0646H
                	MOV AL,80H 	;OUTPUT
                	OUT DX,AL
                	MOV BL,11100000B
                	MOV BH,00000011B

                L:
                	MOV DX,0640H ;A
                	MOV AL,BL
                        OUT DX,AL

                        MOV DX,0642H ;B
                        MOV AL,BH
                        OUT DX,AL
                        
                        MOV CX,10000
                SLEEP:
                        NOP
                        LOOP SLEEP
                        ROR BL,1
                        ROL BH,1
                        JMP L                		
                        MOV AX,4C00H
                        INT 21H                
                ;
        CODES  ENDS
                END MAIN 








        STACKS  SEGMENT   STACK
                DB        128 DUP(?)
        STACKS  ENDS
        DATAS  SEGMENT

                CON8254 EQN 0606H
                A8254 EQN 0600H
                B8254 EQN 0602H
                C8254 EQN 0604H
        DATAS  ENDS
        ;
        CODES  SEGMENT
                ASSUME    CS:CODES,SS:STACKS,DS:DATAS
                
                MAIN:
                    MOV AX,STACKS
                    MOV SS,AX
                    MOV AX,DATAS
                    MOV DS,AX

                    MOV DX,CON8254
                    MOV AL,00110110B	;OUTPUT
                    OUT DX,AL

                    MOV DX,A8254
                    MOV AL,0E8H
                    OUT DX,AL
                    MOV AL,03h
                    OUT DX,AL

                    MOV DX,CON8254
		    MOV AL,01110110B
		    OUT DX,AL                	
                        
		    MOV DX,B8254
                    MOV AL,0E8H
                    OUT DX,AL
                    MOV AL,03h
                    OUT DX,AL
                	
                    MOV AX,4C00H
                    INT 21H
                
                ;
        CODES  ENDS
                END MAIN 








        STACKS  SEGMENT   STACK
                DB        128 DUP(?)
        STACKS  ENDS        
        ;
        CODES  SEGMENT
                ASSUME    CS:CODES,SS:STACKS                
                MAIN:
                	MOV DX,0606H
                	MOV AL,00110010H 	;OUTPUT
                	OUT DX,AL
                	
                        MOV DX,0600H
                        MOV AL,6
                        OUT DX,AL
                        MOV AL,0
                        OUT DX,AL                		
                        MOV AX,4C00H
                        INT 21H                
                ;
        CODES  ENDS
                END MAIN 








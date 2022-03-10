        STACKS  SEGMENT   STACK
                        DB 128 DUP(?)
        STACKS  ENDS
        ;
        DATAS  SEGMENT
                STRING DB "HELLO,WORLD!",0AH,0DH,'$'
        DATAS  ENDS
       ;
       
        CODES  SEGMENT
                ASSUME    CS:CODES,DS:DATAS,SS:STACKS 


                ;
                puts PROC NEAR
                        MOV DX,AX
                        MOV AH,09H
                        INT 21H
                        RET
                puts ENDP
                
                ;
                MAIN PROC FAR
                        MOV AX,DATAS
                        MOV DS,AX
                        MOV ES,AX
                        MOV AX,STACKS
                        MOV SS,AX

                        LEA AX,STRING
                        CALL puts



                        MOV AH,07H
                        MOV AL,0

                        ;CLEAR THE WINDOW
                        INT 10H



                        MOV AH,02H
                        MOV BH,00H
                        MOV DH,5
                        MOV DL,6
                        INT 10H

                        MOV AH,01H
                        INT 21H


                        MOV AH,02H
                        MOV BH,01H
                        MOV DH,8
                        MOV DL,9
                        INT 10H

                        MOV AH,01H
                        INT 21H



                        ;返回DOS
                        MOV AX,4C00H
                        INT 21H
                MAIN ENDP
        CODES ENDS
                END MAIN
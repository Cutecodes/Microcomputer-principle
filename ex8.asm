;输入 原始串（要含有小写才能看出效果）CTRL+c结束输入
;输出 
        STACKS  SEGMENT   STACK
                        DB 128 DUP(?)
        STACKS  ENDS
        ;
        DATAS  SEGMENT
                STRINGS DB 30 DUP(?)
                STRINGD DB 30 DUP(?)
        DATAS  ENDS
       ;
       
        CODES  SEGMENT
                ASSUME    CS:CODES,DS:DATAS,SS:STACKS
                ;
                gets PROC NEAR
                        MOV DI,AX
                LP:
                        MOV AH,01H           ;01号功能为输入一个字符并且显示  
                        INT 21H  
                        MOV [DI],AL         ;输入的字符存放在AL寄存器中,现(DS:[DI])=(AL)
                        INC DI
                        CMP BYTE PTR[DI-1],03H         ;CTRL+C
                        JNE LP
                        MOV BYTE PTR[DI-1],0AH
                        MOV BYTE PTR[DI],0DH
                        MOV BYTE PTR[DI+1],'$'
                        RET
                gets ENDP
                ;
                puts PROC NEAR
                        MOV DX,AX
                        MOV AH,09H
                        INT 21H
                        RET
                puts ENDP
                
                ;AX:THE SOURCE BX:THE DESTINATION CX:THE LENGTH
                LOWER_UPPER PROC NEAR
                    MOV SI,AX
                    MOV DI,BX
                LOWER_UPPER_LOOP:
                    MOV AL,BYTE PTR[SI]
                    MOV BYTE PTR[DI],AL
                    CMP BYTE PTR[DI],97
                    JS LOWER_UPPER_LABEL
                    SUB BYTE PTR[DI],32
                LOWER_UPPER_LABEL:
                    INC DI
                    INC SI
                    LOOP LOWER_UPPER_LOOP    
                    RET
                LOWER_UPPER ENDP
                ;

                MAIN PROC FAR
                        MOV AX,DATAS
                        MOV DS,AX
                        MOV ES,AX
                        MOV AX,STACKS
                        MOV SS,AX

                        LEA AX,STRINGS
                        CALL gets

                        LEA AX,STRINGS
                        LEA BX,STRINGD
                        MOV CX,30
                        CALL LOWER_UPPER

                        LEA AX,STRINGD
                        CALL puts


                        ;返回DOS
                        MOV AX,4C00H
                        INT 21H
                MAIN ENDP
        CODES ENDS
                END MAIN
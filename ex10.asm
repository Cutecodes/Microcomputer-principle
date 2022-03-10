;输入 一个数不大于8
;输出 阶乘
       STACKS  SEGMENT   STACK
                        DB 128 DUP(?)
        STACKS  ENDS
        ;
        DATAS  SEGMENT

                UINT16N DW 1 DUP(0)
                UINT16ANS DW 1 DUP(?)
                STRINGN DB 5 DUP(0),0AH,0DH,'$'
                STRINGANS DB 5 DUP(0),0AH,0DH,'$'

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
                        CMP BYTE PTR[DI-1],0DH         ;换行？
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
                
                ;AX:THE ADDRESS OF DEC ASCII CODE   BX:THE ADDRESS OF UINT16 
                BIN_DEC PROC NEAR
                        ADD AX,4
                        MOV SI,AX
                        MOV AX,WORD PTR[BX]
                        MOV DX,0
                        MOV BX,10
                        MOV CX,5


                        
                BIN_DEC_LABEL1:
                        DIV BX
                        ADD DL,30H
                        MOV BYTE PTR[SI],DL
                        AND DX,0
                        DEC SI
                        LOOP BIN_DEC_LABEL1
                
                        RET
                BIN_DEC ENDP

                ;AX:THE ADDRESS OF DEC ASCII CODE   BX:THE ADDRESS OF UINT16 
                DEC_BIN PROC NEAR
                        MOV WORD PTR[BX],0000H
                        MOV DI,AX
                        MOV SI,AX
                        
                DEC_BIN_LABEL1:
                        MOV CL,BYTE PTR[DI]
                        CMP CL,0AH
                        JE DEC_BIN_LABEL2
                        AND CL,0FH
                        MOV CH,00H
                        MOV AX,WORD PTR[BX]
                        MOV DX,10
                        MUL DX
                        ADD AX,CX
                        MOV WORD PTR[BX],AX
                        INC DI
                        JMP DEC_BIN_LABEL1
                DEC_BIN_LABEL2:
                        RET
                DEC_BIN ENDP
                ;AX:THE ADDRESS OF N BX:THE ADDRESS OF N!
                FACTORIAL PROC NEAR
                        MOV SI,AX
                        MOV DI,BX
                        MOV CX,WORD PTR[SI]
                        MOV AX,1
                FACTORIAL_LOOP:
                        MUL CX
                        LOOP FACTORIAL_LOOP
                        MOV WORD PTR[DI],AX
                        RET
                FACTORIAL ENDP
                ;
                MAIN PROC FAR
                        MOV AX,DATAS
                        MOV DS,AX
                        MOV ES,AX
                        MOV AX,STACKS
                        MOV SS,AX

                        LEA AX,STRINGN
                        CALL gets

                        LEA AX,STRINGN
                        LEA BX,UINT16N
                        CALL DEC_BIN

                        LEA AX,UINT16N
                        LEA BX,UINT16ANS
                        CALL FACTORIAL

                        LEA AX,STRINGANS
                        LEA BX,UINT16ANS
                        CALL BIN_DEC

                        LEA AX,STRINGANS
                        CALL puts

                       
                        ;返回DOS
                        MOV AX,4C00H
                        INT 21H
                MAIN ENDP
        CODES ENDS
                END MAIN
;输入 十个整数 回车为间隔
;输出 排序后
        STACKS  SEGMENT   STACK
                        DB 128 DUP(?)
        STACKS  ENDS
        ;
        DATAS  SEGMENT
                UINT16_ARRAY DW 10 DUP(?)

                UINT16A DW 1 DUP(?)
                STRINGDEC DB 5 DUP(0),0AH,0DH,'$'
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
                ;AX:THE ADDRESS OF UINT16 ARRAY CX:THE LENGTH
                BUBBLESORT PROC NEAR
                        MOV SI,AX
                        MOV BX,AX
                        ADD AX,CX
                        ADD AX,CX
                        SUB AX,2
                        MOV DI,AX
                        
                BUBBLESORT_MAIN_LOOP:
                        CMP SI,DI
                        JNS BUBBLE_LABEL1
                        MOV AX,WORD PTR[SI]
                        ADD SI,2
                        CMP AX,WORD PTR[SI]
                        JS BUBBLESORT_MAIN_LOOP
                        XCHG AX,WORD PTR[SI]
                        MOV WORD PTR[SI-2],AX
                        JMP BUBBLESORT_MAIN_LOOP

                    BUBBLE_LABEL1:
                        MOV SI,BX
                        SUB DI,2 
                        LOOP BUBBLESORT_MAIN_LOOP

                        RET
                BUBBLESORT ENDP 
                ;
                MAIN PROC FAR
                        MOV AX,DATAS
                        MOV DS,AX
                        MOV ES,AX
                        MOV AX,STACKS
                        MOV SS,AX

                        MOV CX,10
                        LEA DI,UINT16_ARRAY

                INPUT:
                        PUSH CX
                        PUSH DI
                        LEA AX,STRINGDEC
                        CALL gets
                        POP DI
                        PUSH DI

                        
                        
                        LEA AX,STRINGDEC
                        MOV BX,DI
                        CALL DEC_BIN
                        POP DI
                        POP CX
                        INC DI
                        INC DI
                        LOOP INPUT

                        LEA AX,UINT16_ARRAY
                        MOV CX,10
                        CALL BUBBLESORT


                        MOV CX,10
                        LEA DI,UINT16_ARRAY
                OUTPUT:
                        PUSH CX
                        PUSH DI

                        LEA AX,STRINGDEC
                        MOV BX,DI
                        CALL BIN_DEC
                        POP DI
                        PUSH DI
                        LEA AX,STRINGDEC
                        CALL puts
                        POP DI
                        POP CX
                        INC DI
                        INC DI
                        LOOP OUTPUT


                        ;返回DOS
                        MOV AX,4C00H
                        INT 21H
                MAIN ENDP
        CODES ENDS
                END MAIN
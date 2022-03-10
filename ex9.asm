;输入 按照提示
;输出 按照提示
        STACKS  SEGMENT   STACK
                        DB 128 DUP(?)
        STACKS  ENDS
        ;
        DATAS  SEGMENT
                STRING1 DB "THE DATA:(MM/DD/YY)",0AH,0DH,'$'
                STRING2 DB "WHAT IS THE DATA?(MM/DD/YY)",0AH,0DH,'$'

                UINT16A DW 6 DUP(0)
                STRINGMM DB 5 DUP(0),0AH,0DH,'$'
                STRINGDD DB 5 DUP(0),0AH,0DH,'$'
                STRINGYY DB 5 DUP(0),0AH,0DH,'$'
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
                ;SAVE AT STRINGMM,STRINGDD,STRINGYY
                GET_DATA PROC NEAR
                        MOV AH,2AH
                        INT 21H
                        MOV UINT16A[0],CX
                        MOV AH,0
                        MOV AL,DH
                        MOV UINT16A[2],AX
                        MOV AL,DL
                        MOV UINT16A[4],AX
                        LEA AX,STRINGYY
                        LEA BX,UINT16A[0]
                        CALL BIN_DEC
                        LEA AX,STRINGMM
                        LEA BX,UINT16A[2]
                        CALL BIN_DEC
                        LEA AX,STRINGDD
                        LEA BX,UINT16A[4]
                        CALL BIN_DEC
                        RET
                GET_DATA ENDP 
                ;
                SET_DATA PROC NEAR
                        LEA AX,STRINGYY
                        LEA BX,UINT16A[0]
                        CALL DEC_BIN
                        LEA AX,STRINGMM
                        LEA BX,UINT16A[2]
                        CALL DEC_BIN
                        LEA AX,STRINGDD
                        LEA BX,UINT16A[4]
                        CALL DEC_BIN

                        MOV CX,UINT16A[0]
                        MOV AX,UINT16A[2]
                        MOV DH,AL
                        MOV AX,UINT16A[4]
                        MOV DL,AL
                        MOV AH,2BH
                        INT 21H
                        RET

                SET_DATA ENDP
                ;
                MAIN PROC FAR
                        MOV AX,DATAS
                        MOV DS,AX
                        MOV ES,AX
                        MOV AX,STACKS
                        MOV SS,AX

                        LEA AX,STRING1
                        CALL puts

                        CALL GET_DATA

                        LEA AX,STRINGMM
                        CALL puts
                        LEA AX,STRINGDD
                        CALL puts
                        LEA AX,STRINGYY
                        CALL puts

                        LEA AX,STRING2
                        CALL puts
                        ;RING
                        MOV AH,2
                        MOV DL,7
                        INT 21H

                        LEA AX,STRINGMM
                        CALL gets
                        LEA AX,STRINGDD
                        CALL gets
                        LEA AX,STRINGYY
                        CALL gets

                        CALL SET_DATA


                        LEA AX,STRING1
                        CALL puts

                        CALL GET_DATA

                        LEA AX,STRINGMM
                        CALL puts
                        LEA AX,STRINGDD
                        CALL puts
                        LEA AX,STRINGYY
                        CALL puts
                        ;返回DOS
                        MOV AX,4C00H
                        INT 21H
                MAIN ENDP
        CODES ENDS
                END MAIN
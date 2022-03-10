;输入：一个十进制数
;输出：十进制ascii、内存存储形式、转换成二进制（无符号小端）、压缩bcd（正序）
        STACKS  SEGMENT   STACK
                        DB 128 DUP(?)
        STACKS  ENDS
        DATAS  SEGMENT
                STRING  DB 10 DUP(?)
                UINT16 DB 2 DUP(?)
                BCD DB 4 DUP(?)
                HEX_TABLE DB '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
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
                ;AX:THE ADDRESS OF MEM  CX:THE LENGTH NEED TO PRINT
                PRINT_HEX PROC NEAR
                        MOV DI,AX
                        MOV DL,'0'
                        MOV AH,2
                        INT 21H
                        MOV DL,'x'
                        MOV AH,2
                        INT 21H
                        LEA BX,HEX_TABLE
                PRINT_HEX_LABEL1:
                        MOV AL,BYTE PTR[DI]
                        SHR AL,1
                        SHR AL,1
                        SHR AL,1
                        SHR AL,1
                        XLAT
                        MOV DL,AL
                        MOV AH,2
                        INT 21H
                        MOV AL,BYTE PTR[DI]
                        AND AL,0FH
                        XLAT
                        MOV DL,AL
                        MOV AH,2
                        INT 21H
                        INC DI
                        LOOP PRINT_HEX_LABEL1
                        MOV DL,0AH
                        MOV AH,2
                        INT 21H
                        MOV DL,0DH
                        MOV AH,2
                        INT 21H
                        RET
                PRINT_HEX ENDP
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
                ;AX:THE ADDRESS OF ASCII CODE  BX:THE ADDRESS OF BCD
                ASCII_BCD PROC NEAR
                        MOV SI,AX
                        MOV DI,BX
                        MOV CX,0
                GET_LENGTH:
                        MOV DL,BYTE PTR[SI]
                        CMP DL,0AH
                        JE ASCII_BCD_LABEL1
                        INC CX
                        INC SI
                        JMP GET_LENGTH
                ASCII_BCD_LABEL1:
                        MOV SI,AX
                        MOV AX,CX
                        AND AX,1
                        CMP AX,1
                        ;奇偶判别
                        JNE ASCII_BCD_LABEL2
                        MOV AL,BYTE PTR[SI]
                        AND AL,0FH
                        MOV BYTE PTR[DI],AL
                        INC DI
                        INC SI
                        DEC CX
                ASCII_BCD_LABEL2:
                        MOV AL,BYTE PTR[SI]
                        AND AL,0FH
                        SHL AL,1
                        SHL AL,1
                        SHL AL,1
                        SHL AL,1
                        MOV AH,BYTE PTR[SI+1]
                        AND AH,0FH
                        OR AL,AH
                        MOV BYTE PTR[DI],AL
                        DEC CX
                        INC SI
                        INC SI
                        INC DI
                        LOOP ASCII_BCD_LABEL2
                        RET
                ASCII_BCD ENDP
                ;
                MAIN PROC FAR
                        MOV AX,DATAS
                        MOV DS,AX
                        MOV AX,STACKS
                        MOV SS,AX
                        LEA AX,STRING
                        CALL gets
                        LEA AX,STRING
                        CALL puts
                        

                        LEA AX,STRING
                        LEA BX,UINT16
                        CALL DEC_BIN

                        LEA AX,STRING
                        LEA BX,BCD
                        CALL ASCII_BCD

                        MOV CX,5
                        LEA AX,STRING
                        CALL PRINT_HEX

                        MOV CX,2
                        LEA AX,UINT16
                        CALL PRINT_HEX

                        MOV CX,3
                        LEA AX,BCD
                        CALL PRINT_HEX



                        ;返回DOS
                        MOV AX,4C00H
                        INT 21H
                MAIN ENDP
        CODES ENDS
                END MAIN
              

       

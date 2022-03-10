;计算0xf3f2f1f0+-0x10010110,无输入
;输出 加数 被加数 和 被减数 减数 差
        STACKS  SEGMENT   STACK
                DB        128 DUP(?)
        STACKS  ENDS
        ;
        DATAS  SEGMENT
                UINTA  DB  0F0H,0F1H,0F2H,0F3H    ;uint32 0xF3F2F1F0 
                UINTB  DB  10H,01H,01H,01H    ;uint32 0x01010110
                UINTC  DB        4 DUP(?)    ;uint32
                HEX_TABLE DB '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
        DATAS  ENDS
        ;
        CODES  SEGMENT
                ASSUME    CS:CODES,DS:DATAS,SS:STACKS
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
                ;AX:THE ADDRESS OF FIRST NUMBER BX:THE ADDRESS OF SECOND NUMBER DX:THE SUM
                ADDP PROC NEAR
                        MOV SI,AX
                        MOV DI,DX
                        MOV CX,4
                        CLC
                ADDP_LABEL1:
                        MOV AL,BYTE PTR[SI]
                        ADC AL,BYTE PTR[BX]
                        MOV BYTE PTR[DI],AL
                        INC SI
                        INC BX
                        INC DI
                        LOOP ADDP_LABEL1
                        RET
                        ;不考虑溢出
                ADDP ENDP
                ;
                ;AX:THE ADDRESS OF FIRST NUMBER BX:THE ADDRESS OF SECOND NUMBER DX:THE SUM
                SUBP PROC NEAR
                        MOV SI,AX
                        MOV DI,DX
                        MOV CX,4
                        CLC
                SUBP_LABEL1:
                        MOV AL,BYTE PTR[SI]
                        SBB AL,BYTE PTR[BX]
                        MOV BYTE PTR[DI],AL
                        INC SI
                        INC BX
                        INC DI
                        LOOP SUBP_LABEL1

                        RET
                        ;不考虑溢出
                SUBP ENDP
                ;
                MAIN PROC FAR
                        MOV AX,DATAS
                        MOV DS,AX
                        MOV AX,STACKS
                        MOV SS,AX
                        LEA AX,UINTA
                        LEA BX,UINTB
                        LEA DX,UINTC
                        CALL ADDP

                        MOV CX,4
                        LEA AX,UINTA
                        CALL PRINT_HEX
                        MOV CX,4
                        LEA AX,UINTB
                        CALL PRINT_HEX
                        MOV CX,4
                        LEA AX,UINTC
                        CALL PRINT_HEX

                        LEA AX,UINTA
                        LEA BX,UINTB
                        LEA DX,UINTC
                        CALL SUBP

                        MOV CX,4
                        LEA AX,UINTA
                        CALL PRINT_HEX
                        MOV CX,4
                        LEA AX,UINTB
                        CALL PRINT_HEX
                        MOV CX,4
                        LEA AX,UINTC
                        CALL PRINT_HEX

                        MOV AX,4C00H
                        INT 21H
                MAIN ENDP
                ;
        CODES  ENDS
                END MAIN 








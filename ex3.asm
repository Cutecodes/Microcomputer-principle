;输入 无输入
;输出 被除数、除数、商、余数、乘数、被乘数、积（小端）
        STACKS  SEGMENT   STACK
                        DB 128 DUP(?)
        STACKS  ENDS
        ;
        DATAS  SEGMENT

                INT32N DD -1001 ;被除数
                INT16A DW 11     ;除数
                INT16B DW 1 DUP(?) ;商
                INT16M DW 1 DUP(?) ;余数

                UINT16A DW 258H    ;无符号600
                UINT16B DW 258H    ;无符号600
                UINT32A DD 1 DUP(?);积 SHOULD BE 57E40H
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
                ;
                MAIN PROC FAR
                        MOV AX,DATAS
                        MOV DS,AX
                        MOV ES,AX
                        MOV AX,STACKS
                        MOV SS,AX

                        MOV AX,WORD PTR INT32N[0]
                        MOV DX,WORD PTR INT32N[2]
                        MOV BX,INT16A
                        IDIV BX
                        MOV INT16B,AX
                        MOV INT16M,DX
                        
                        LEA AX,INT32N
                        MOV CX,4
                        CALL PRINT_HEX

                        LEA AX,INT16A
                        MOV CX,2
                        CALL PRINT_HEX
                        
                        LEA AX,INT16B
                        MOV CX,2
                        CALL PRINT_HEX

                        LEA AX,INT16M
                        MOV CX,2
                        CALL PRINT_HEX

                        ;乘法
                        MOV BX,UINT16A
                        MOV AX,UINT16B
                        MUL BX
                        MOV WORD PTR UINT32A[0],AX
                        MOV WORD PTR UINT32A[2],DX

                        LEA AX,UINT16A
                        MOV CX,2
                        CALL PRINT_HEX

                        LEA AX,UINT16B
                        MOV CX,2
                        CALL PRINT_HEX
                        
                        LEA AX,UINT32A
                        MOV CX,4
                        CALL PRINT_HEX

                        

                       
                        ;返回DOS
                        MOV AX,4C00H
                        INT 21H
                MAIN ENDP
        CODES ENDS
                END MAIN
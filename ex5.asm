;输入 原始串、匹配串、原始串、要统计的字符
;输出 是否匹配、次数
        STACKS  SEGMENT   STACK
                        DB 128 DUP(?)
        STACKS  ENDS
        ;
        DATAS  SEGMENT
                STRING1 DB 20 DUP(0)
                STRING2 DB 20 DUP(0)
                DSTRING1 DB 20 DUP(0)
                DSTRING2 DB 20 DUP(0)
                UINT16A DW 1 DUP(?)
                STRINGDEC DB 5 DUP(0),0AH,0DH,'$'
                STRINGMATCH DB "MATCH",0AH,0DH,'$'
                STRINGNOMATCH DB "NO MATCH",0AH,0DH,'$'
                COUNT EQU 20
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
                ;
                MAIN PROC FAR
                        MOV AX,DATAS
                        MOV DS,AX
                        MOV ES,AX
                        MOV AX,STACKS
                        MOV SS,AX


                        LEA AX,DSTRING1
                        CALL gets
                        LEA AX,STRING1
                        CALL gets
                        LEA SI,STRING1
                        LEA DI,DSTRING1
                        MOV CX,COUNT
                        CLD
                        LEA AX,STRINGMATCH
                        REPE CMPSB
                        JE EQUAL
                        LEA AX,STRINGNOMATCH
                EQUAL:
                        STD
                        CALL puts

                        LEA AX,DSTRING2
                        CALL gets
                        LEA AX,STRING2
                        CALL gets

                        LEA DI,DSTRING2
                        MOV CX,COUNT
                        MOV BX,0                        
                        MOV AL,STRING2[0]
                COUNTX:
                        CMP AL,[DI]
                        JNE ISNX
                        INC BX
                ISNX:
                        INC DI
                        LOOP COUNTX

                        MOV UINT16A,BX
                        
                        LEA AX,STRINGDEC
                        LEA BX,UINT16A
                        CALL BIN_DEC
                        LEA AX,STRINGDEC
                        CALL puts



                        ;返回DOS
                        MOV AX,4C00H
                        INT 21H
                MAIN ENDP
        CODES ENDS
                END MAIN
              

       

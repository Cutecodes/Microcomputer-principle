;输入： 两个ascii十进制数 注意 前者必须大于后者
;输出： 两个数的非压缩bcd 以及和、差得bcd，均倒序（小端）
        STACKS  SEGMENT   STACK
                DB        128 DUP(?)
        STACKS  ENDS
        ;
        DATAS  SEGMENT
                STRING1  DB        20 DUP(?)   ;ASCII
                STRING2  DB        20 DUP(?)   ;ASCII
                STRING3  DB        20 DUP(?)   ;BCD
                STRING4  DB        20 DUP(?)   ;BCD
                LENGTH1  DB        1  DUP(?)   ;THE LENGTH OF NUMBER1
                LENGTH2  DB        1  DUP(?)   ;THE LENGTH OF NUMBER2
                STRING5  DB        20 DUP(?)   ;BCD,ANSWER
                STRING6  DB        20 DUP(?)   ;BCD,ANSWER
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
                ;
                ;AX:THE ADDRESS OF ASCII CODE  BX:THE ADDRESS OF BCD 非压缩版本,并改写成小端  

                ASCII_BCD1 PROC NEAR
                        MOV SI,AX
                        MOV DI,BX
                        MOV CX,0
                ASCII_BCD1_LOOP1:
                        MOV AL,BYTE PTR[SI]
                        CMP AL,0AH
                        JE ASCII_BCD1_END1
                        AND AL,0FH
                        MOV BYTE PTR[DI],AL
                        INC SI
                        INC DI
                        INC CX
                        JMP ASCII_BCD1_LOOP1
                ASCII_BCD1_END1:
                        MOV BYTE PTR[DI],0AH
                        MOV BYTE PTR[DI+1],0DH
                        MOV BYTE PTR[DI+2],'$'

                        SHR CL,1
                        DEC DI
                ASCII_BCD1_LOOP2:
                        MOV AL,BYTE PTR[DI]
                        XCHG AL,BYTE PTR[BX]
                        MOV BYTE PTR[DI],AL
                        INC BX
                        DEC DI

                        LOOP ASCII_BCD1_LOOP2



                        RET
                ASCII_BCD1 ENDP
                ;AX:THE ADDRESS OF NUMBER1 BX:THE ADDRESS OF NUMBER2 DX:THE ADDRESS OF SUM
                ADDBCD PROC NEAR
                        MOV SI,AX
                        MOV DI,DX
                        CLC
                        PUSHF
                ADDBCD_LOOP1:
                        CMP BYTE PTR[BX],0AH
                        JE ADDBCD_END1
                        POPF
                        MOV AL,BYTE PTR[SI]
                        ADC AL,BYTE PTR[BX]
                        AAA ;AX SAVE THE ANS
                        PUSHF
                        MOV BYTE PTR[DI],AL
                        INC SI
                        INC DI
                        INC BX
                        LOOP ADDBCD_LOOP1
                ADDBCD_END1:

                ADDBCD_LOOP2:
                        CMP BYTE PTR[SI],0AH
                        JE ADDBCD_END2
                        POPF
                        MOV AL,BYTE PTR[SI]
                        ADC AL,00H
                        

                        AAA
                        PUSHF
                        MOV BYTE PTR[DI],AL
                        INC SI
                        INC DI
                        LOOP ADDBCD_LOOP2
                ADDBCD_END2:
                        POPF
                        MOV BYTE PTR[DI],00H
                        ADC BYTE PTR[DI],00H

                        MOV BYTE PTR[DI+1],0AH
                        MOV BYTE PTR[DI+2],0DH
                        MOV BYTE PTR[DI+3],'$'
                        RET


                ADDBCD ENDP
                ;

                ;AX:THE ADDRESS OF NUMBER1 BX:THE ADDRESS OF NUMBER2 DX:THE ADDRESS OF ANS
                SUBBCD PROC NEAR
                        MOV SI,AX
                        MOV DI,DX
                        CLC
                        PUSHF
                SUBBCD_LOOP1:
                        CMP BYTE PTR[BX],0AH
                        JE SUBBCD_END1
                        POPF
                        MOV AL,BYTE PTR[SI]
                        SBB AL,BYTE PTR[BX]
                        AAS ;AX SAVE THE ANS
                        PUSHF
                        MOV BYTE PTR[DI],AL
                        INC SI
                        INC DI
                        INC BX
                        LOOP SUBBCD_LOOP1
                SUBBCD_END1:

                SUBBCD_LOOP2:
                        CMP BYTE PTR[SI],0AH
                        JE SUBBCD_END2
                        POPF
                        MOV AL,BYTE PTR[SI]
                        SBB AL,00H
                        

                        AAS
                        PUSHF
                        MOV BYTE PTR[DI],AL
                        INC SI
                        INC DI
                        LOOP SUBBCD_LOOP2
                SUBBCD_END2:
                        MOV BYTE PTR[DI],00H
                        POPF
                        SBB BYTE PTR[DI],00H
                        MOV BYTE PTR[DI+1],0AH
                        MOV BYTE PTR[DI+2],0DH
                        MOV BYTE PTR[DI+3],'$'
                        RET


                SUBBCD ENDP
                ;
                MAIN PROC FAR
                        MOV AX,DATAS
                        MOV DS,AX
                        MOV AX,STACKS
                        MOV SS,AX

                        LEA AX,STRING1
                        CALL gets

                        LEA AX,STRING2
                        CALL gets

                        LEA AX,STRING1
                        LEA BX,STRING3
                        CALL ASCII_BCD1
                        MOV LENGTH1,CL
                        LEA AX,STRING2
                        LEA BX,STRING4
                        CALL ASCII_BCD1
                        MOV LENGTH2,CL

                        LEA AX,STRING3
                        MOV CX,10
                        CALL PRINT_HEX
                        
                        LEA AX,STRING4
                        MOV CX,10
                        CALL PRINT_HEX

                        LEA AX,STRING3
                        LEA BX,STRING4
                        LEA DX,STRING5
                        CALL ADDBCD

                        LEA AX,STRING5
                        MOV CX,10
                        CALL PRINT_HEX


                        LEA AX,STRING3
                        LEA BX,STRING4
                        LEA DX,STRING6
                        CALL SUBBCD

                        LEA AX,STRING6
                        MOV CX,10
                        CALL PRINT_HEX
                        



                        ;返回DOS
                        MOV AX,4C00H
                        INT 21H
                MAIN ENDP
        CODES ENDS
                END MAIN

              clc

       ADDP:
              MOV       AL,[DI]
              ADC       AL,[SI]
				


              AAA                   ;ax save the ans
              
              MOV       [BX],AL
              DEC       SI
              DEC       DI
              DEC       BX
              LOOP      ADDP
              MOV       BYTE PTR[BX],00H
              ADC       BYTE PTR[BX],00H

              mov cx,7
              lea si,data3
       bcdtoascii:

       			ADD       byte ptr[si],30H      ;bcd to ascii
       			inc si
       			loop bcdtoascii

              LEA       DX,DATA3
              MOV       AH,09H
              INT       21H

              MOV       AX,4C00H
              INT       21H
       CODES  ENDS
              END       START

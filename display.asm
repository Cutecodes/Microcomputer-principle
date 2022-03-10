      STACKS  SEGMENT   STACK
              DB        128 DUP(?)
      STACKS  ENDS

       DATAS  SEGMENT
      STRING  DB        13,10,'hello world!',13,10,'$'
       DATAS  ENDS

       CODES  SEGMENT
              ASSUME    CS:CODES,DS:DATAS
      START:
              MOV       AX,DATAS
              MOV       DS,AX
              LEA       DX,STRING
              MOV       AH,9
              INT       21H
              MOV       AH,01
              INT       21H
              MOV       AX,4C00H
              INT       21H
       CODES  ENDS
              END       START

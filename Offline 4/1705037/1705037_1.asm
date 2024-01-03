.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB CR,LF, 'ENTER 1ST 2*2 ARRAY IN ROW MAJOR ORDER: $'
    MSG2 DB CR,LF, 'ENTER 2ND 2*2 ARRAY IN ROW MAJOR ORDER: $'
    MSG3 DB CR,LF, 'RESULTANT 2*2 ARRAY IN ROW MAJOR ORDER: $'
    
    
    A DW 2 DUP(0)
      DW 2 DUP(0)
      
    B DW 2 DUP(0)
      DW 2 DUP(0)
      
    C DW 2 DUP(0)
      DW 2 DUP(0)
      
    P DW ?
    
    STORE_CX DW ?
    STORE_BX DW ?    
      
       

.CODE

PRINT PROC
    
    XOR AX,AX ;CLEAR AX
    
    MOV STORE_BX,BX
    XOR BX,BX ;CLEAR BX
    
    XOR DX,DX ;CLEAR DX
    
    MOV STORE_CX,CX
    XOR CX,CX ;CLEAR CX

    
    WHILE:
        MOV AX,P
        CWD
        MOV BX,10
        DIV BX  ;AX=P/10
        MOV P,AX
        
        PUSH DX
        INC CX ;COUNT OF DIGITS IN RESULT
        
        XOR DX,DX ;CLEAR DX
        XOR AX,AX ;CLEAR AX
        
        CMP P,0;CHECK IF DIVISION IS COMPLETE
        JE END_WHILE
        JMP WHILE
        
    END_WHILE:
    
    
    MOV AH,2
    
    TOP:
        POP DX
        ADD DX,030H
        INT 21H
        LOOP TOP
    
    MOV BX,STORE_BX
    MOV CX,STORE_CX
    RET
    
PRINT ENDP        


INPUTA PROC
    MOV CX,2  ;NUMBER OF ELEMENTS IN A ROW
    INPA:
       MOV AH,1
       INT 21H
       SUB AX,030H
       XOR AH,AH
       MOV A[BX][SI],AX
       
       ADD SI,2
       
       XOR AX,AX
       
       MOV AH,2
       MOV DL,' '
       INT 21H
       
      
       LOOP INPA
       
       RET
    
    
ENDP INPUTA

INPUTB PROC
    MOV CX,2  ;NUMBER OF ELEMENTS IN A ROW
    INPB:
       MOV AH,1
       INT 21H
       SUB AX,030H
       XOR AH,AH
       MOV B[BX][SI],AX
       
       ADD SI,2
       
       XOR AX,AX
       
       MOV AH,2
       MOV DL,' '
       INT 21H
       
      
       LOOP INPB
       
       RET
    
    
ENDP INPUTB

ADDITION PROC
    MOV CX,2  ;NUMBER OF ELEMENTS IN A ROW
    ITER:
       MOV AX,A[BX][SI]
       ADD AX,B[BX][SI]
       MOV C[BX][SI],AX
       
       MOV P,AX
       CALL PRINT
       
       ADD SI,2
       
       XOR AX,AX
       
       MOV AH,2
       MOV DL,' '
       INT 21H
       
      
       LOOP ITER
       
       RET
    
    
ENDP ADDITION




MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
    ;TAKE ARRAY A INPUT
    
    LEA DX,MSG1
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    
    
    ;BASED INDEXED ADDRESSING MODE
    
    MOV BX,0 ;BX INDEXES ROW 0
    XOR SI,SI
    XOR AX,AX
    
    CALL INPUTA
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    
    MOV BX,4 ;BX INDEXES ROW 2
    XOR SI,SI
    XOR AX,AX
    
    CALL INPUTA
    
    
    
    
    
    ;TAKE ARRAY B INPUT
    
    LEA DX,MSG1
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    
    MOV BX,0 ;BX INDEXES ROW 0
    XOR SI,SI
    XOR AX,AX
    
    CALL INPUTB
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    
    MOV BX,4 ;BX INDEXES ROW 2
    XOR SI,SI
    XOR AX,AX
    
    CALL INPUTB
    
    
    LEA DX,MSG3
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    
    
    
    ;ADDITION OPERATION
    MOV BX,0 ;BX INDEXES ROW 0
    XOR SI,SI
    XOR AX,AX
    
    CALL ADDITION
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    
    MOV BX,4 ;BX INDEXES ROW 2
    XOR SI,SI
    XOR AX,AX
    
    CALL ADDITION
    
    
    
       
    
    
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN
.MODEL SMALL
.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB CR,LF,'ENTER FIRST OPERAND: $'
    MSG2 DB CR,LF,'ENTER OPERATOR: $'
    MSG3 DB CR,LF,'WRONG OPERATOR $'
    MSG4 DB CR,LF,'ENTER SECOND OPERAND: $'
    
    A DW ?;we store first operand here
    ND DW ?;we store newest input digit here
    B DW ?;we store second operand here
    O DB ?;we store the operator here
    R DW ?;we store the result here
    P DW ? ;we print each number using this variable
    
    SIGN DB ?;boolean variable to check if an operand is signed



.CODE

OPERAND PROC
    INT 21H
    
    XOR CX,CX ;CLEARED CX
    MOV B,0 ;CLEARED VARIABLE B
    
    
    
    MOV AH,1
    INT 21H
    XOR AH,AH
    
    CMP AL,'-'
    JE SIGNED
    
 ; NUMBER DOESN'T HAVE (-) IN BEGINNING. GO TO CHECK   
    MOV SIGN,0
    JMP CHECK
    
    
WHILE_:
    XOR AX,AX ;CLEAR AX
    MOV AH,1
    INT 21H
    
    XOR AH,AH
    CMP AL,0DH ; IF ENTER PRESSED END LOOP
    JE END_WHILE_
    
    
    CHECK:
    CMP AL,'9'
    JG WHILE_
    
    CMP AL,'0'
    JL WHILE_
    
    
    ;IF INPUT IS ACCEPTABLE
    
    SUB AL,030H;CONVERT ASCII CHAR TO NUMBER
    MOV ND,AX; NEWEST INPUT DIGIT TO ND
    MOV AX,B ; SUM OF SO FAR FORMED NUMBER FROM INPUTS TO AX
    INC CX  ;COUNT OF DIGITS
    MOV BX,10 ;BX=10
    IMUL BX  ; AX *= AX*BX --> AX*=10
    ADD AX,ND ; AX+=NEWEST INPUT DIGIT
    MOV B,AX ; SUM OF SO FAR FORMED NUMBER FROM INPUTS TO B
    
    
    
    JMP WHILE_
    
    SIGNED:
    MOV SIGN,1;SETTING SIGN 1 IF B IS NEGATIVE
    JMP WHILE_
    
    
END_WHILE_:
    MOV AH,2
    MOV DL,0DH
    INT 21H
    MOV DL,0AH
    INT 21H
    JCXZ EXIT
    
    CMP SIGN,0
    JE RETURN
    NEG B ; SIGN==1, SO B IS NEGATIVE


RETURN:   
    RET
OPERAND ENDP


PRINT PROC
    MOV AH,2
    MOV DL,'['
    INT 21H
    
    XOR AX,AX ;CLEAR AX
    XOR BX,BX ;CLEAR BX
    XOR CX,CX ;CLEAR CX
    
    CMP P,0
    JL PROCESS_NEG ;IF RESULT IS NEGATIVE, JUMP HERE TO PRINT (-) IN FRONT
    JMP WHILE ;ELSE GOTO WHILE
    
    
    PROCESS_NEG:
    NEG P
    MOV AH,2
    MOV DL,'-'
    INT 21H
    
    XOR AH,AH
    XOR DL,DL
    
     
    
    
    
    WHILE:
        MOV AX,P
        CWD
        MOV BX,10
        IDIV BX  ;AX=P/10
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
    MOV AH,2
    MOV DL,']'
    INT 21H

   
    RET
    
PRINT ENDP    




MAIN PROC
    
    ;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
    LEA DX, MSG1;ASK FOR OPERAND 1
    MOV AH, 9
    CALL OPERAND; CALL PROCEDURE
    
    MOV AX,B
    MOV A,AX ;MOVED FIRST OPERAND TO A
    MOV B,0 ;CLEARED VARIABLE B
    XOR AX,AX ;CLEAR AX
    
    LEA DX, MSG2;ASK FOR OPERATOR
    MOV AH, 9
    INT 21H
    
    
    MOV AH,1
    INT 21H
    
    
    
    CMP AL,'q'
    JE EXIT
    
    MOV O,AL ;MOVE OPERATOR TO O
    XOR AX,AX ;CLEAR AX
    
    
    LEA DX, MSG4;ASK FOR OPERAND 2
    MOV AH, 9
    CALL OPERAND; CALL PROCEDURE
    
    
    
    ;A,0,B IN PLACE. NOW WE PERFORM OPERATION
    CMP O,'+'
    JE ADDITION
    
    CMP O,'-'
    JE SUBTRACTION
    
    CMP O,'*'
    JE MULTIPLICATION
    
    CMP O,'/'
    JE DIVISION
    
    ;IF OPERATOR IS ANYTHING ELSE, PRINT WRONG OPERATOR AND EXIT
    LEA DX, MSG3
    MOV AH, 9
    INT 21H
    JMP EXIT
    
    ADDITION:
    MOV AX,B
    ADD AX,A;AX = A+B
    MOV R,AX;R = A+B
    JMP OPERATION_DONE 
    
    SUBTRACTION:
    MOV AX,A
    SUB AX,B;AX = A-B
    MOV R,AX;R = A-B
    JMP OPERATION_DONE
    
    MULTIPLICATION:
    MOV AX,A
    MOV BX,B
    IMUL BX;AX = A*B
    MOV R,AX
    JMP OPERATION_DONE
    
    DIVISION:
    MOV AX,A
    CWD
    MOV BX,B
    IDIV BX  ;AX=A/B
    MOV R,AX
    JMP OPERATION_DONE
    
    
    OPERATION_DONE:
    
    MOV AX,A
    MOV P,AX
    CALL PRINT
    
    MOV DL,'['
    MOV AH,2
    INT 21H
    
    MOV DL,O
    MOV AH,2
    INT 21H
    
    MOV DL,']'
    MOV AH,2
    INT 21H
    
    MOV AX,B
    MOV P,AX
    CALL PRINT
    
    MOV DL,'='
    MOV AH,2
    INT 21H
    
    MOV AX,R
    MOV P,AX
    CALL PRINT
    
    MOV DL,0DH
    MOV AH,2
    INT 21H
    
    MOV DL,0AH
    MOV AH,2
    INT 21H
    
    
    
                         
    

EXIT:
    MOV AH,4CH
    INT 21H
    
MAIN ENDP
END MAIN 
    



   
        
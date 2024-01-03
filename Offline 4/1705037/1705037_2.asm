.MODEL SMALL

.STACK

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    N DW ?
    N1 DW ?
    N2 DW ?
    
    S_INIT DW ?
    
    MSG1 DB CR,LF, 'ENTER 2 DIGIT NUMBER N : $'
    P DW ?
    
    PR DW 100 DUP(0)
    
    STORE_AX DW ?
    STORE_BX DW ?
    STORE_CX DW ?
    STORE_DX DW ?

       


.CODE

PRINT PROC
    MOV STORE_AX,AX
    XOR AX,AX ;CLEAR AX
    
    MOV STORE_BX,BX
    XOR BX,BX ;CLEAR BX
    
    MOV STORE_DX,DX
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
    
    MOV AH,2
    MOV DL,' '
    INT 21H
    
    
    
    MOV AX,STORE_AX
    MOV BX,STORE_BX
    MOV CX,STORE_CX
    MOV DX,STORE_DX
    
   
    
    RET
    
PRINT ENDP

FIBONACCI PROC
  PUSH BP     
  MOV  BP, SP
  MOV  AX, [BP+4] ;TOP - BP - N (EACH HAS 2 BYTES) ; AX NOW HAS N
  
  
  
  CMP  AX, 2       ; CHECKING IF WE REACHED BASE CASE WHERE N=2 OR 1
  JLE  BASE_CASE
  JMP CONTINUE
  
  BASE_CASE:
    
  MOV  CX, 1       ; CX STORES RESULT. IF N==1, FIBONACCI(N)=1
  XOR SI,SI  ;CLEAR INDEX FOR PRINTING ARRAY
  
  MOV DX,2   ; DX = 2
  MUL DX     ; AX = N*2
  
  MOV SI,AX  ; SI = N*2 [INDEX IS N. PER WORD TAKES 2 BYTES, SO 2N]
  MOV PR[SI],CX  ; ARRAY[N] = FIB(N-1) + FIB(N-2)
  
  JMP  EXIT

CONTINUE:

  DEC  AX          ; DECREASE N BY 1
  MOV  DX, AX       
  PUSH DX          ; STORING SPACE FOR FIB(N-1) FOR LATER ; HERE STACK : - (RESULT SPACE "CURRENTLY N-1") - PREVIOUS BP -
  
  PUSH AX          ; STORING N-1 ; HERE STACK : - N-1 - (RESULT SPACE "CURRENTLY N-1") - PREVIOUS BP -
  
  CALL FIBONACCI   ; THIS WILL RETURN THE SUM TO CX
 
  POP  AX          ; FIRST WE TAKE OUT N-1  ; HERE STACK : - N-1 - PREVIOUS BP -
  DEC  AX          ; THIS GIVES N-2
  
  PUSH CX          ; HERE STACK : - FIB(N-1) - PREVIOUS BP -
  PUSH AX          ; HERE STACK : - N-2 - FIB(N-1) - PREVIOUS BP -
  
  CALL FIBONACCI   ; THIS WILL RETURN THE SUM TO CX
  
  POP DX    ; DX HAS N-2  ; HERE STACK : - FIB(N-1) - PREVIOUS BP -
  POP  AX   ; AX HAS FIB(N-1) ; HERE STACK : - PREVIOUS BP -
  
  ADD  CX, AX     ; THIS GIVES CX = FIB(N-1) + FIB(N-2)
  
EXIT:

  XOR SI,SI  ;CLEAR INDEX FOR PRINTING ARRAY
  
  ADD DX,2   ; SEE ABOVE. DX HAS N-2. SO IF WE ADD 2, WE GET N. SO DX = N. 
  MOV AX,DX  ; AX = N
  MOV DX,2   ; DX = 2
  
  MUL DX     ; AX = N*2
  MOV SI,AX  ; SI = N*2 [INDEX IS N. PER WORD TAKES 2 BYTES, SO 2N]
  
  
  
  MOV PR[SI],CX  ; ARRAY[N] = FIB(N-1) + FIB(N-2)
  
  MOV  SP,BP
  POP  BP
  
  RET
  
FIBONACCI ENDP

MAIN PROC
    ;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
    MOV PR,0
    MOV PR+2,1
    
    MOV S_INIT,SP
    
    ;TAKE INPUT
    
    LEA DX,MSG1
    MOV AH,9
    INT 21H
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    
    
    MOV CX,0 ; WE STORE RESULT HERE
     
    ;TAKE INPUT DIGIT 1
    MOV AH,1
    INT 21H
    XOR AH,AH
    SUB AX,30H
    MOV N1,AX
    
    MOV BX,10
    MUL BX
    MOV BX,AX
    
    ;TAKE INPUT DIGIT 2
    MOV AH,1
    INT 21H
    XOR AH,AH
    SUB AX,30H
    MOV N2,AX
    
    MOV AH,2
    MOV DL,0DH
    INT 21H
    
    MOV AH,2
    MOV DL,0AH
    INT 21H
    
    ADD BX,N2
    
    MOV N,BX   ; N IS STORED IN BX
    
    PUSH BX             ; WE PUSH THE VALUE OF N IN THE STACK
    CALL FIBONACCI      
    
              
    ;THIS IS FOR PRINTING THE SERIES.
    ;WE HAVE TAKEN THE SERIES IN AN ARRAY
            
    MOV CX,N
    MOV BX,0 ;STORES INDEX OF ARRAY
    
    NOW_PRINT: ;WHILE CX>0,PRINT ARRAY (WILL PRINT UNTIL NTH ELEMENT)
        MOV AX,PR[BX]
        MOV P,AX
        CALL PRINT
        ADD BX,2 ;i++
        DEC CX
        
        CMP CX,0
        JE EXIT_PROG
        
        JMP NOW_PRINT
                  
    EXIT_PROG:
    
    MOV SP,S_INIT
    
    MOV AH,4CH
    INT 21H
    
MAIN ENDP

END MAIN
.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER A DIGIT(0-9): $'
    MSG2 DB CR,LF, 'ENTER ANOTHER DIGIT(0-9): $'
    MSG3 DB CR,LF, 'THE SECOND LARGEST NUMBER IS: $'
    MSG4 DB CR,LF, 'ALL THE NUMBERS ARE EQUAL. $'
    X DB ?
    Y DB ?
    Z DB ?

.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
;print user prompt
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

;TAKE X AS INPUT     
    MOV AH, 1
    INT 21H
    SUB AL,30H ;CONVERT TO HEX FROM ASCII
    MOV X, AL
    
;print user prompt
    LEA DX, MSG2
    MOV AH, 9
    INT 21H

;TAKE Y AS INPUT     
    MOV AH, 1
    INT 21H
    SUB AL,30H ;CONVERT TO HEX FROM ASCII
    MOV Y, AL 

;print user prompt
    LEA DX, MSG2
    MOV AH, 9
    INT 21H

;TAKE Z AS INPUT     
    MOV AH, 1
    INT 21H
    SUB AL,30H ;CONVERT TO HEX FROM ASCII
    MOV Z, AL
    
    LEA DX, MSG3
    MOV AH, 9
    INT 21H

    
IF_XGY:    
    MOV AL,X
    CMP AL,Y
    JZ IF_XEY
    JNL IF_XGZ
    JMP IF_YGZ

IF_XGZ:
    MOV AL,X
    CMP AL,Z
    JZ IF_XEZ
    JNL IF_YGZ_XL
    MOV AH, 2
    MOV DL,X
    JMP DISPLAY

IF_YGZ:
    MOV AL,Y
    CMP AL,Z
    JZ IF_YEZ
    JNL IF_XGZ_YL
    MOV AH, 2
    MOV DL,Y
    JMP DISPLAY
    
IF_YGZ_XL:
    MOV AL,Y
    MOV AH, 2
    MOV DL,Y
    CMP AL,Z
    JNL DISPLAY
    MOV AH, 2
    MOV DL,Z
    JMP DISPLAY

IF_XGZ_YL:
    MOV AL,X
    MOV AH, 2
    MOV DL,X
    CMP AL,Z
    JNL DISPLAY
    MOV AH, 2
    MOV DL,Z
    JMP DISPLAY
    
IF_XEY:
    MOV AL,Y
    CMP AL,Z
    JZ DISPLAY_ALL_E
    MOV AH,2
    MOV DL,Z
    JMP DISPLAY

;GIVEN THAT X>Y
IF_XEZ:
    MOV AH,2
    MOV DL,Y
    JMP DISPLAY

;GIVEN THAT X>Y    
IF_YEZ:
    MOV AH,2
    MOV DL,X
    JMP DISPLAY    
        
    

DISPLAY_ALL_E:
    LEA DX, MSG4
    MOV AH, 9
    INT 21H
    JMP EXIT

DISPLAY:
    ADD DL,30H;CONVERT TO ASCII
    INT 21H
    
    
;DOX exit
EXIT:
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN
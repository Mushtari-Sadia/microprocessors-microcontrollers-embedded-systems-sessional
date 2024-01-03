.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER A UPPER CASE LETTER: $'
    MSG2 DB CR, LF, 'PREVIOUS LETTER IN LOWER CASE IS: $'
    MSG3 DB CR, LF, '1S COMPLEMENT OF LETTER IS: $'
    CHAR DB ?
    CHAR2 DB ?
    C DB ?

.CODE

MAIN PROC
;initialize DS
    MOV AX, @DATA
    MOV DS, AX
    
;print user prompt
    LEA DX, MSG1
    MOV AH, 9
    INT 21H

;input a upper case character and convert it to lower case     
    MOV AH, 1
    INT 21H
    MOV C,AL
    
    MOV AL,C
    SUB AL,1H
    ADD AL, 20H
    MOV CHAR, AL
    
;display on the next line
    LEA DX, MSG2
    MOV AH, 9
    INT 21H  
    
;display the lower case character  
    MOV AH, 2
    MOV DL, CHAR
    INT 21H
    
    MOV AL,C
    MOV BL,0FFH
    
    SUB BL,AL
    MOV AL,BL
    
    MOV CHAR2,AL
    
    ;display on the next line
    LEA DX, MSG3
    MOV AH, 9
    INT 21H  
    
;display the lower case character  
    MOV AH, 2
    MOV DL, CHAR2
    INT 21H
    
    
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN
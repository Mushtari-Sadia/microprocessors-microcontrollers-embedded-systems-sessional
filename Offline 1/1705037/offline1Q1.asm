.MODEL SMALL

.STACK 100H

.DATA
    CR EQU 0DH
    LF EQU 0AH
    
    MSG1 DB 'ENTER A DIGIT(0-9): $'
    MSG2 DB CR,LF, 'ENTER ANOTHER DIGIT(0-9): $'
    Q1 DB CR, LF, 'Z=X-2Y= $'
    Q2 DB CR, LF, 'Z=25 - (X+Y)= $'
    Q3 DB CR, LF, 'Z=2X-3Y= $'
    Q4 DB CR, LF, 'Z=Y-X+1= $'
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
    
    ;Z=X-2Y
    MOV AL,X
    SUB AL,Y
    SUB AL,Y
    MOV Z,AL
    
    
    ;CONVERT TO ASCII
    ADD Z,30H
        
    
;display on the next line
    LEA DX, Q1
    MOV AH, 9
    INT 21H  
    
;DISPLAY Z AS OUTPUT  
    MOV AH, 2
    MOV DL, Z
    INT 21H
    
    
    
    ;Z=25 - (X + Y)
    MOV AL,25
    SUB AL,X
    SUB AL,Y
    MOV Z,AL
    
    
    ;CONVERT TO ASCII
    ADD Z,30H
        
    
;display on the next line
    LEA DX, Q2
    MOV AH, 9
    INT 21H  
    
;DISPLAY Z AS OUTPUT  
    MOV AH, 2
    MOV DL, Z
    INT 21H 
    
    
    ;Z= 2X - 3Y
    MOV AL,X
    ADD AL,X
    SUB AL,Y
    SUB AL,Y
    SUB AL,Y
    MOV Z,AL
    
    
    ;CONVERT TO ASCII
    ADD Z,30H
        
    
;display on the next line
    LEA DX, Q3
    MOV AH, 9
    INT 21H  
    
;DISPLAY Z AS OUTPUT  
    MOV AH, 2
    MOV DL, Z
    INT 21H
    
    
    ;Z= Y - X + 1
    MOV AL,Y
    SUB AL,X
    ADD AL,1
    MOV Z,AL
    
    
    ;CONVERT TO ASCII
    ADD Z,30H
        
    
;display on the next line
    LEA DX, Q4
    MOV AH, 9
    INT 21H  
    
;DISPLAY Z AS OUTPUT  
    MOV AH, 2
    MOV DL, Z
    INT 21H
    
    
;DOX exit
    MOV AH, 4CH
    INT 21H
  
MAIN ENDP

    END MAIN
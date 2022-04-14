include 'emu8086.inc'
    
    
    ENC_TABLE EQU 5FFH
    
    org 100h                    

;   -----------------------------
;   store ascii a -> z     

    MOV CX, 26
    MOV AL, 61H
    MOV DI, 600H
    CLD         
    L1:
        STOSB 
        INC AL
        LOOP L1  
;   -----------------------------        
;   store 1 ->26
    MOV CX, 26
    MOV AL, 1
    MOV DI, 660H ;   
    CLD
    L2:  
        STOSB   
        INC AL  
        LOOP L2
;   -----------------------------   


begin:        
    LEA SI, IN_ENC
    CALL print_string    
    ; TAKE INPUT   
    LEA    DI, BUFF         ;   set up pointer (DI) to input buffer
    MOV    DX, buffSize     ;   set size of buffer
    CALL   get_string       ;   get name & put in buffer
    
    LEA SI, OUT_ENC
    CALL print_string 
     
    MOV DI, ENC_TABLE
    MOV BX, DI
    LEA SI, BUFF
    
NEXT_ENC:
    CMP [SI], 0
    JE  E_END
    LODSB 
    ;CHECK IF INPUT BETWEEN A-Z
    CMP AL, 'a'
    JB  NEXT_ENC
    CMP AL, 'z'
    JA  NEXT_ENC
    XLAT
    
    MOV [SI-1], AL
    MOV AH, 0
    CALL PRINT_NUM_UNS 
    
    JMP NEXT_ENC
     
    
E_END:       
    MOV [SI], '$'           ;   store '$' at the end of the string
    MOV BX, ENC_TABLE
    LEA SI, BUFF
    
NEXT_DEC:
    CMP [SI], '$'
    JE  D_END
    LODSB 
    
    CMP AL, 1
    JB  NEXT_DEC
    CMP AL, 26
    JA  NEXT_DEC   
    
    XLAT
    MOV [SI-1], AL 
    JMP NEXT_DEC
    
D_END:               
    LEA SI, D_MSG
    CALL print_string  
    
    LEA DX, BUFF
    MOV AH, 9
    INT 21H
              
    LEA SI, NEW_LINE
    CALL print_string  
    JMP begin

 
NEW_LINE DB 0Dh,0Ah,'======================================================',0Dh,0Ah,,0
IN_ENC DB 'Enter a message to encrypt: ' ,0
OUT_ENC DB 0Dh,0Ah, 'The encrypted message is: ', 0 
D_MSG DB 0Dh,0Ah, 'Decrypted message is: ' ,0 

BUFF db 27 dup(0)
buffSize = $ - 1

DEFINE_PRINT_STRING  
DEFINE_GET_STRING
DEFINE_PRINT_NUM_UNS

END

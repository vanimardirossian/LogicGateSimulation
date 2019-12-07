.MODEL  SMALL

.CODE                   ;Marks the start of the code segment
ORG 0100H               ;The starting address offset of the program

MAIN:
    MOV AX,@DATA        ;Point the data segment to .DATA
    MOV DS,AX


     
            
MOV AL, 00011000B       ;Move into AL the binary input for my gates

                        ;Perform a NAND on bits 0 and 1
MOV BL, AL              ;Copy the input bit into BL                            
MOV CL, AL              ;Copy the input bit into CL
AND BL, 00000001B       ;Mask off all of the bits except for bit 0
AND CL, 00000010B       ;Mask off all of the bits except for bit 1
SHR CL, 1               ;Shift the bit in CL to the right by 1 bit so that the operation is performed correctly
CALL MYNAND             ;Jump to the NAND subroutine to perform the operation
                        ;This result is stored in AH

                        ;Perform an AND operation on bit 2 and the result of the first NAND stored in AH
MOV BL, AH              ;Copy the result of the first NAND into BL
MOV CL, AL              ;Copy the input bit into BL
AND CL, 00000100B       ;Mask off all of the bits except for bit 2
SHR CL, 2               ;Shift the bit in CL to the right by 2 bits so that the operation is performed correctly
CALL MYAND              ;Jump to the AND subroutine to perform the operation
                        ;This result is stored in AH, overwriting the result of the first NAND

                        ;Perform a NOT operation on bit 3
MOV BL, AL              ;Copy the input bit into BL
AND BL, 00001000B       ;Mask off all of the bits except for bit 3
SHR BL, 3               ;Shift the bit in BL to the right by 3 bits so that the operation is performed correctly
CALL MYNOT              ;Jump to the NOT subroutine to perform the operation
                        ;This result is stored in BH
                        
                        ;Perform an OR operation on the result of the first AND and NOT of bit 3
MOV BL, BH              ;Copy the result of the NOT operation on bit 3 into BL
MOV CL, AH              ;Copy the result of the AND operation on bit 2 and the result of the first NAND into CL
CALL MYOR               ;Jump to the OR subroutine to perform the operation
                        ;The result is stored in AH, overwriting the result of the first AND operation
                        
                        ;Perform an XOR operation on bits 4 and 5
MOV BL, AL              ;Copy the input bit into BL
MOV CL, AL              ;Copy the input bit into CL
AND BL, 00010000B       ;Mask off all of the bits except for bit 4
AND CL, 00100000B       ;Mask off all of the bits except for bit 5
SHR BL, 4               ;Shift the bit in BL to the right by 4 bits so that the operation is performed correctly
SHR CL, 5               ;Shift the bit in CL to the right by 5 bits so that the operation is performed correctly
CALL MYXOR              ;Jump to the XOR subroutine to perform the operation
                        ;The result is stored in BH, overwriting the result of the first NOT operation
                        
                        ;Perform a NAND operation on the results of the XOR and OR operations
MOV BL, BH              ;Copy the result of the XOR operation into BL
MOV CL, AH              ;Copy the result of the OR operation into CL
CALL MYNAND             ;Jump to the NAND subroutine to perform the operation
                        ;The result is stored in AH, overwriting the result of the OR operation
                        
                        ;Perform a NOR operation on bits 6 and 7
MOV BL, AL              ;Copy the input bit into BL
MOV CL, AL              ;Copy the input bit into CL
AND BL, 01000000B       ;Mask off all of the bits except for bit 6
AND CL, 10000000B       ;Mask off all of the bits except for bit 7
SHR BL, 6               ;Shift the bit in BL to the right by 6 bits so that the operation is performed correctly
SHR CL, 7               ;Shift the bit in CL to the right by 7 bits so that the operation is performed correctly
CALL MYNOR              ;Jump to the NOR suroutine to perform the operation
                        ;The result is stored in BH, overwriting the result of the XOR operation
                        
                        ;Perform a NOT operation on the result of the NOR operation on bits 6 and 7
MOV BL, BH              ;Copy the result of the NOR operation into BL
CALL MYNOT              ;Jump to the NOT subroutine to perform the operation
                        ;The result is stored in BH, overwriting the result of the previous NOR operation
                        
                        ;Perform the final NAND operation on the results of the previous NOT and NAND
MOV BL, BH              ;Copy the result of the previous NOT into BL
MOV CL, AH              ;Copy the result of the previous NAND into CL
CALL MYNAND             ;Jump to the NAND subroutine to perform the operation
                        ;The result is stored in AH. This is the final result which we want to print to the screen

MOV DL, AH              ;Print the result in AH to the screen
ADD DL, 30H             ;Add the ASCII bias
MOV AH, 02H
INT 21H

EXIT:                   ;Subroutine for exiting the program
    MOV AH, 4CH
    INT 21H
    
MYNAND:                 ;Subroutine for NAND operations
    AND BL, CL          ;AND the values in CL and BL, and store the result in BL
    NOT BL              ;NOT the result in BL
    AND BL, 00000001B   ;Mask off all of the bits except for bit 0
    
    MOV AH, BL          ;Store the final result into AH
    RET

MYXOR:                  ;Subroutine for XOR operations
    XOR BL, CL          ;XOR the values in CL and BL, and store the result in BL
    AND BL, 00000001B   ;Mask off all of the bits except for bit 0
    
    MOV BH, BL          ;Store the final result into BH
    RET

MYNOR:                  ;Suroutine for NOR operations
    OR BL, CL           ;OR the values in CL and BL, and store the result in BL
    NOT BL              ;NOT the result in BL
    AND BL, 00000001B   ;Mask off all of the bits except for bit 0
    
    MOV BH, BL          ;Store the final result into BH
    RET

MYAND:                  ;Subroutine for AND operations
    AND BL, CL          ;AND the values in CL and BL, and store the result in BL
    AND BL, 00000001B   ;Mask off all of the bits except for bit 0
    
    MOV AH, BL          ;Store the final result into AH
    RET
    
MYOR:                   ;Subroutine for OR operations
    OR BL, CL           ;OR the values in CL and BL, and store the result in BL
    AND BL, 00000001B   ;Mask off all of the bits except for bit 0
    
    MOV AH, BL          ;Store the final result into AH
    RET

MYNOT:                  ;Subroutine for NOT operations
    NOT BL              ;Not the value in BL, and store the result in BL
    AND BL, 00000001B   ;Mask off all of the bits except for bit 0
    
    MOV BH, BL          ;Store the final result in BH
    RET


END MAIN
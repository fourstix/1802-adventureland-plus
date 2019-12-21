;__________________________________________________________________________________________________
; Serial Input: 9600 baud, normal RS232 logic
; IN:       P=7
; OUT:      P=3, RF.1 = received character
; TRASHED:  R8

B96IN_Return
    SEP R3
B96IN
    ; Load the starting point for the LED animation
    LDI HIGH KnightRider
    PHI R8
    LDI LOW KnightRider
    PLO R8

B96StopBitLoop              ; Wait for the stop bit
    B3  B96StopBitLoop

    LDI $FF                 ; Initialize input character in RF.1 to $FF
    PHI RF

B96DrawLights
    LDA R8                  ; load next bit pattern in LED animation
    STR R2                  ; put it on the stack
    B3  B96FoundStartBit
    OUT 4                   ; output to LEDs
    DEC R2                  ; restore stack pointer to original value
    GLO R8                  ; load the low byte of the current bit pattern pointer
    SMI LOW KnightRider+44  ; is it at the end of the animation sequence?
    B3  B96FoundStartBit
    BNZ B96WaitStartBit     ; if not, go burn CPU cycles and wait for the start bit
    
    LDI LOW Rand_VarX       ; we have to reset the pointer, so begin by instead
    PLO R8
    LDI HIGH Rand_VarX      ; loading a pointer to the psuedo-random generator's X value
    B3 B96FoundStartBit
    PHI R8
    LDN R8
    ADI $01                 ; and incrementing this value in memory, to make the generator's
    STR R8                  ; values non-deterministic
    B3 B96FoundStartBit
    
    LDI LOW KnightRider     ; now re-load the bit pattern pointer
    PLO R8
    LDI HIGH KnightRider
    PHI R8
    B3  B96FoundStartBit

B96WaitStartBit
    LDI $00         ; animation inner loop counter

B96StartBitLoop
    NOP
    NOP
    B3  B96FoundStartBit
    SMI $01
    NOP
    NOP
    B3  B96FoundStartBit
    BNZ B96StartBitLoop
    BR  B96DrawLights

B96FoundStartBit
    LDI  $01        ; Set up D and DF, which takes about a quarter of a bit duration
    SHR
    BR   B96SkipDelay
    
B96StartDelay
    LDI $02
B96DelayLoop
    SMI $01
    BNZ B96DelayLoop
    ; When done with delay, D=0 and DF=1
    
B96SkipDelay        ; read current bit
    B3  B96IN4
    SKP             ; if BIT=0 (EF3 PIN HIGH), leave DF=1
B96IN4
    SHR             ; if BIT=1 (EF3 PIN LOW), set DF=0
    GHI RF          ; load incoming byte
    SHRC            ; shift new bit into MSB, and oldest bit into DF
    PHI RF
    LBDF B96StartDelay
    
    BR  B96IN_Return

;__________________________________________________________________________________________________
; Serial Input: 9600 baud, inverted RS232 logic
; IN:       P=7
; OUT:      P=3, RF.1 = received character
; TRASHED:  R8

Bi96IN_Return
    SEP R3
Bi96IN
    ; Load the starting point for the LED animation
    LDI HIGH KnightRider
    PHI R8
    LDI LOW KnightRider
    PLO R8

Bi96StopBitLoop              ; Wait for the stop bit
    BN3 Bi96StopBitLoop

    LDI $FF                 ; Initialize input character in RF.1 to $FF
    PHI RF

Bi96DrawLights
    LDA R8                  ; load next bit pattern in LED animation
    STR R2                  ; put it on the stack
    BN3 Bi96FoundStartBit
    OUT 4                   ; output to LEDs
    DEC R2                  ; restore stack pointer to original value
    GLO R8                  ; load the low byte of the current bit pattern pointer
    SMI LOW KnightRider+44  ; is it at the end of the animation sequence?
    BN3 Bi96FoundStartBit
    BNZ Bi96WaitStartBit    ; if not, go burn CPU cycles and wait for the start bit
    
    LDI LOW Rand_VarX       ; we have to reset the pointer, so begin by instead
    PLO R8
    LDI HIGH Rand_VarX      ; loading a pointer to the psuedo-random generator's X value
    BN3 Bi96FoundStartBit
    PHI R8
    LDN R8
    ADI $01                 ; and incrementing this value in memory, to make the generator's
    STR R8                  ; values non-deterministic
    BN3 Bi96FoundStartBit
    
    LDI LOW KnightRider     ; now re-load the bit pattern pointer
    PLO R8
    LDI HIGH KnightRider
    PHI R8
    BN3 Bi96FoundStartBit

Bi96WaitStartBit
    LDI $00         ; animation inner loop counter

Bi96StartBitLoop
    NOP
    NOP
    BN3 Bi96FoundStartBit
    SMI $01
    NOP
    NOP
    BN3 Bi96FoundStartBit
    BNZ Bi96StartBitLoop
    BR  Bi96DrawLights

Bi96FoundStartBit
    LDI  $01        ; Set up D and DF, which takes about a quarter of a bit duration
    SHR
    BR   Bi96SkipDelay
    
Bi96StartDelay
    LDI $02
Bi96DelayLoop
    SMI $01
    BNZ Bi96DelayLoop
    ; When done with delay, D=0 and DF=1
    
Bi96SkipDelay       ; read current bit
    BN3 Bi96IN4
    SKP             ; if BIT=0 (EF3 PIN HIGH), leave DF=1
Bi96IN4
    SHR             ; if BIT=1 (EF3 PIN LOW), set DF=0
    GHI RF          ; load incoming byte
    SHRC            ; shift new bit into MSB, and oldest bit into DF
    PHI RF
    LBDF Bi96StartDelay
    
    BR  Bi96IN_Return

;__________________________________________________________________________________________________
; Serial Output: 9600 baud, normal RS232 logic
; IN:       P=7, D = character to transmit, R2 is stack pointer
; OUT:      P=3
; TRASHED:  RF

B96OUT_Return
    SEP R3
B96OUT
    PHI RF          ; save output character in RF.1
    STR R2
    SEX R2
    OUT 4           ; set LEDs to output character
    DEC R2
    
    LDI 08H         ; RF.0 is data bit counter
    PLO RF

STBIT96             ; Send Start Bit (Space)
    SEQ             ;  2
    NOP             ;  5
    NOP             ;  8
    GHI RF          ; 10
    SHRC            ; 12 DF = 1st bit to transmit
    PHI RF          ; 14
    PHI RF          ; 16
    NOP             ; 19 
    BDF STBIT96_1   ; 21 First bit = 1?
    BR  QHI96       ; 23 bit = 0, output Space
STBIT96_1
    BR  QLO96       ; 23 bit = 1, output Mark

QHI96_1
    DEC RF
    GLO RF
    BZ  DONE96      ;AT 8.5 INSTRUCTIONS EITHER DONE OR REQ

;DELAY
    NOP
    NOP

QHI96
    SEQ             ; Q ON
    GHI RF
    SHRC            ; PUT NEXT BIT IN DF
    PHI RF
    LBNF    QHI96_1 ; 5.5 TURN Q OFF AFTER 6 MORE INSTRUCTION TIMES

QLO96_1
    DEC RF
    GLO RF
    BZ  DONE96      ; AT 8.5 INSTRUCTIONS EITHER DONE OR SEQ

;DELAY
    NOP
    NOP

QLO96
    REQ             ;Q OFF
    GHI RF
    SHRC            ;PUT NEXT BIT IN DF
    PHI RF
    LBDF QLO96_1    ;5.5 TURN Q ON AFTER 6 MORE INSTRUCTION TIMES

    DEC RF
    GLO RF
    BZ  DONE96      ;AT 8.5 INSTRUCTIONS EITHER DONE OR REQ

;DELAY
    NOP
    LBR QHI96

DONE96              ;FINISH LAST BIT TIMING
    NOP
    NOP

DNE961
    REQ             ; Send stop bit: Q=0

    BR B96OUT_Return

;__________________________________________________________________________________________________
; Serial I/O hooks

; Customized serial input routine
; IN:       P=7
; OUT:      P=3, RF.1 = received character
; TRASHED:  R8
SerialInput
    LBR  0000

; Customized serial output routine
; IN:       P=7, D = character to transmit, R2 is stack pointer
; OUT:      P=3
; TRASHED:  RF
SerialOutput
    LBR  0000

;__________________________________________________________________________________________________
; Serial Input: 4800 or lower baud, normal RS232 logic
; IN:       P=7
; OUT:      P=3, RF.1 = received character
; TRASHED:  R8

B48IN_Return
    SEP R3
B48IN
    GHI RD                          ; GET RD.1
    STR R2                          ; PUSH RD.1 ON THE STACK
    DEC R2
    GLO RD                          ; GET RD.0
    STR R2
    DEC R2                          ; PUSH RD.0 ON THE STACK
    LDI 08H                         ; LOAD D WITH TOTAL BIT COUNT
    PLO RD                          ; LOAD RD.0 WITH BIT COUNT
B48IBaud
    LDI 00H
    PHI RD                          ; LOAD RD.1 WITH Baud rate counter

    ; Load the starting point for the LED animation
    LDI HIGH KnightRider
    PHI R8
    LDI LOW KnightRider
    PLO R8

B48StopBitLoop                      ; Wait for the stop bit
    B3  B48StopBitLoop

B48DrawLights
    LDA R8                          ; load next bit pattern in LED animation
    STR R2                          ; put it on the stack
    OUT 4                           ; output to LEDs
    DEC R2                          ; restore stack pointer to original value
B48CheckStart1
    B3  B48FoundStartBit
    GLO R8                          ; load the low byte of the current bit pattern pointer
    SMI LOW KnightRider+44          ; is it at the end of the animation sequence?
    BNZ B48WaitStartBit             ; if not, go burn CPU cycles and wait for the start bit

    LDI LOW Rand_VarX               ; we have to reset the pointer, so begin by instead
    PLO R8
    LDI HIGH Rand_VarX              ; loading a pointer to the psuedo-random generator's X value
    PHI R8
    LDN R8
    ADI $01                         ; and incrementing this value in memory, to make the generator's
    STR R8                          ; values non-deterministic
B48CheckStart2
    B3 B48FoundStartBit

    LDI LOW KnightRider             ; now re-load the bit pattern pointer
    PLO R8
    LDI HIGH KnightRider
    PHI R8

B48WaitStartBit
    LDI $00         ; animation inner loop counter

B48StartBitLoop
    SMI $01
    NOP
    NOP
B48CheckStart3
    B3  B48FoundStartBit
    NOP
    NOP
    BNZ B48StartBitLoop
    BR  B48DrawLights

B48FoundStartBit
    GHI RD
    SHR
    SHR
    SMI 01H
B48ILoop2                           ; WAIT .25 BIT TIME
    SMI 01H
    BNZ B48ILoop2

    GHI RD
B48ILoop3
    SMI 01H
    BNZ B48ILoop3                   ; WAIT 1 BIT TIME

B48ILoop4
    GHI RF                          ; GET INCOMING FORMING CHARACRTER SO FAR
    B3  B48ILoop4Next1              ; CHECK INCOMING BIT VALUE
    ORI 80H                         ; IF INCOMING BIT WAS A MARK THEN SET BIT 8 OF INCOMING CHARACTER VALUE
    BR  B48ILoop4Next2
B48ILoop4Next1
    ANI 7FH                         ; CLEAR INCOMING BIT
    SEX R2                          ; WASTE ONE MACHINE CYCLE
B48ILoop4Next2
    PHI RF                          ; SAVE INCOMING FORMING CHARACTER
    DEC RD                          ; DECREMENT THE BIT COUNT VALUE
    GLO RD                          ; GET CURRENT BIT COUNT VALUE
    BZ  B48ILoop4Done               ; DONE IF BIT COUNT IS ZERO
    GHI RF                          ; GET INCOMING FORMING CHARACTER
    SHR                             ; SHIFT INCOMING FORMING CHARACTER ONE BIT RIGHT
    PHI RF                          ; SAVE IT, INCOMING FORMING CHARACTER IS READY FOR THE NEXT BIT

    ; WAIT UNTIL THIS BIT TIME IS DONE
    GHI RD
    NOP                             ; WASTE THREE MACHINE CYCLES
    SMI 07H                         ; CORRECTION FOR BYTES USED
B48ILoop4_1
    SMI 01H
    BNZ B48ILoop4_1
    BR  B48ILoop4

B48ILoop4Done
    INC R2                          ; INCREMENT STACK POINTER
    LDN R2                          ; LOAD D FROM STACK
    PLO RD                          ; STORE IN RD.0
    INC R2                          ; INCREMENT STACK POINTER
    LDN R2                          ; LOAD D FROM STACK
    PHI RD                          ; STORE IN RD.1 , STACK AND RD RESTORED

    BR  B48IN_Return                ; RETURN

;__________________________________________________________________________________________________
; Serial Output: 4800 or lower baud, normal RS232 logic
; IN:       P=7, D = character to transmit, R2 is stack pointer
; OUT:      P=3
; TRASHED:  RF

B48OUT_Return
    SEP R3
B48OUT
    PHI RF                          ; save output character in RF.1
    STR R2
    SEX R2
    OUT 4                           ; set LEDs to output character
    DEC R2

    GHI RD                          ; GET RD.1
    STXD                            ; PUSH RD.1 ON THE STACK
B48OBaud
    LDI 00H
    PHI RD                          ; STORE BAUD COUNTER IN RD.1

    LDI 80H                         ; LOAD D WITH 80H
    PLO RF                          ; SAVE BIT COUNTER IN RF.0

    GHI RD                          ; WAIT 1 BIT TIME MINUS 8 MACHINE CYCLES
    SMI $02
B48OStartBit
    SEQ                             ; SET Q, OUTPUT START BIT , RS-232 MARK

B48OLoop1
    SMI 01H
    BNZ B48OLoop1

    GHI RF                          ; GET CHARACTER TO OUTPUT
    SHR                             ; SHIFT CHARACTER ONE BIT RIGHT , DF EQUAL BIT TO OUTPUT
    BDF B48ODataSpace               ; SKIP IF BIT TO SEND IS A RS-232 SPACE
B48ODataMark
    SEQ                             ; SET Q, BIT TO SEND IS A RS-232 MARK
    BR  B48OLoop1Next1              ; SKIP
B48ODataSpace
    REQ                             ; RESET Q, BIT TO SEND IS A RS-232 SPACE
    SEX R2                          ; WASTE TWO MACHINE CYCLES
B48OLoop1Next1
    PHI RF                          ; SAVE CHARACTER
    GLO RF                          ; LOAD D WITH RF.0, GET BIT COUNTER
    SHR                             ; SHIFT BIT COUNTER VALUE ONE BIT RIGHT
    PLO RF                          ; SAVE NEW BIT COUNTER VALUE
    BZ  B48OLoop1Done               ; DONE

    GHI RD                          ; WAIT 1 BIT TIME
    SMI 07H                         ; CORRECTION FOR BYTES USED
    SEX R2                          ; WASTE TWO MACHINE CYCLES
    NOP                             ; WASTE THREE MACHINE CYCLES
    BR  B48OLoop1                   ; CONTINUE UNTIL DONE

B48OLoop1Done
    GHI RD                          ; FINISH THE DELAY OF X MACHINE CYCLES
    SMI 04H
B48OLoop2
    SMI 01H
    BNZ B48OLoop2
B48OStopBit
    REQ                             ; RESET Q , RESET THE RS-232 OUTPUT TO A RS-232 MARK
                                    ; START SENDING A STOP BIT

    GHI RD                          ; WAIT 1 BIT TIME
B48OLoop3
    SMI 01H
    BPZ B48OLoop3

    INC R2                          ; INCREMENT STACK POINTER
    LDN R2                          ; LOAD D FROM STACK
    PHI RD                          ; STORE IN RD.1, STACK AND RD RESTORED

    BR  B48OUT_Return

;__________________________________________________________________________________________________
; String print routine

; IN:       R8 = pointer to null-terminated string
; OUT:      N/A
; TRASHED:  R7, R8, RF

OutString
    LDI  HIGH SerialOutput
    PHI  R7
    LDI  LOW SerialOutput
    PLO  R7

OutStrLoop1
    LDA  R8
    BZ   OutStrDone
    SEP  R7
    BR   OutStrLoop1

OutStrDone
    SEP  R5

;__________________________________________________________________________________________________
; Print a 2-digit number

; IN:       D = number to print, R8 = pointer to start of string
; OUT:      N/A
; TRASHED:  D, R7

Print2Digit
    PHI  R7                         ; save number to print
    LDI  $00
    PLO  R7
    GHI  R7
P2D_Tens
    SMI  10
    BL   P2D_TensDone
    INC  R7
    BR   P2D_Tens
P2D_TensDone
    ADI  10                         ; D is now number of singles
    PHI  R7
    GLO  R7
    LSNZ                            ; if there are no tens, 
    LDI  ' '-'0'                    ; use space as filler char.
    ADI  '0'
    STR  R8                         ; store the tens digit
    INC  R8
    LDI  $30                        ; ASCII 0
    PLO  R7
    GHI  R7
P2D_Ones
    SMI  1
    BL   P2D_OnesDone
    INC  R7
    BR   P2D_Ones
P2D_OnesDone
    GLO  R7
    STR  R8
    DEC  R8
    SEP  R5

;__________________________________________________________________________________________________
; Clear screen

; IN:       N/A
; OUT:      N/A
; TRASHED:  R7, R8, RF

ClearScreen
    LDI  HIGH ClsMsg
    PHI  R8
    LDI  LOW ClsMsg
    PLO  R8
    
    SEP  R4
    DW   OutString
    SEP  R5

;__________________________________________________________________________________________________
; Generate a psuedo-random byte

; IN:       N/A
; OUT:      D=psuedo-random number
; TRASHED:  R7

GenRandom
    LDI  LOW Rand_VarX
    PLO  R7
    LDI  HIGH Rand_VarX
    PHI  R7
    SEX  R7

    LDN  R7         ; D = VarX
    ADI  $01
    STR  R7
    INC  R7
    LDA  R7         ; D = VarA
    INC  R7
    XOR             ; D = VarA XOR VarC
    DEC  R7
    DEC  R7
    DEC  R7
    XOR             ; D = VarA XOR VarC XOR VarX
    INC  R7
    STR  R7         ; VarA = D
    INC  R7
    ADD
    STXD
    SHR
    XOR
    INC  R7
    INC  R7
    ADD
    STR  R7

    SEP  R5    

;__________________________________________________________________________________________________
; Restore internal variables to starting state

; IN:       N/A
; OUT:      N/A
; TRASHED:  R7, R8, R9

GameReset
    LDI  LOW Array_I2               ; start by initializing item locations
    PLO  R8
    LDI  HIGH Array_I2
    PHI  R8
    LDI  LOW Array_IA
    PLO  R9
    LDI  HIGH Array_IA
    PHI  R9
    LDI  IL
    PLO  R7
GRLoop1
    LDA  R8
    STR  R9
    INC  R9
    DEC  R7
    GLO  R7
    BNZ  GRLoop1
    INC  R9
    INC  R9
    LDI  $00
    STR  R9                         ; Loadflag = 0
    INC  R9
    STR  R9                         ; Endflag = 0
    INC  R9
    STR  R9                         ; Darkflag = 0
    LDI  AR
    INC  R9
    STR  R9                         ; Room = AR
    LDI  LI
    INC  R9
    STR  R9                         ; lamp_oil = LT
    LDI  $00
    INC  R9
    STR  R9
    INC  R9
    STR  R9                         ; state_flags = 0
    SEP  R5

;__________________________________________________________________________________________________
; Main program starting point

GameStart
    ; The first thing we need to do is to configure our Serial I/O routines to work with the current settings
    LDI HIGH BAUD
    PHI R7
    LDI LOW BAUD
    PLO R7
    LDA R7
    PHI RE
    LDN R7
    PLO RE
    SMI $02
    BNZ Is4800orLess
    ; set up our serial i/o pointers to use 9600 baud normal logic
    LDI  HIGH SerialInput+1
    PHI  R8
    LDI  LOW SerialInput+1
    PLO  R8
    LDI  HIGH B96IN
    STR  R8
    INC  R8
    LDI  LOW B96IN
    STR  R8
    INC  R8
    INC  R8
    LDI  HIGH B96OUT
    STR  R8
    INC  R8
    LDI  LOW B96OUT
    STR  R8
    ; if RS232 logic level is inverted, set up serial input pointer to use 9600 baud inveted logic 
    GHI  RE
    ANI  $01
    BNZ  BaudHandled
    DEC  R8
    DEC  R8
    DEC  R8
    LDI  LOW Bi96IN
    STR  R8
    DEC  R8
    LDI  HIGH Bi96IN
    STR  R8
    BR   BaudHandled
Is4800orLess
    ; set up our serial i/o pointers to use 4800 baud normal logic
    LDI  HIGH SerialInput+1
    PHI  R8
    LDI  LOW SerialInput+1
    PLO  R8
    LDI  HIGH B48IN
    STR  R8
    INC  R8
    LDI  LOW B48IN
    STR  R8
    INC  R8
    INC  R8
    LDI  HIGH B48OUT
    STR  R8
    INC  R8
    LDI  LOW B48OUT
    STR  R8
    ; use SMC (self-modifying code) to set the timers in 4800 baud output routine
    LDI  HIGH B48OBaud+1
    PHI  R8
    LDI  LOW B48OBaud+1
    PLO  R8
    GLO  RE
    STR  R8
    ; use SMC to set the timers in 4800 baud input routine
    LDI  HIGH B48IBaud+1
    PHI  R8
    LDI  LOW B48IBaud+1
    PLO  R8
    GLO  RE
    STR  R8
BaudHandled
    GHI  RE
    ANI  $01
    LBNZ LogicHandled
    ; use SMC to modify the 9600 baud output routine to use inverted logic
    LDI  HIGH STBIT96
    PHI  R8
    LDI  LOW STBIT96
    PLO  R8
    LDI  $7A                        ; REQ
    STR  R8
    LDI  HIGH QHI96
    PHI  R8
    LDI  LOW QHI96
    PLO  R8
    LDI  $7A                        ; REQ
    STR  R8
    LDI  HIGH QLO96
    PHI  R8
    LDI  LOW QLO96
    PLO  R8
    LDI  $7B                        ; SEQ
    STR  R8
    LDI  HIGH DNE961
    PHI  R8
    LDI  LOW DNE961
    PLO  R8
    LDI  $7B                        ; SEQ
    STR  R8
    ; use SMC to modify the 4800 baud output routine to use inverted logic
    LDI  HIGH B48OStartBit
    PHI  R8
    LDI  LOW B48OStartBit
    PLO  R8
    LDI  $7A                        ; REQ
    STR  R8
    LDI  HIGH B48ODataMark
    PHI  R8
    LDI  LOW B48ODataMark
    PLO  R8
    LDI  $7A                        ; REQ
    STR  R8
    LDI  HIGH B48ODataSpace
    PHI  R8
    LDI  LOW B48ODataSpace
    PLO  R8
    LDI  $7B                        ; SEQ
    STR  R8
    LDI  HIGH B48OStopBit
    PHI  R8
    LDI  LOW B48OStopBit
    PLO  R8
    LDI  $7B                        ; SEQ
    STR  R8
    ; use SMC to modify the 4800 baud input routine to use inverted logic
    LDI  HIGH B48StopBitLoop
    PHI  R8
    LDI  LOW B48StopBitLoop
    PLO  R8
    LDI  $3E                        ; BN3
    STR  R8
    LDI  HIGH B48CheckStart1
    PHI  R8
    LDI  LOW B48CheckStart1
    PLO  R8
    LDI  $3E                        ; BN3
    STR  R8
    LDI  HIGH B48CheckStart2
    PHI  R8
    LDI  LOW B48CheckStart2
    PLO  R8
    LDI  $3E                        ; BN3
    STR  R8
    LDI  HIGH B48CheckStart3
    PHI  R8
    LDI  LOW B48CheckStart3
    PLO  R8
    LDI  $3E                        ; BN3
    STR  R8
    LDI  HIGH B48ILoop4+1
    PHI  R8
    LDI  LOW B48ILoop4+1
    PLO  R8
    LDI  $3E                        ; BN3
    STR  R8
LogicHandled
    BR   Do_Main

Exit
    LDI $8B
    PHI R0
    LDI $5E
    PLO R0
    SEX R0
    SEP R0                          ; jump back to the monitor program

Do_Main
    ; beginning of main() function
    ; clear screen
    SEP  R4
    DW   ClearScreen

    ; Print welcome message
    LDI  HIGH StartingMsg
    PHI  R8
    LDI  LOW StartingMsg
    PLO  R8
    SEP  R4
    DW   OutString

    ; wait for key press
    LDI HIGH SerialInput
    PHI R7
    LDI LOW SerialInput
    PLO R7
    SEP R7
    
    ; clear screen
    SEP  R4
    DW   ClearScreen

    ; start of main loop
MainLoad
    ; reset all game state
    SEP  R4
    DW   GameReset
    ; load game if possible
    SEP  R4
    DW   Do_LoadGame
    ; clear screen
    SEP  R4
    DW   ClearScreen
    ; look()
    SEP  R4
    DW   Do_Look
    ; NV[0] = 0
    LDI  LOW Array_NV
    PLO  R9
    LDI  HIGH Array_NV
    PHI  R9
    LDI  $00
    STR  R9
    ; turn()
    SEP  R4
    DW   Do_Turn
MainGetInput
    ; get_input()
    SEP  R4
    DW   Do_GetInput
    ; if command parsing failed, try again
    BNZ  MainGetInput
    ; turn()
    SEP  R4
    DW   Do_Turn
    ; reload R9 to point to Endflag
    LDI  LOW Endflag
    PLO  R9
    LDI  HIGH Endflag
    PHI  R9
    LDN  R9
    BNZ  Exit                       ; quit if endflag != 0
    DEC  R9
    LDN  R9
    BNZ  MainLoad                   ; loop back and re-load if loadflag != 0
    ; deal with lamp oil
    LDI  LOW (Array_IA+9)
    PLO  RA
    LDI  HIGH (Array_IA+9)
    PHI  RA
    LDN  RA
    SMI  $FF
    BNZ  MainNoLamp
    LDI  LOW LampOil
    PLO  R9
    LDI  HIGH LampOil
    PHI  R9
    LDN  R9
    SMI  $01
    STR  R9                         ; lamp_oil--
    BPZ  LampNotEmpty
    LDI  HIGH LampEmptyMsg          ; print Lamp is Empty message
    PHI  R8
    LDI  LOW LampEmptyMsg
    PLO  R8
    SEP  R4
    DW   OutString
    LDI  $00
    STR  RA                         ; IA[9] = 0
    BR   MainNoLamp
LampNotEmpty
    SMI  25                         ; is our oil level < 25?
    BPZ  MainNoLamp
    LDI  HIGH LampLow1Msg           ; print Lamp is low message
    PHI  R8
    LDI  LOW LampLow1Msg
    PLO  R8
    SEP  R4
    DW   OutString
    LDI  HIGH PrintNumber
    PHI  R8
    LDI  LOW PrintNumber
    PLO  R8
    LDN  R9                         ; D = lamp_oil
    SEP  R4
    DW   Print2Digit
    SEP  R4
    DW   OutString
    LDI  HIGH LampLow2Msg
    PHI  R8
    LDI  LOW LampLow2Msg
    PLO  R8
    SEP  R4
    DW   OutString
MainNoLamp
    ; NV[0] = 0
    LDI  LOW Array_NV
    PLO  R9
    LDI  HIGH Array_NV
    PHI  R9
    LDI  $00
    STR  R9
    ; turn()
    SEP  R4
    DW   Do_Turn
MainLoopTail
    ; reload R9 to point to Endflag
    LDI  LOW Endflag
    PLO  R9
    LDI  HIGH Endflag
    PHI  R9
    LDN  R9
    BNZ  Exit                      ; if endflag != 0, quit
    DEC  R9
    LDN  R9
    BNZ  MainLoad                  ; if loadflag != 0, loop back and re-load
    BR   MainGetInput              ; otherwise, get next command

;__________________________________________________________________________________________________
; Adventure get_input() function

; IN:       N/A
; OUT:      D = return value (1 if failed, 0 if command OK)
; TRASHED:  R7, R8, R9, RA, RB, RC, RD, RF

Do_GetInput
    ; print input prompt
    LDI  HIGH InputPromptMsg
    PHI  R8
    LDI  LOW InputPromptMsg
    PLO  R8
    SEP  R4
    DW   OutString
    ; now we are in the gets() function. set up loop variables
    LDI  $00
    PLO  RA                         ; RA.0 is character counter; only 79 are allowed
    LDI  HIGH Array_TPS
    PHI  R9
    LDI  LOW Array_TPS
    PLO  R9                         ; R9 is pointer to input line
GILoop1
    ; wait for key press
    LDI  HIGH SerialInput
    PHI  R7
    LDI  LOW SerialInput
    PLO  R7
    SEP  R7
    ; load R7 to point to serial output routine in case I need to print. this saves code space
    LDI  HIGH SerialOutput
    PHI  R7
    LDI  LOW SerialOutput
    PLO  R7
    ; handle backspace
    GHI  RF
    SMI  $8
    BZ   GIBackspace
    GHI  RF
    SMI  $7F
    BNZ  GILoop1N1
GIBackspace
    GLO  RA                         ; if line length is 0
    BZ   GILoop1                    ; then just go back for another input character
    LDI  $08                        ; otherwise, erase last character
    SEP  R7
    LDI  $20                        ; ' '
    SEP  R7
    LDI  $08                        ; '\b'
    SEP  R7
    DEC  RA                         ; decrement character count
    DEC  R9                         ; decrement input line pointer
    BR   GILoop1                    ; and then go back for another input character
GILoop1N1
    ; handle enter or return
    GHI  RF
    SMI  $0A
    BZ   GIEnter
    GHI  RF
    SMI  $0D
    BNZ  GILoop1N2
GIEnter
    LDI  '\r'                       ; '\n'
    SEP  R7
    LDI  '\n'                       ; '\n'
    SEP  R7
    BR   GIgetsDone
GILoop1N2
    ; ensure that input character is valid
    GHI  RF
    SMI  $20
    BZ   GICharOk
    GHI  RF
    SMI  $41
    BL   GIJumpLoop1
    GHI  RF
    SMI  $5B
    BL   GICharOk
    GHI  RF
    SMI  $61
    BL   GIJumpLoop1
    GHI  RF
    SMI  $7B
    BL   GICharOk
GIJumpLoop1
    LBR  GILoop1
GICharOk
    GHI  RF
    STR  R9                         ; add input character to our string
    INC  R9
    INC  RA                         ; increment string length counter
    SEP  R7                         ; echo character to serial output
    GLO  RA                         ; how long is the input line?
    SMI  79
    BL   GIJumpLoop1                ; if < 79 characters, go get another
GIgetsDone
    LDI  $00                        ; null-terminate input string
    STR  R9
    LDI  HIGH Array_TPS
    PHI  R9
    LDI  LOW Array_TPS
    PLO  R9                         ; reload R9 to point to beginning of input string
    ; now we are back in the get_input() function.
    ; If the line is empty, go prompt for another command
    LDN  R9
    LBZ  Do_GetInput
    ; otherwise, start parsing. begin by skipping any leading spaces
GIParseLoop1
    LDA  R9
    BZ   GIParseLoop1Done
    SMI  $20                        ; ' '
    BZ   GIParseLoop1
GIParseLoop1Done
    DEC  R9
    ; store pointer to first word in RA
    GLO  R9
    PLO  RA
    GHI  R9
    PHI  RA
    ; convert entire string to uppercase
GIParseLoop2
    LDA  R9
    BZ   GIParseLoop2Done
    SMI  $61
    BL   GIParseLoop2
    ADI  $41
    DEC  R9
    STR  R9
    INC  R9
    BR   GIParseLoop2
GIParseLoop2Done
    ; reload pointer to start of first word, and find the end (the next space)
    GLO  RA
    PLO  R9
    GHI  RA
    PHI  R9
GIParseLoop3
    LDA  R9
    BZ   GIParseLoop3Done
    SMI  $20                        ; ' '
    BNZ  GIParseLoop3
GIParseLoop3Done
    ; if we found a space, NULL-terminate the first word
    DEC  R9
    LDN  R9
    BZ   GIParseLoop4
    LDI  $00
    STR  R9
    INC  R9
    ; skip any additional spaces in between words
GIParseLoop4
    LDA  R9
    SMI  $20                        ; ' '
    BZ   GIParseLoop4
    DEC  R9
    ; store pointer to second word in RB
    GLO  R9
    PLO  RB
    GHI  R9
    PHI  RB
    ; find matches for both words
    LDI  LOW Array_NV               ; RC = pointer to NV[2]
    PLO  RC
    LDI  HIGH Array_NV
    PHI  RC
    LDI  LOW Array_NVS              ; RD = pointer to NVS[2][NL][4], NL=60
    PLO  RD
    LDI  HIGH Array_NVS
    PHI  RD
    LDI  $00
    PHI  RF                         ; RF.1 = i, for (i = 0; i < 2; i++)
    GLO  RA                         ; load pointer to first word in R9
    PLO  R9
    GHI  RA
    PHI  R9
GIParseLoop5
    LDI  $00
    STR  RC                         ; NV[i] = 0
    LDN  R9
    BZ   GIParseLoop5Tail
    LDI  $00
    PLO  RF                         ; RF.0 = j, for (j = 0; j < NL; j++)
GIParseLoop5_1
    GLO  RD
    PLO  R8
    GHI  RD
    PHI  R8                         ; R8 = s = NVS[i][j]
    LDN  R8
    SMI  '*'                        ; if first character of word is '*'
    BNZ  GIParseLoop5_1Next1
    INC  R8                         ; then skip it
GIParseLoop5_1Next1
    ; comparestring()
    SEX  R8
    LDA  R9                         ; Load 1st character in input word
    BZ   GIParseLoop5_1WordEnd
    SM                              ; compare to 1st character in table word
    BNZ  GIParseLoop5_1NoMatch
    INC  R8
    LDA  R9                         ; Load 2nd character in input word
    BZ   GIParseLoop5_1WordEnd
    SM                              ; compare to 2nd character in table word
    BNZ  GIParseLoop5_1NoMatch
    INC  R8
    LDA  R9                         ; Load 3rd character in input word
    BZ   GIParseLoop5_1WordEnd
    SM                              ; compare to 3rd character in table word
    BNZ  GIParseLoop5_1NoMatch
    SKP                             ; fall through to GIParseLoop5_1Match
GIParseLoop5_1WordEnd
    LDN  R8
    BNZ  GIParseLoop5_1NoMatch
GIParseLoop5_1Match
    GLO  RF
    STR  RC                         ; NV[i] = j
    GLO  RD
    PLO  R8
    GHI  RD
    PHI  R8                         ; R8 = NVS[i][j]
GIParseLoop5_1_1                    ; while (NVS[i][NV[i]][0] == '*') NV[i]--;
    LDN  R8
    SMI  '*'
    BNZ  GIParseLoop5Tail
    LDN  RC
    SMI  $01
    STR  RC                         ; NV[i]--
    DEC  R8
    DEC  R8
    DEC  R8
    DEC  R8
    BR   GIParseLoop5_1_1
GIParseLoop5_1NoMatch
    SEX  R2
    INC  RD
    INC  RD
    INC  RD
    INC  RD                         ; move word table pointer to next word
    GHI  RF                         ; test i variable
    BNZ  GIParseLoop5_1Next2
    GLO  RA                         ; reload pointer to first word in R9
    PLO  R9
    GHI  RA
    PHI  R9
    BR   GIParseLoop5_1Next3
GIParseLoop5_1Next2
    GLO  RB                         ; reload pointer to second word in R9
    PLO  R9
    GHI  RB
    PHI  R9
GIParseLoop5_1Next3
    INC  RF
    GLO  RF
    SMI  NL                         ; NL = 60
    BNF  GIParseLoop5_1            ; go check the next word in the table
GIParseLoop5Tail
    INC  RC                         ; point to next element in NV array
    GLO  RB                         ; load pointer to second word in R9
    PLO  R9
    GHI  RB
    PHI  R9
    LDI  LOW (Array_NVS+NL*4)       ; RD = pointer to second half of NVS[2][NL][4], NL=60
    PLO  RD
    LDI  HIGH (Array_NVS+NL*4)
    PHI  RD
    GHI  RF
    ADI  $1                         ; i++
    PHI  RF
    SMI  $2
    BNF  GIParseLoop5               ; branch if less
    ; validate first word (verb)
    DEC  RC
    DEC  RC
    LDA  RC
    LBNZ GIParseVerbOk
    LDI  HIGH InputError1Msg
    PHI  R8
    LDI  LOW InputError1Msg
    PLO  R8
    SEP  R4
    DW   OutString                  ; print "I don't know how to "
    GLO  RA
    PLO  R8
    GHI  RA
    PHI  R8
    SEP  R4
    DW   OutString                  ; print first word
    LDI  HIGH InputError2Msg
    PHI  R8
    LDI  LOW InputError2Msg
    PLO  R8
    SEP  R4
    DW   OutString                  ; print '!\r\n'
    LDI  $01
    SEP  R5                         ; return 1
GIParseVerbOk
    ; validate second word (noun)
    LDN  RB                         ; D is word[0][0]
    BZ   GIParseAllGood
    LDN  RC                         ; D is NV[1]
    BNZ  GIParseAllGood
    LDI  HIGH InputError3Msg
    PHI  R8
    LDI  LOW InputError3Msg
    PLO  R8
    SEP  R4
    DW   OutString                  ; print "I don't know what a "
    GLO  RB
    PLO  R8
    GHI  RB
    PHI  R8
    SEP  R4
    DW   OutString                  ; print second word
    LDI  HIGH InputError4Msg
    PHI  R8
    LDI  LOW InputError4Msg
    PLO  R8
    SEP  R4
    DW   OutString                  ; print " is!\n"
    LDI  $01
    SEP  R5                         ; return 1
GIParseAllGood
    LDI  $00
    SEP  R5                         ; return 0

;__________________________________________________________________________________________________
; LoadGame function to restore game state from upper memory, if the user wishes

; IN:       N/A
; OUT:      N/A
; TRASHED:  R7, R8, RC, RD, RF

Do_LoadGame
    LDI  LOW LoadQestion
    PLO  R8
    LDI  HIGH LoadQestion
    PHI  R8
    SEP  R4
    DW   OutString                  ; print "Load saved game (Y or N)?"
    SEP  R4
    DW   Do_YesNo                   ; D = 0 if No, 1 if Yes
    BNZ  LGNext1
    SEP  R5                         ; return
LGNext1
    LDI  LOW STATE_LOC
    PLO  R7
    ADI  STATE_SIZE
    PLO  R8
    LDI  HIGH STATE_LOC
    PHI  R7                         ; R7 points to state data buffer in upper RAM
    PHI  R8                         ; R8 points to checksum bytes after data buffer
    LDA  R8
    PLO  RD                         ; RD.0 = sum value
    LDN  R8
    PHI  RD                         ; RD.1 = xor value
    LDI  STATE_SIZE
    PLO  RC                         ; RC is checksum counter
    SEX  R7
LGLoop1                             ; inverse calculate checksum values
    GLO  RD
    SM
    PLO  RD
    GHI  RD
    XOR
    PHI  RD
    IRX
    DEC  RC
    GLO  RC
    BNZ  LGLoop1
    GLO  RD                         ; validate checksum
    SMI  $4B
    BNZ  LGLoadFail
    GHI  RD
    XRI  $4B
    BZ   LGNext2
LGLoadFail
    LDI  LOW LoadFailedMsg
    PLO  R8
    LDI  HIGH LoadFailedMsg
    PHI  R8
    SEP  R4
    DW   OutString                  ; print "Sorry, but no saved game data was found."
    LDI  HIGH SerialInput
    PHI  R7
    LDI  LOW SerialInput
    PLO  R7
    SEP  R7                         ; wait for key press
    SEP  R5                         ; return
LGNext2
    GLO  R7
    SMI  STATE_SIZE
    PLO  R7                         ; R7 is reset to start of state data buffer
    LDI  LOW Array_IA
    PLO  R8
    LDI  HIGH Array_IA
    PHI  R8                         ; R8 points to start of IA array
    LDI  IL
    PLO  RC
LGLoop2                             ; store the IA array (item locations)
    LDA  R7
    STR  R8
    INC  R8
    DEC  RC
    GLO  RC
    BNZ  LGLoop2
    INC  R8
    INC  R8
    INC  R8
    INC  R8                         ; R8 points to DarkFlag
    LDA  R7
    STR  R8                         ; store DarkFlag
    INC  R8
    LDA  R7
    STR  R8                         ; store Room
    INC  R8
    LDA  R7
    STR  R8                         ; store LampOil
    INC  R8
    LDA  R7
    STR  R8                         ; store StateFlags
    SEP  R5                         ; return

;__________________________________________________________________________________________________
; Adventure look() function

; IN:       N/A
; OUT:      N/A
; TRASHED:  R7, R8, R9, RA, RB, RC, RF

Do_Look
    LDI  LOW Darkflag
    PLO  R9
    LDI  HIGH Darkflag
    PHI  R9
    LDA  R9                         ; D == is_dark
    BZ   LKNotDark
    SEX  R9                         ; R9 is pointing to 'room'
    LDI  LOW (Array_IA+9)
    PLO  RA
    LDI  HIGH (Array_IA+9)
    PHI  RA
    LDN  RA
    SHL
    BDF  LKNotDark
    SHR
    SM
    BZ   LKNotDark
    ; it's dark. print a message and return
    LDI  HIGH Look1Msg
    PHI  R8
    LDI  LOW Look1Msg
    PLO  R8
    SEP  R4
    DW   OutString
    SEP  R5
LKNotDark
    LDN  R9
    SHL                             ; D = room * 2
    ADI  LOW Table_RSS
    PLO  RA
    LDI  HIGH Table_RSS
    ADCI $00
    PHI  RA
    LDA  RA
    PHI  RB
    LDA  RA
    PLO  RB                         ; RB = RSS[room]
    LDA  RB
    SMI  '*'
    BZ   LKPrintRoom1
    DEC  RB
    LDI  HIGH Look2Msg              ; print "I'm in a " prefix
    PHI  R8
    LDI  LOW Look2Msg
    PLO  R8
    SEP  R4
    DW   OutString
LKPrintRoom1
    GLO  RB
    PLO  R8
    GHI  RB
    PHI  R8
    SEP  R4
    DW   OutString                  ; print the room description
    LDI  $00
    PLO  RB                         ; RB.0 is item counter 'i' for loop
    PHI  RB                         ; RB.1 is flag which specifies whether item list prefix has been printed
    LDI  LOW Array_IA
    PLO  RA
    LDI  HIGH Array_IA
    PHI  RA                         ; RA is pointer to start of IA[]
LKLoop1
    SEX  R9                         ; R9 is pointing to 'room'
    LDA  RA
    SM
    LBNZ LKLoop1Tail
    ; we have found an item in this room.  start by printing the item list header if necessary
    GHI  RB
    BNZ  LKLoop1Next1
    LDI  $01
    PHI  RB
    LDI  HIGH Look3Msg
    PHI  R8
    LDI  LOW Look3Msg
    PLO  R8
    SEP  R4
    DW   OutString                  ; print: "Visible Items Here:"
LKLoop1Next1
    ; print item description
    GLO  RB                         ; D = item number (i)
    SHL
    ADI  LOW Table_IAS
    PLO  R8
    LDI  HIGH Table_IAS
    ADCI $00
    PHI  R8
    LDA  R8
    PHI  RC
    LDA  R8
    PLO  RC                         ; RC = pointer to item description
    LDI  ' '
    SEP  R7
    LDI  ' '
    SEP  R7
    LDI  ' '
    SEP  R7
LKLoop1_1
    LDN  RC
    BZ   LKLoop1_1Tail
    SMI  '/'
    BZ   LKLoop1_1Tail
    LDA  RC
    SEP  R7
    BR   LKLoop1_1
LKLoop1_1Tail
    LDI  '\r'
    SEP  R7
    LDI  '\n'
    SEP  R7
LKLoop1Tail
    INC  RB
    GLO  RB
    SMI  IL
    LBNF LKLoop1
    ; now print room exits
    SEX  R9
    LDN  R9                         ; D = room
    ADD
    ADD
    SHL                             ; D = room * 6
    ADI  LOW Array_RM
    PLO  R9
    LDI  HIGH Array_RM
    ADCI $00
    PHI  R9                         ; R9 is pointer to RM[room][0]
    LDI  $00
    PLO  RB                         ; RB.0 is direction counter 'i' for loop
    PHI  RB                         ; RB.1 is flag which specifies whether exit list header has been printed
LKLoop2
    LDA  R9
    BZ  LKLoop2Tail
    ; we have found an exit from this room.  start by printing the exit list header if necessary
    GHI  RB
    BNZ  LKLoop2Next1
    LDI  $01
    PHI  RB
    LDI  HIGH Look4Msg
    PHI  R8
    LDI  LOW Look4Msg
    PLO  R8
    SEP  R4
    DW   OutString
LKLoop2Next1
    GLO  RB
    SHL
    SHL
    SHL
    ADI  LOW Array_DIR
    PLO  R8
    LDI  HIGH Array_DIR
    ADCI $00
    PHI  R8
    SEP  R4
    DW   OutString                  ; print direction
    LDI  ' '
    SEP  R7
LKLoop2Tail
    INC  RB
    GLO  RB
    SMI  6
    BL   LKLoop2
    LDI  '\r'
    SEP  R7
    LDI  '\n'
    SEP  R7
    LDI  '\n'
    SEP  R7
    SEP  R5

;__________________________________________________________________________________________________
; Adventure turn() function

; IN:       N/A
; OUT:      N/A
; TRASHED:  R7, R8, R9, RA, RB, RF

Do_Turn
    LDI  $00
    PLO  R9                         ; R9.0 = i ((is_dark) && (IA[9] != room) && (IA[9] != -1))
    PHI  R9                         ; R9.1 = go_direction
    LDI  LOW Array_NV
    PLO  R7
    LDI  HIGH Array_NV
    PHI  R7
    LDA  R7                         ; D = NV[0]
    SMI  $01
    BNZ  TUNoGo
    LDN  R7
    BNZ  TUHaveNoun
    LDI  HIGH Turn1Msg
    PHI  R8
    LDI  LOW Turn1Msg
    PLO  R8
    SEP  R4
    DW   OutString                  ; print "Where do you want me to go? Give me a direction too.\n"
    SEP  R5                         ; return
TUHaveNoun
    SMI  $07
    LBDF TUNoDirection              ; BGE
    LDN  R7
    PHI  R9                         ; go_direction = NV[1]
    BR   TUHaveDirection
TUNoGo
    DEC  R7
    LDN  R7                         ; D = NV[0]
    SMI  54
    LBNF TUNoDirection              ; BL
    SMI  6
    LBDF TUNoDirection              ; BGE
    ADI  7
    PHI  R9                         ; go_direction = NV[0] - 53
TUHaveDirection
    LDI  LOW Darkflag
    PLO  RA
    LDI  HIGH Darkflag
    PHI  RA
    LDA  RA                         ; D == is_dark
    SEX  RA                         ; RA is pointing to 'room'
    BZ   TUNotDark
    LDI  LOW (Array_IA+9)
    PLO  RB
    LDI  HIGH (Array_IA+9)
    PHI  RB                         ; RB is pointer to IA[9]
    LDN  RB
    SHL
    BDF  TUNotDark
    SHR
    SM
    BZ   TUNotDark
    ; it's dark. print a message
    INC  R9                         ; i = 1
    LDI  HIGH Turn2Msg
    PHI  R8
    LDI  LOW Turn2Msg
    PLO  R8
    SEP  R4                         ; print: "Warning: it's dangerous to move in the dark!\n"
    DW   OutString
    SEX  RA
TUNotDark
    GHI  R9
    STR  R2                         ; put go_direction on top of stack
    LDX                             ; D = room
    ADD
    ADD
    SHL                             ; D = room * 6
    SEX  R2
    ADD                             ; D = room * 6 + go_direction
    ADI  LOW (Array_RM-1)
    PLO  RB
    LDI  HIGH (Array_RM-1)
    ADCI $00
    PHI  RB                         ; RB is pointer to RM[room][go_direction-1]
    LDN  RB
    PHI  R9                         ; R9.1 = j
    LBNZ TUExitNotBlocked
    GLO  R9
    BNZ  TUBlockedAndDark
    LDI  HIGH Turn3Msg
    PHI  R8
    LDI  LOW Turn3Msg
    PLO  R8
    SEP  R4                         ; print: "I can't go in that direction.\n"
    DW   OutString
    SEP  R5                         ; return
TUBlockedAndDark
    LDI  HIGH Turn4Msg
    PHI  R8
    LDI  LOW Turn4Msg
    PLO  R8
    SEP  R4                         ; print: "I fell down and broke my neck.\n"
    DW   OutString
    LDI  RL-1
    PHI  R9                         ; j = RL-1
    DEC  RA
    LDI  $00
    STR  RA                         ; is_dark = false
    INC  RA
    BR   TUSetRoom
TUExitNotBlocked
    SEP  R4
    DW   ClearScreen
TUSetRoom
    GHI  R9
    STR  RA                         ; room = j
    SEP  R4
    DW   Do_Look                    ; look()
    SEP  R5                         ; return
TUNoDirection
    LDI  $00
    PHI  R9                         ; R9.1 = command_found = false
    PLO  R9
    INC  R9                         ; R9.0 = command_allowed = true
    LDI  LOW Array_C
    PLO  RA
    LDI  HIGH Array_C
    PHI  RA                         ; RA = C[cmd]
TULoop1
    LDI  LOW Array_NV
    PLO  R7
    LDI  HIGH Array_NV
    PHI  R7                         ; R7 = NV
    LDN  RA
    PLO  R8                         ; R8.0 = i = C[cmd][0]
    BZ   TULoop1Next1
    LDN  R7
    BZ   TULoop1Done                ; if (NV[0] == 0 && i != 0) break;
    GLO  R8
TULoop1Next1
    SEX  R7
    SM
    BNZ  TULoop1Tail
    INC  RA
    LDN  RA
    DEC  RA
    PLO  R8                         ; R8.0 = i = C[cmd][1]
    BZ   TULoop1CheckCommand
    INC  R7
    SM                              ; D = i - NV[1]
    DEC  R7
    BZ   TULoop1CheckCommand
    LDN  R7                         ; D = NV[0]
    BNZ  TULoop1Tail
TULoop1GetChances                   ; get random number between 1 and 100
    SEP  R4
    DW   GenRandom                  ; R7 is trashed
    SHR
    SMI  100
    BGE  TULoop1GetChances
    ADI  101
    STR  R2
    GLO  R8                         ; D = i
    SM
    BL   TULoop1Tail
TULoop1CheckCommand
    LDI  $01
    PHI  R9                         ; R9.1 = command_found = true
    SEP  R4
    DW   Do_CheckLogics
    PLO  R9                         ; R9.0 = command_allowed = check_logics(cmd)
    BZ   TULoop1Tail
    GLO  RA                         ; pre-increment C[cmd] pointer to use as an end-of-loop marker
    PLO  RE                         ; and store original value in RE
    ADI  $10
    PLO  RA
    PLO  RB
    GHI  RA
    PHI  RE                         ; RE is pAcVar
    ADCI $00
    PHI  RA
    PHI  RB
    DEC  RB
    DEC  RB
    DEC  RB
    DEC  RB                         ; RB is C[cmd][y]
TULoop1_1
    LDN  RB                         ; D = ac
    BZ   TULoop1_1SkipAction
    SEP  R4
    DW   Do_Action
    BNZ  TULoop1_1Done              ; if (failed) break;
TULoop1_1SkipAction
    LDI  LOW Loadflag
    PLO  R7
    LDI  HIGH Loadflag
    PHI  R7
    LDA  R7
    BNZ  TULoop1Done                ; if (loadflag) break twice
    LDN  R7
    BNZ  TULoop1Done                ; if (endflag) break twice
TULoo1_1Tail
    INC  RB                         ; y++
    GLO  RB
    STR  R2
    GLO  RA
    SM
    BNZ  TULoop1_1                  ; loop if C[cmd][y] != C[cmd+1][0]
TULoop1_1Done
    LDI  LOW Array_NV
    PLO  R7
    LDI  HIGH Array_NV
    PHI  R7                         ; R7 = NV
    LDN  R7
    BNZ  TULoop1Done                ; if (NV[0] != 0) break;
    BR   TULoop1Tail2               ; skip C[cmd] pointer advancement because we already did it
TULoop1Tail
    GLO  RA
    ADI  $10
    PLO  RA
    GHI  RA
    ADCI $00
    PHI  RA                         ; RA = C[cmd+1]
TULoop1Tail2
    LDN  RA
    SMI  $FF
    BNZ  TULoop1
TULoop1Done
    LDI  LOW Array_NV
    PLO  R7
    LDI  HIGH Array_NV
    PHI  R7
    LDN  R7                         ; D = NV[0]
    SMI  10
    BZ   TUCarryDrop
    LDN  R7
    SMI  18
    BNZ  TUNotCarryDrop
TUCarryDrop
    GLO  R9                         ; D = command_allowed
    BZ   TURunCarryDrop
    GHI  R9                         ; D = command_found
    BNZ  TUNotCarryDrop
TURunCarryDrop                      ; if (!command_found || !command_allowed)
    SEP  R4
    DW   Do_CarryDrop               ; carry_drop()
    SEP  R5                         ; return
TUNotCarryDrop
    LDN  R7                         ; D = NV[0]
    BZ   TUDone
    GHI  R9                         ; D = command_found
    BNZ  TUCommandWasFound
    LDI  LOW Turn5Msg
    PLO  R8
    LDI  HIGH Turn5Msg
    PHI  R8
    BR   TUPrintAndReturn           ; print: "I don't understand your command."
TUCommandWasFound
    GLO  R9                         ; D = command_allowed
    BNZ  TUDone
    LDI  LOW Turn6Msg
    PLO  R8
    LDI  HIGH Turn6Msg
    PHI  R8
TUPrintAndReturn
    SEP  R4                         ; print: "I can't do that yet."
    DW   OutString
TUDone
    SEP  R5

;__________________________________________________________________________________________________
; Adventure carry_drop() function

; IN:       N/A
; OUT:      N/A
; TRASHED:  R7, R8, R9, RA, RB, RF

Do_CarryDrop
    LDI  LOW Array_NV
    PLO  R7
    LDI  HIGH Array_NV
    PHI  R7                         ; R7 = NV
    LDA  R7
    PLO  RA                         ; RA.0 = NV[0]
    LDN  R7
    PHI  RA                         ; RA.1 = NV[1]
    BNZ  CDHaveNoun
    LDI  LOW CarryDrop1Msg
    PLO  R8
    LDI  HIGH CarryDrop1Msg
    PHI  R8
    LBR  CDPrintAndReturn           ; print: "What?"
CDHaveNoun
    GLO  RA
    SMI  10
    LBNZ CDNotTake
    ; check to make sure we don't have too many items
    LDI  LOW Array_IA
    PLO  R7
    LDI  HIGH Array_IA
    PHI  R7                         ; R7 points to IA array
    LDI  0
    PLO  RF                         ; RF.0 = number of items in inventory
    LDI  IL
CDLoop1
    PHI  RF                         ; RF.1 = item counter
    LDA  R7
    SMI  $FF
    BNZ  CDLoop1Tail
    INC  RF
CDLoop1Tail
    GHI  RF
    SMI  $01
    LBNZ CDLoop1
    LDI  MX
    STR  R2
    GLO  RF
    SM                              ; DF/D = items - MX
    BL   CDNotTake
    LDI  LOW CarryDrop2Msg
    PLO  R8
    LDI  HIGH CarryDrop2Msg
    PHI  R8
    SEP  R4                         ; print: "I can't. I'm carrying too much!"
    DW   OutString
    SEP  R5                         ; return
CDNotTake
    LDI  IL
    PLO  RF                         ; RF.0 = item counter
    LDI  $00
    PHI  RF                         ; RF.1 = found_object
    GHI  RA                         ; D = NV[1]
    SHL
    SHL
    ADI  LOW (Array_NVS+240)
    PLO  R9
    LDI  HIGH (Array_NVS+240)
    ADCI $00
    PHI  R9                         ; R9 points to NVS[1][NV[1]], which is a 3-letter uppercase noun given by the user
    LDI  LOW Table_IAS
    PLO  R7
    LDI  HIGH Table_IAS
    PHI  R7                         ; R7 points to IAS table
    SEX  R8
CDLoop2
    LDA  R7
    PHI  R8
    LDA  R7
    PLO  R8                         ; R8 = pointer to IAS[j][0]
CDLoop2_1
    LDA  R8                         ; find end of item description string
    BNZ  CDLoop2_1
    DEC  R8
    DEC  R8
    LDN  R8
    SMI  '/'                        ; if last character is not a slash
    BNZ  CDLoop2Tail                ; then skip this item
CDLoop2_2
    DEC  R8                         ; else find the preceding slash
    LDN  R8
    SMI  '/'
    BNZ  CDLoop2_2
    INC  R8                         ; R8 is first character in short uppercase object name
    ; comparestring()
    LDA  R9                         ; Load 1st character in input noun
    SM                              ; compare to 1st character in object name
    BNZ  CDLoop2_2NoMatch1
    INC  R8
    LDA  R9                         ; Load 2nd character in input noun
    SM                              ; compare to 2nd character in object name
    BNZ  CDLoop2_2NoMatch2
    INC  R8
    LDN  R9                         ; Load 3rd character in input noun
    BZ   CDLoop2_FoundObject
    SM                              ; compare to 3rd character in object name
    BZ   CDLoop2_FoundObject
CDLoop2_2NoMatch2
    DEC  R9
CDLoop2_2NoMatch1
    DEC  R9                         ; restore R9 to point to start of input noun
CDLoop2Tail
    DEC  RF
    GLO  RF
    BNZ  CDLoop2
CDLoop2Done
    GHI  RF                         ; D = found_object
    BNZ  CDLoop2Done2
    LDI  LOW CarryDrop7Msg
    PLO  R8
    LDI  HIGH CarryDrop7Msg
    PHI  R8
    BR   CDPrintAndReturn           ; print: "It's beyond my power to do that."
CDLoop2Done2
    GLO  RA                         ; D = NV[0]
    SMI  10
    BNZ  CDLoop2Done3
    LDI  LOW CarryDrop4Msg
    PLO  R8
    LDI  HIGH CarryDrop4Msg
    PHI  R8
    BR   CDPrintAndReturn           ; print: "I don't see it here."
CDLoop2Done3
    LDI  LOW CarryDrop6Msg
    PLO  R8
    LDI  HIGH CarryDrop6Msg
    PHI  R8
    BR   CDPrintAndReturn           ; print: "I'm not carrying it!"

CDLoop2_FoundObject
    ; we found a matching object!
    LDI  $01
    PHI  RF                         ; RF.1 = found_object
    SEX  R2
    GLO  RF
    STR  R2
    LDI  IL
    SM                              ; D = j (item index)
    ADI  LOW Array_IA
    PLO  RB
    LDI  HIGH Array_IA
    ADCI $00
    PHI  RB                         ; RB = pointer to IA[j]
    LDI  LOW Room
    PLO  R8
    LDI  HIGH Room
    PHI  R8                         ; R8 = pointer to 'room'
    SEX  R8
    GLO  RA                         ; D = NV[0]
    SMI  10
    BNZ  CDDropItem
CDTakeItem
    LDN  RB
    SM
    BNZ  CDLoop2_2NoMatch2          ; go back and look for another item with the same name; maybe it's here instead of this one
    LDI  $FF
    STR  RB                         ; IA[j] = -1;
    LDI  LOW CarryDrop3Msg
    PLO  R8
    LDI  HIGH CarryDrop3Msg
    PHI  R8
    BR   CDPrintAndReturn           ; print: "OK, taken."

CDDropItem
    LDN  RB
    SMI  $FF
    BNZ  CDLoop2_2NoMatch2          ; not in my inventory; go back and look for another item with the same name
    LDN  R8
    STR  RB                         ; IA[j] = room;
    LDI  LOW CarryDrop5Msg
    PLO  R8
    LDI  HIGH CarryDrop5Msg
    PHI  R8                          ; print: "OK, dropped."

CDPrintAndReturn
    SEP  R4
    DW   OutString
    SEP  R5

;__________________________________________________________________________________________________
; Adventure check_logics() function

; IN:       RA=C[cmd]
; OUT:      D=1 if command is allowed, 0 otherwise
; TRASHED:  R7, R8, RB, RC

Do_CheckLogics
    GLO  RA
    STXD
    GHI  RA
    STXD                            ; push RA on the stack
    LDI  $05
    PLO  R7                         ; R7.0 = loop counter
    INC  RA
    INC  RA                         ; RA points to C[cmd][2]
    LDI  LOW Room
    PLO  RC
    LDI  HIGH Room
    PHI  RC                         ; RC = pointer to Room
CLLoop1
    INC  RC
    INC  RC                         ; RC = pointer to StateFlags
    LDA  RC
    PHI  RB
    LDN  RC
    PLO  RB                         ; RB = value of StateFlags
    DEC  RC
    DEC  RC
    DEC  RC                         ; RC = pointer to Room
    LDA  RA
    PHI  R7                         ; R7.1 = ll
    PLO  R8
CLLoop1_1
    BZ   CLLoop1_1Done
    GHI  RB
    SHR
    PHI  RB
    GLO  RB
    SHRC
    PLO  RB
    DEC  R8
    GLO  R8
    BR   CLLoop1_1
CLLoop1_1Done
    GLO  RB
    ANI  $01
    PHI  R8                         ; R8.1 = ((state_flags >> ll) && 1)
    GHI  R7                         ; D = ll
    ADI  LOW Array_IA
    PLO  RB
    LDI  HIGH Array_IA
    ADCI $00
    PHI  RB                         ; RB = pointer to IA[ll]
    LDA  RA                         ; D = k
    LBZ  CLLoop1Tail                ; skip this predicate if k == 0
CLLoopCheck1
    SEX  RC                         ; M(R(X)) points to Room
    SMI  $01
    BNZ  CLLoopCheck2
    LDN  RB
    SMI  $FF
    LBZ   CLLoop1Tail               ; if (k == 1) allowed = (IA[ll] == -1);
    LBR   CLReturnFalse
CLLoopCheck2
    SMI  $01
    LBNZ  CLLoopCheck3
    LDN  RB
    SM
    BZ   CLLoop1Tail                ; if (k == 2) allowed = (IA[ll] == room);
    BR   CLReturnFalse
CLLoopCheck3
    SMI  $01
    BNZ  CLLoopCheck4
    LDN  RB
    SM
    BZ   CLLoop1Tail
    LDN  RB
    SMI  $FF
    BZ   CLLoop1Tail                ; if (k == 3) allowed = (IA[ll] == room || IA[ll] == -1);
    BR   CLReturnFalse
CLLoopCheck4
    SMI  $01
    BNZ  CLLoopCheck5
    GHI  R7
    SM
    BZ   CLLoop1Tail                ; if (k == 4) allowed = (room == ll);
    BR   CLReturnFalse
CLLoopCheck5
    SMI  $01
    BNZ  CLLoopCheck6
    LDN  RB
    SM
    BNZ  CLLoop1Tail                ; if (k == 5) allowed = (IA[ll] != room);
    BR   CLReturnFalse
CLLoopCheck6
    SMI  $01
    BNZ  CLLoopCheck7
    LDN  RB
    SMI  $FF
    BNZ  CLLoop1Tail                ; if (k == 6) allowed = (IA[ll] != -1);
    BR   CLReturnFalse
CLLoopCheck7
    SMI  $01
    BNZ  CLLoopCheck8
    GHI  R7
    SM
    BNZ  CLLoop1Tail                ; if (k == 7) allowed = (room != ll);
    BR   CLReturnFalse
CLLoopCheck8
    SMI  $01
    BNZ  CLLoopCheck9
    GHI  R8                         ; D = ((state_flags >> ll) && 1)
    BNZ  CLLoop1Tail                ; if (k == 8) allowed = (state_flags & (1 << ll)) != 0;
    BR   CLReturnFalse
CLLoopCheck9
    SMI  $01
    BNZ  CLLoopCheck10
    GHI  R8                         ; D = ((state_flags >> ll) && 1)
    BZ   CLLoop1Tail                ; if (k == 9) allowed = (state_flags & (1 << ll)) == 0;
    BR   CLReturnFalse
CLLoopCheck10
    SMI  $01
    BNZ  CLLoopCheck11
    LDI  LOW Array_IA
    PLO  RB
    LDI  HIGH Array_IA
    PHI  RB                         ; RB = pointer to IA[0]
    LDI  IL
    PLO  R8                         ; R8 = loop counter IL
CLCheck10Loop1
    LDA  RB
    SMI  $FF
    BZ   CLLoop1Tail                ; if (k == 10) for (i=0; i<IL; i++) if (IA[i] == -1) allowed = true;
    DEC  R8
    GLO  R8
    BNZ  CLCheck10Loop1
    BR   CLReturnFalse
CLLoopCheck11
    SMI  $01
    BNZ  CLLoopCheck12
    LDI  LOW Array_IA
    PLO  RB
    LDI  HIGH Array_IA
    PHI  RB                         ; RB = pointer to IA[0]
    LDI  IL
    PLO  R8                         ; R8 = loop counter IL
CLCheck11Loop1
    LDA  RB
    SMI  $FF
    BZ   CLReturnFalse              ; if (k == 11) for (i=0; i<IL; i++) if (IA[i] == -1) allowed = false;
    DEC  R8
    GLO  R8
    BNZ  CLCheck11Loop1
    BR   CLLoop1Tail
CLLoopCheck12
    SMI  $01
    BNZ  CLLoopCheck13
    LDN  RB
    SM
    BZ   CLReturnFalse
    LDN  RB
    SMI  $FF
    BZ   CLReturnFalse              ; if (k == 12) allowed = (IA[ll] != -1 && IA[ll] != room);
    BR   CLLoop1Tail
CLLoopCheck13
    SMI  $01
    BNZ  CLLoopCheck14
    LDN  RB
    BNZ  CLLoop1Tail                ; if (k == 13) allowed = (IA[ll] != 0);
    BR   CLReturnFalse
CLLoopCheck14
    SMI  $01
CLDebug1
    BNZ  CLDebug1                   ; deadlock here if invalid 'k' was found
    LDN  RB
    BNZ  CLReturnFalse              ; if (k == 14) allowed = (IA[ll] == 0);
CLLoop1Tail
    DEC  R7
    GLO  R7
    LBNZ CLLoop1
CLReturnTrue
    SEX  R2
    INC  R2
    LDXA
    PHI  RA
    LDX
    PLO  RA                         ; restore original value of RA
    LDI  $01
    SEP  R5                         ; return false
CLReturnFalse
    SEX  R2
    INC  R2
    LDXA
    PHI  RA
    LDX
    PLO  RA                         ; restore original value of RA
    LDI  $00
    SEP  R5                         ; return false

;__________________________________________________________________________________________________
; Adventure action() function

; IN:       D=ac, RE=pAcVar, R2 = stack pointer
; OUT:      D=1 if action failed, 0 otherwise
; TRASHED:  R1, R7, R8, RC, RD, RF

Do_Action
    STR  R2                         ; save 'ac' variable
    LDI  LOW Sub_GetActionVariable
    PLO  RF
    LDI  HIGH Sub_GetActionVariable
    PHI  RF                         ; RF = pointer to fast subroutine get_action_variable
    LDN  R2                         ; D = ac
    SMI  52
    BL   DAPrintMessage
    SMI  50
    BGE  DAPrintMessage
    ADI  50
    BR   DACheck52
DAPrintMessage
    ADI  52                         ; D = message number
    SHL
    ADI  LOW Table_MSS
    PLO  R7
    LDI  HIGH Table_MSS
    ADCI $00
    PHI  R7
    LDA  R7
    PHI  R8
    LDN  R7
    PLO  R8                         ; R8 points to message to print
    SEP  R4
    DW   OutString
    LDI  $0D
    SEP  R7
    LDI  $0A
    SEP  R7                         ; print '\r\n'
    LDI  $00
    SEP  R5                         ; return false (action didn't fail)
DACheck52
    LBNZ DACheck53
    LDI  LOW Array_IA
    PLO  R7
    LDI  HIGH Array_IA
    PHI  R7                         ; R7 = pointer to IA[0]
    LDI  IL
    PLO  R8                         ; R8.0 = IL
    LDI  $00
    PLO  RC
DACheck52Loop
    LDA  R7                         ; D = IA[i]
    SMI  $FF
    BNZ  DACheck52Next
    INC  RC                         ; j++
DACheck52Next
    DEC  R8
    GLO  R8
    BNZ  DACheck52Loop
    GLO  RC
    SMI  MX
    BL   DACheck52TakeItem
    LDI  LOW CarryDrop2Msg
    PLO  R8
    LDI  HIGH CarryDrop2Msg
    PHI  R8
    SEP  R4                         ; print: "I can't. I'm carrying too much!"
    DW   OutString
    LDI  $01
    SEP  R5                         ; return true
DACheck52TakeItem
    SEP  RF                         ; call get_action_variable()
    ADI  LOW Array_IA
    PLO  R7
    LDI  HIGH Array_IA
    ADCI $00
    PHI  R7                         ; R7 = pointer to IA[get_action_variable(pAcVar)]
    LDI  $FF
    STR  R7
DAReturnFalse1
    LDI  $00
    SEP  R5                         ; return false (action didn't fail)
DACheck53
    SMI  $01
    BNZ  DACheck54
    LDI  LOW Room
    PLO  R8
    LDI  HIGH Room
    PHI  R8
    SEP  RF                         ; call get_action_variable()
    ADI  LOW Array_IA
    PLO  R7
    LDI  HIGH Array_IA
    ADCI $00
    PHI  R7                         ; R7 = pointer to IA[get_action_variable(pAcVar)]
    LDN  R8
    STR  R7                         ; if (ac == 53) IA[get_action_variable(pAcVar)] = room;
    BR   DAReturnFalse1
DACheck54
    SMI  $01
    BNZ  DACheck55
    LDI  LOW Room
    PLO  R8
    LDI  HIGH Room
    PHI  R8
    SEP  RF                         ; call get_action_variable()
    STR  R8                         ; if (ac == 54) room = get_action_variable(pAcVar);
    BR   DAReturnFalse1
DACheck55
    SMI  $01
    BNZ  DACheck56
    BR   DAAction59                 ; if (ac == 55 || ac == 59) IA[get_action_variable(pAcVar)] = 0;
DACheck56
    SMI  $01
    BNZ  DACheck57
    LDI  LOW Darkflag
    PLO  R7
    LDI  HIGH Darkflag
    PHI  R7
    LDI  $01
    STR  R7                         ; if (ac == 56) is_dark = true;
    BR   DAReturnFalse1
DACheck57
    SMI  $01
    BNZ  DACheck58
    LDI  LOW Darkflag
    PLO  R7
    LDI  HIGH Darkflag
    PHI  R7
    LDI  $00
    STR  R7                         ; if (ac == 57) is_dark = false;
    BR   DAReturnFalse1
DACheck58
    SMI  $01
    BNZ  DACheck59
    LDI  LOW StateFlags
    PLO  R7
    LDI  HIGH StateFlags
    PHI  R7
    LDI  $01
    PHI  R8                         ; R8.1 = shift register byte
    SEP  RF                         ; call get_action_variable()
    SMI  8
    BGE  DACheck58Loop
    INC  R7                         ; R7 points to StateFlags+1
    ADI  8
DACheck58Loop
    BZ   DACheck58LoopDone
    PLO  R8                         ; R8.0 is number of bits remaining to shift
    GHI  R8
    SHL                             ; shift one bit left
    PHI  R8
    DEC  R8
    GLO  R8
    BR   DACheck58Loop
DACheck58LoopDone
    GHI  R8                         ; R8 is byte to OR with StateFlags
    SEX  R7
    OR                              ; if (ac == 58) state_flags |= 1 << get_action_variable(pAcVar);
    STR  R7
    BR   DAReturnFalse1
DACheck59
    SMI  $01
    BNZ  DACheck60
DAAction59
    SEP  RF                         ; call get_action_variable()
    ADI  LOW Array_IA
    PLO  R7
    LDI  HIGH Array_IA
    ADCI $00
    PHI  R7                         ; R7 = pointer to IA[get_action_variable(pAcVar)]
    LDI  $00
    STR  R7                         ; if (ac == 55 || ac == 59) IA[get_action_variable(pAcVar)] = 0;
    BR   DAReturnFalse1
DACheck60
    SMI  $01
    BNZ  DACheck61
    LDI  LOW StateFlags
    PLO  R7
    LDI  HIGH StateFlags
    PHI  R7
    LDI  $01
    PHI  R8                         ; R8.1 = shift register byte
    SEP  RF                         ; call get_action_variable()
    SMI  8
    BGE  DACheck60Loop
    INC  R7                         ; R7 points to StateFlags+1
    ADI  8
DACheck60Loop
    BZ   DACheck60LoopDone
    PLO  R8                         ; R8.0 is number of bits remaining to shift
    GHI  R8
    SHL                             ; shift one bit left
    PHI  R8
    DEC  R8
    GLO  R8
    BR   DACheck60Loop
DACheck60LoopDone
    GHI  R8                         ; R8 is byte to XOR with StateFlags
    SEX  R7
    XOR                             ; if (ac == 60) state_flags ^= 1 << get_action_variable(pAcVar);
    STR  R7
    BR   DAReturnFalse1
DACheck61
    SMI  $01
    BNZ  DACheck62                  ; if (ac == 61)
    LDI  LOW Darkflag
    PLO  R7
    LDI  HIGH Darkflag
    PHI  R7
    LDI  $00
    STR  R7                         ; is_dark = false;
    INC  R7
    LDI  RL-1
    STR  R7                         ; room = RL-1;
    LDI  LOW Action1Msg
    PLO  R8
    LDI  HIGH Action1Msg
    PHI  R8
    SEP  R4                         ; print: "I'm dead..."
    DW   OutString
    LBR  DADoLook                   ; look()
DACheck62
    SMI  $01
    BNZ  DACheck63
    SEP  RF                         ; call get_action_variable()
    ADI  LOW Array_IA
    PLO  R7
    LDI  HIGH Array_IA
    ADCI $00
    PHI  R7                         ; R7 = pointer to IA[get_action_variable(pAcVar)]
    SEP  RF                         ; call get_action_variable()
    STR  R7                         ; if (ac == 62) { i = get_action_variable(pAcVar); IA[i] = (get_action_variable(pAcVar)); }
    BR   DAReturnFalse1
DACheck63
    SMI  $01
    LBNZ DACheck64
    LDI  LOW Action2Msg
    PLO  R8
    LDI  HIGH Action2Msg
    PHI  R8
    SEP  R4                         ; print "The game is now over.\nAnother game? "
    DW   OutString
    SEP  R4
    DW   Do_YesNo                   ; D = 0 if No, 1 if Yes
    SDI  LOW Endflag
    PLO  RC
    LDI  HIGH Endflag
    SMBI $00
    PHI  RC
    LDI  $01
    STR  RC                         ; set Loadflag or Endflag to 1
    BR   DAReturnFalse2
DACheck64
    SMI  $01
    BNZ  DACheck65
    LBR  DADoLook                   ; if (ac == 64) look();
DACheck65
    SMI  $01
    BNZ  DACheck66
    PHI  RC                         ; RC.1 = count of treasures
    LDI  LOW Table_IAS
    PLO  R7
    LDI  HIGH Table_IAS
    PHI  R7
    LDI  LOW Array_IA
    PLO  R8
    LDI  HIGH Array_IA
    PHI  R8
    LDI  IL
    PLO  RC                         ; RC.0 = item loop counter
DAAction65Loop
    LDA  R7
    PHI  RD
    LDA  R7
    PLO  RD                         ; RD = pointer to IAS[i][0]
    LDA  R8                         ; D = IA[i]
    SMI  TR                         ; TR = Treasure Room
    BNZ  DAAction65LoopTail
    LDN  RD
    SMI  '*'
    BNZ  DAAction65LoopTail
    GHI  RC
    ADI  $01
    PHI  RC                         ; j++
DAAction65LoopTail
    DEC  RC
    GLO  RC
    BNZ  DAAction65Loop
    LDI  LOW (Action3Msg+21)
    PLO  R8
    LDI  HIGH (Action3Msg+21)
    PHI  R8
    GHI  RC
    SEP  R4
    DW   Print2Digit                ; convert # of treasures to 2-digit number
    LDI  LOW (Action3Msg+78)
    PLO  R8
    LDI  HIGH (Action3Msg+78)
    PHI  R8
    GHI  RC
    ADI  LOW ScoreTable
    PLO  RD
    LDI  HIGH ScoreTable
    ADCI $00
    PHI  RD
    LDN  RD
    SEP  R4
    DW   Print2Digit                ; convert # of treasures to 2-digit number
    LDI  LOW Action3Msg
    PLO  R8
    LDI  HIGH Action3Msg
    PHI  R8
    SEP  R4
    DW   OutString                  ; print "I've stored XX treasures.  On a scale of 0 to 99, that rates a XX."
    GHI  RC
    SMI  TT
    BNZ  DAReturnFalse2             ; continue if not a perfect score
    LDI  LOW Action4Msg
    PLO  R8
    LDI  HIGH Action4Msg
    PHI  R8
    SEP  R4
    DW   OutString                  ; print "Congratulations! You scored a Perfect Game!\r\nThe game is now over.\r\nAnother game? "
    SEP  R4
    DW   Do_YesNo                   ; D = 0 if No, 1 if Yes
    SDI  LOW Endflag
    PLO  RC
    LDI  HIGH Endflag
    SMBI $00
    PHI  RC
    LDI  $01
    STR  RC                         ; set Loadflag or Endflag to 1
DAReturnFalse2
    LDI  $00
    SEP  R5                         ; return false (action didn't fail)
DACheck66
    SMI  $01
    LBNZ DACheck67
    PLO  RC                         ; RC.0 = line length
    PHI  RC                         ; RC.1 = not empty flag
    LDI  LOW Action5Msg
    PLO  R8
    LDI  HIGH Action5Msg
    PHI  R8
    SEP  R4
    DW   OutString                  ; print "I'm carrying:\n"
    LDI  LOW Table_IAS
    PLO  R1
    LDI  HIGH Table_IAS
    PHI  R1
    LDI  $00
    PLO  RD                         ; RD.0 = item index
DAAction66Loop1
    GLO  RD
    ADI  LOW Array_IA
    PLO  R7
    LDI  HIGH Array_IA
    ADCI $00
    PHI  R7                         ; R7 = pointer to IA[i]
    LDA  R1
    PHI  R8
    LDA  R1
    PLO  R8                         ; R8 = pointer to IAS[i][0]
    LDA  R7                         ; D = IA[i]
    SMI  $FF
    BNZ  DAAction66Loop1Tail        ; skip this item if not in our inventory
    GHI  RC
    ADI  $01
    PHI  RC                         ; not empty flag is true
    GLO  RC
    PHI  RD                         ; temporarily store current line length
    ; figure out how long this item description is
DAAction66Loop1_1
    LDA  R8
    BZ   DAAction66Loop1_1Done
    SMI  '/'
    BZ   DAAction66Loop1_1Done
    INC  RC                         ; increment line length
    BR   DAAction66Loop1_1
DAAction66Loop1_1Done
    LDI  LOW SerialOutput
    PLO  R7
    LDI  HIGH SerialOutput
    PHI  R7                         ; R7 = pointer to character output routine
    GLO  RC                         ; RC is current line length + item description length
    ADI  3
    SMI  MAXLINE
    BL   DAAction66SkipLinefeed
    LDI  $00
    PHI  RD                         ; linelen = 0
    LDI  $0D
    SEP  R7
    LDI  $0A
    SEP  R7                         ; print "\r\n"
DAAction66SkipLinefeed
    GHI  RD
    PLO  RC                         ; restore original line length value
    DEC  R1
    DEC  R1
    LDA  R1
    PHI  R8
    LDA  R1
    PLO  R8                         ; R8 = pointer to IAS[i][0] (again)
DAAction66Loop1_2                   ; print the item description
    LDA  R8
    BZ   DAAction66Loop1_2Done
    SMI  '/'
    BZ   DAAction66Loop1_2Done
    INC  RC                         ; increment line length
    ADI  '/'
    SEP  R7                         ; print one character
    BR   DAAction66Loop1_2
DAAction66Loop1_2Done
    LDI  '.'
    SEP  R7
    LDI  ' '
    SEP  R7                         ; print ". "
    INC  RC
    INC  RC                         ; linelen += 2
DAAction66Loop1Tail
    INC  RD
    GLO  RD
    SMI  IL
    BNZ  DAAction66Loop1
    GHI  RC
    LBNZ DAAction66NotEmpty
    LDI  LOW Action6Msg
    PLO  R8
    LDI  HIGH Action6Msg
    PHI  R8
    SEP  R4
    DW   OutString                  ; print "Nothing!"
DAAction66NotEmpty
    LDI  LOW NewlineMsg
    PLO  R8
    LDI  HIGH NewlineMsg
    PHI  R8
    SEP  R4
    DW   OutString                  ; print "\r\n"
    BR   DAReturnFalse3
DACheck67
    SMI  $01
    BNZ  DACheck68
    LDI  LOW (StateFlags+1)
    PLO  R7
    LDI  HIGH (StateFlags+1)
    PHI  R7
    LDN  R7
    ORI  $01
    STR  R7                         ; if (ac == 67) state_flags |= 1;
    BR   DAReturnFalse3
DACheck68
    SMI  $01
    BNZ  DACheck69
    LDI  LOW (StateFlags+1)
    PLO  R7
    LDI  HIGH (StateFlags+1)
    PHI  R7
    LDN  R7
    XRI  $01
    STR  R7                         ; if (ac == 68) state_flags ^= 1;
    BR   DAReturnFalse3
DACheck69
    SMI  $01
    BNZ  DACheck70
    LDI  LOW (Array_IA+9)
    PLO  R7
    LDI  HIGH (Array_IA+9)
    PHI  R7
    LDI  $FF
    STR  R7
    LDI  LOW LampOil
    PLO  R7
    LDI  HIGH LampOil
    PHI  R7
    LDI  LI
    STR  R7                         ; if (ac == 69) { lamp_oil = LT; IA[9] = -1; }
    BR   DAReturnFalse3
DACheck70
    SMI  $01
    BNZ  DACheck71
    SEP  R4                         ; if (ac == 70) clrscr();
    DW   ClearScreen
    BR   DAReturnFalse3
DACheck71
    SMI  $01
    BNZ  DACheck72
    SEP  R4                         ; call SaveGame function
    DW   Do_SaveGame
    LDI  LOW Action7Msg
    PLO  R8
    LDI  HIGH Action7Msg
    PHI  R8
    SEP  R4
    DW   OutString                  ; print "Game state has been saved in upper memory."
    BR   DAReturnFalse3
DACheck72
    SMI  $01
DADebug1
    BNZ  DADebug1                   ; deadlock here if invalid 'ac' was found
    SEP  RF                         ; j = get_action_variable()
    ADI  LOW Array_IA
    PLO  R7
    LDI  HIGH Array_IA
    ADCI $00
    PHI  R7                         ; R7 = pointer to IA[j]
    SEP  RF                         ; p = get_action_variable()
    ADI  LOW Array_IA
    PLO  R8
    LDI  HIGH Array_IA
    ADCI $00
    PHI  R8                         ; R8 = pointer to IA[p]
    LDN  R7
    PLO  RC                         ; RC.0 = i = IA[j]
    LDN  R8
    STR  R7                         ; IA[j] = IA[p]
    GLO  RC
    STR  R8                         ; IA[p] = i

DAReturnFalse3
    LDI  $00
    SEP  R5                         ; return false (action didn't fail)

DADoLook
    GLO  R9                         ; push R9, RA, and RB on the stack
    STXD
    GHI  R9
    STXD
    GLO  RA
    STXD
    GHI  RA
    STXD
    GLO  RB
    STXD
    GHI  RB
    STXD
    SEP  R4                         ; look()
    DW   Do_Look
    INC  R2
    LDA  R2
    PHI  RB
    LDA  R2
    PLO  RB
    LDA  R2
    PHI  RA
    LDA  R2
    PLO  RA
    LDA  R2
    PHI  R9
    LDN  R2
    PLO  R9
    BR   DAReturnFalse3

;__________________________________________________________________________________________________
; Adventure get_action_variable() function

; IN:       P=F, RE=pAcVar
; OUT:      P=3, D=value
; TRASHED:  N/A

GAV_Return
    SEP  R3
Sub_GetActionVariable
    INC  RE
    INC  RE
GAV_Loop1
    INC  RE
    LDN  RE
    BZ   GAV_FoundVar
    INC  RE
    BR   GAV_Loop1
GAV_FoundVar
    DEC  RE
    LDN  RE
    BR   GAV_Return

;__________________________________________________________________________________________________
; Adventure yes_no() function

; IN:       N/A
; OUT:      D=1 if YES, 0 if NO
; TRASHED:  R7, R8, RF

Do_YesNo
    ; wait for key press
    LDI  HIGH SerialInput
    PHI  R7
    LDI  LOW SerialInput
    PLO  R7
    SEP  R7                         ; RF.1 is new key
    ; load R7 to point to serial output routine in case I need to print. this saves code space
    LDI  HIGH SerialOutput
    PHI  R7
    LDI  LOW SerialOutput
    PLO  R7
    ; make character be uppercase
    LDI  $DF
    STR  R2
    GHI  RF
    AND
    ; check for Y and N
    SMI  'N'
    BZ   YN_No
    SMI  'Y'-'N'
    BZ   YN_Yes
    BR   Do_YesNo
YN_No
    GHI  RF
    SEP  R7
    LDI  $0D
    SEP  R7
    LDI  $0A
    SEP  R7                         ; print 'n\r\n'
    LDI  $00
    SEP  R5                         ; return 0
YN_Yes
    GHI  RF
    SEP  R7
    LDI  $0D
    SEP  R7
    LDI  $0A
    SEP  R7                         ; print 'y\r\n'
    LDI  $01
    SEP  R5                         ; return 1

;__________________________________________________________________________________________________
; SaveGame function to store game state in upper memory

; IN:       N/A
; OUT:      N/A
; TRASHED:  R7, R8, RC

Do_SaveGame
    LDI  LOW Array_IA
    PLO  R7
    LDI  HIGH Array_IA
    PHI  R7
    LDI  LOW STATE_LOC
    PLO  R8
    LDI  HIGH STATE_LOC
    PHI  R8
    LDI  IL
    PLO  RC
SGLoop1                             ; store the IA array (item locations)
    LDA  R7
    STR  R8
    INC  R8
    DEC  RC
    GLO  RC
    BNZ  SGLoop1
    INC  R7
    INC  R7
    INC  R7
    INC  R7                         ; R7 points to DarkFlag
    LDA  R7
    STR  R8                         ; store DarkFlag
    INC  R8
    LDA  R7
    STR  R8                         ; store Room
    INC  R8
    LDA  R7
    STR  R8                         ; store LampOil
    INC  R8
    LDA  R7
    STR  R8                         ; store StateFlags
    INC  R8                         ; R8 points to 2 checksum values at end of buffer
    LDI  $4B
    STR  R8
    INC  R8
    SEX  R8
    STXD                            ; set both checksum values to $4B and reset R8 pointer
    GHI  R8
    PHI  R7
    GLO  R8
    SMI  STATE_SIZE
    PLO  R7                         ; R7 points to beginning of state buffer
    LDI  STATE_SIZE
    PLO  RC                         ; RC.0 is checksum byte counter
SGLoop2
    LDN  R7
    ADD
    STR  R8
    INC  R8
    LDA  R7
    XOR
    STXD
    DEC  RC
    GLO  RC
    BNZ  SGLoop2
    SEP  R5                         ; return

;__________________________________________________________________________________________________
; Read-only Data

ScoreTable      DB          0, 7, 15, 22, 30, 38, 45, 53, 60, 68, 76, 83, 91, 99
KnightRider     DB          $00, $00, $80, $80, $C0, $C0, $E0, $60, $70, $30, $38, $18, $1C, $0C, $0E, $06, $07, $03, $03, $01, $01, $00, $00, $01, $01, $03, $03, $07, $06, $0E, $0C, $1C, $18, $38, $30, $70, $60, $E0, $C0, $C0, $80, $80, $00, $00
ClsMsg          DB          $1B, $5B, $32, $4A, $1B, $48, $00
StartingMsg     BYTE        27,"[1;37m W E L C O M E   T O \n A D V E N T U R E + \n ",27,"[44m(v1.1 2019-12-20)",27,"[0m\r\n\n\n\n\n"
                BYTE        "The object of your adventure is to find ",27,"[1;33mtreasures",27,"[0m and return them\r\n"
                BYTE        "to the proper place for you to accumulate points.  I'm your clone.  Give me\r\n"
                BYTE        "commands that consist of a verb & noun, i.e. GO EAST, TAKE KEY, CLIMB TREE,\r\n"
                BYTE        "SAVE GAME, TAKE INVENTORY, FIND AXE, QUIT, etc.\r\n\n"
                BYTE        "You'll need some special items to do some things, but I'm sure that you'll be\r\n"
                BYTE        "a good adventurer and figure these things out (which is most of the fun of\r\n"
                BYTE        "this game).\r\n\n"
                BYTE        "Note that going in the opposite direction won't always get you back to where\r\n"
                BYTE        "you were.\r\n\n\n"
                BYTE        "HAPPY ADVENTURING!!!\r\n\n\n\n\n"
                BYTE        27,"[1m************************** Press any key to continue **************************",27,"[0m"
NewlineMsg      BYTE        "\r\n", 0
LoadQestion     BYTE        27,"[36m\r\nLoad saved game (Y or N)?",27,"[0m ", 0
LoadFailedMsg   BYTE        27,"[1mSorry, but no saved game data was found.\r\n",27,"[0;36mPress a key to continue...",27,"[0m\r\n", 0
LampEmptyMsg    BYTE        27,"[31mYour lamp has run out of oil!",27,"[0m\r\n", 0
LampLow1Msg     BYTE        27,"[31mYour lamp will run out of oil in ",0
LampLow2Msg     BYTE        " turns!",27,"[0m\r\n",0
InputPromptMsg  BYTE        "\r\n",27,"[36mTell me what to do? ",27,"[0m",0
InputError1Msg  BYTE        27,"[1mI don't know how to ",0
InputError2Msg  BYTE        "!",27,"[0m\r\n", 0
InputError3Msg  BYTE        27,"[1mI don't know what a ", 0
InputError4Msg  BYTE        " is!",27,"[0m\r\n", 0
Look1Msg        BYTE        27,"[1;31mI can't see.  It's too dark!",27,"[0m\r\n", 0
Look2Msg        BYTE        "I'm in a ", 0
Look3Msg        BYTE        "\r\n\n",27,"[1;34mVisible Items Here:",27,"[0m\r\n", 0
Look4Msg        BYTE        "\r\n",27,"[1;34mObvious Exits:",27,"[0m\r\n   ", 0
Turn1Msg        BYTE        27,"[36mWhere do you want me to go? Give me a direction too.",27,"[0m\r\n", 0
Turn2Msg        BYTE        27,"[1;31mWarning: it's dangerous to move in the dark!",27,"[0m\r\n", 0
Turn3Msg        BYTE        27,"[31mI can't go in that direction.",27,"[0m\r\n", 0
Turn4Msg        BYTE        27,"[1;31mI fell down and broke my neck.",27,"[0m\r\n", 0
Turn5Msg        BYTE        27,"[31mI don't understand your command.",27,"[0m\r\n", 0
Turn6Msg        BYTE        27,"[31mI can't do that yet.",27,"[0m\r\n", 0
CarryDrop1Msg   BYTE        27,"[1mWhat?",27,"[0m\r\n", 0
CarryDrop2Msg   BYTE        27,"[31mI can't. I'm carrying too much!",27,"[0m\r\n", 0
CarryDrop3Msg   BYTE        27,"[1mOK, taken.",27,"[0m\r\n", 0
CarryDrop4Msg   BYTE        27,"[31mI don't see it here.",27,"[0m\r\n", 0
CarryDrop5Msg   BYTE        27,"[1mOK, dropped.",27,"[0m\r\n", 0
CarryDrop6Msg   BYTE        27,"[31mI'm not carrying it!",27,"[0m\r\n", 0
CarryDrop7Msg   BYTE        27,"[31mIt's beyond my power to do that.",27,"[0m\r\n", 0
Action1Msg      BYTE        27,"[1;31mI'm dead...",27,"[0m\r\n", 0
Action2Msg      BYTE        27,"[1mThe game is now over.\r\n",27,"[0;36mAnother game? ",27,"[0m",0
Action3Msg      BYTE        27,"[1mI've stored ",27,"[33m00 treasures",27,"[37m.  On a scale\r\nof 0 to 99, that rates a 00.",27,"[0m\r\n", 0
Action4Msg      BYTE        27,"[1mCongratulations! You scored a Perfect Game!\r\nYou are one smart adventurer!\r\n",27,"[33mKick back and grab a cold one, you've earned it.",27,"[0m\r\n\nThe game is now over.\r\nAnother game? ",0
Action5Msg      BYTE        27,"[1;34m\r\nI'm carrying:",27,"[0m\r\n", 0
Action6Msg      BYTE        "Nothing!", 0
Action7Msg      BYTE        27,"[1mGame state has been saved in upper memory.",27,"[0m\r\n", 0

                INCL        "adventureland_data.asm"

;__________________________________________________________________________________________________
; Read/Write Data

Array_TPS       BLK         80      ; These data members must all stay in this order
Array_IA        BLK         IL
Array_NV        DB          0, 0
Loadflag        DB          0
Endflag         DB          0
Darkflag        DB          0
Room            DB          0
LampOil         DB          0
StateFlags      DW          0

Rand_VarX       DB          18      ; These data members must all stay in this order
Rand_VarA       DB          166
Rand_VarB       DB          220
Rand_VarC       DB          64

PrintNumber     DB          0,0,0   ; temporary location for storing 2-digit number to print


.MODEL SMALL
.STACK 100H
.DATA
    ; Menu Messages
    WELCOME_MSG DB 'SISTEM PEMILIHAN UMUM$'
    MENU_MSG DB 0DH,0AH,'1. Mulai Voting',0DH,0AH,'2. Lihat Hasil',0DH,0AH,'3. Reset Voting',0DH,0AH,'4. Keluar',0DH,0AH,'Pilihan Anda: $'
    
    ; Candidate Messages
    CANDIDATE_MSG DB 0DH,0AH,'Kandidat:',0DH,0AH,'1. Kandidat A',0DH,0AH,'2. Kandidat B',0DH,0AH,'3. Kandidat C',0DH,0AH,'Pilih (1-3): $'
    INVALID_MSG DB 0DH,0AH,'Pilihan tidak valid! Silakan coba lagi.$'
    SUCCESS_MSG DB 0DH,0AH,'Terima kasih atas partisipasi Anda!$'
    
    ; Result Messages
    RESULT_HEADER DB 0DH,0AH,'HASIL PEMILIHAN:$'
    CANDIDATE_A DB 0DH,0AH,'Kandidat A: $'
    CANDIDATE_B DB 0DH,0AH,'Kandidat B: $'
    CANDIDATE_C DB 0DH,0AH,'Kandidat C: $'
    RESET_MSG DB 0DH,0AH,'Hasil voting telah direset.$'
    CONFIRM_MSG DB 0DH,0AH,'Apakah Anda yakin? (Y/N): $'
    CANCEL_MSG DB 0DH,0AH,'Aksi dibatalkan.$'
    CONTINUE_MSG DB 0DH,0AH,'Ingin melanjutkan? (Y/N): $'
    EXIT_MSG DB 0DH,0AH,'Terima kasih, program selesai.$'
    
    ; Vote counters
    VOTES_A DB 0
    VOTES_B DB 0
    VOTES_C DB 0
    
    ; Helper variables
    TEMP DB 0
    NEW_LINE DB 0DH,0AH,'$'

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
MAIN_MENU:
    ; Clear screen
    MOV AH, 0
    MOV AL, 3
    INT 10H
    
    ; Display welcome message
    LEA DX, WELCOME_MSG
    MOV AH, 9
    INT 21H
    
    ; Display menu
    LEA DX, MENU_MSG
    MOV AH, 9
    INT 21H
    
    ; Get menu choice
    MOV AH, 1
    INT 21H
    MOV TEMP, AL
    
    ; Process menu choice
    CMP TEMP, '1'
    JE START_VOTING
    CMP TEMP, '2'
    JE SHOW_RESULTS
    CMP TEMP, '3'
    JE CONFIRM_RESET
    CMP TEMP, '4'
    JE CONFIRM_EXIT
    JMP INVALID_CHOICE
    
START_VOTING:
    ; Display candidates
    LEA DX, CANDIDATE_MSG
    MOV AH, 9
    INT 21H
    
    ; Get vote
    MOV AH, 1
    INT 21H
    
    ; Process vote
    CMP AL, '1'
    JE VOTE_A
    CMP AL, '2'
    JE VOTE_B
    CMP AL, '3'
    JE VOTE_C
    JMP INVALID_CHOICE
    
VOTE_A:
    INC VOTES_A
    JMP VOTE_SUCCESS
    
VOTE_B:
    INC VOTES_B
    JMP VOTE_SUCCESS
    
VOTE_C:
    INC VOTES_C
    JMP VOTE_SUCCESS
    
VOTE_SUCCESS:
    LEA DX, SUCCESS_MSG
    MOV AH, 9
    INT 21H
    CALL CONTINUE_OR_EXIT
    JMP MAIN_MENU
    
SHOW_RESULTS:
    LEA DX, RESULT_HEADER
    MOV AH, 9
    INT 21H
    
    ; Show Candidate A votes
    LEA DX, CANDIDATE_A
    MOV AH, 9
    INT 21H
    MOV DL, VOTES_A
    ADD DL, 30H
    MOV AH, 2
    INT 21H
    
    ; Show Candidate B votes
    LEA DX, CANDIDATE_B
    MOV AH, 9
    INT 21H
    MOV DL, VOTES_B
    ADD DL, 30H
    MOV AH, 2
    INT 21H
    
    ; Show Candidate C votes
    LEA DX, CANDIDATE_C
    MOV AH, 9
    INT 21H
    MOV DL, VOTES_C
    ADD DL, 30H
    MOV AH, 2
    INT 21H
    
    CALL CONTINUE_OR_EXIT
    JMP MAIN_MENU
    
CONFIRM_RESET:
    LEA DX, CONFIRM_MSG
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    CMP AL, 'Y'
    JE RESET_VOTES
    CMP AL, 'y'
    JE RESET_VOTES
    
    LEA DX, CANCEL_MSG
    MOV AH, 9
    INT 21H
    CALL CONTINUE_OR_EXIT
    JMP MAIN_MENU
    
RESET_VOTES:
    MOV VOTES_A, 0
    MOV VOTES_B, 0
    MOV VOTES_C, 0
    LEA DX, RESET_MSG
    MOV AH, 9
    INT 21H
    CALL CONTINUE_OR_EXIT
    JMP MAIN_MENU
    
CONFIRM_EXIT:
    LEA DX, CONFIRM_MSG
    MOV AH, 9
    INT 21H
    
    MOV AH, 1
    INT 21H
    CMP AL, 'Y'
    JE EXIT_PROGRAM
    CMP AL, 'y'
    JE EXIT_PROGRAM
    
    LEA DX, CANCEL_MSG
    MOV AH, 9
    INT 21H
    CALL DELAY
    JMP MAIN_MENU
    
INVALID_CHOICE:
    LEA DX, INVALID_MSG
    MOV AH, 9
    INT 21H
    CALL DELAY
    JMP MAIN_MENU
    
EXIT_PROGRAM:
    LEA DX, EXIT_MSG
    MOV AH, 9
    INT 21H
    MOV AH, 4CH
    INT 21H

CONTINUE_OR_EXIT PROC
    LEA DX, CONTINUE_MSG
    MOV AH, 9
    INT 21H

    MOV AH, 1
    INT 21H
    CMP AL, 'N'
    JE EXIT_PROGRAM
    CMP AL, 'n'
    JE EXIT_PROGRAM
    RET
CONTINUE_OR_EXIT ENDP

DELAY PROC
    ; Simple delay procedure
    MOV CX, 0FFFFH
DELAY_LOOP:
    LOOP DELAY_LOOP
    RET
DELAY ENDP

END MAIN

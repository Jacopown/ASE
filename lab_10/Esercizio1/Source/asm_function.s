
			; i primi 4 parametri passati dalla funzione sono contenuti nei registri R0-R4
			; se ci fossero pi� di 4 parametri, dopo il quarto sono all'interno dello stack
			; il risultato finale � quello presente all'interno di R0

			;LDR/STR 32 bit (4 byte)
			;LDRB/STRB 8 bit (1 byte)
			;LDRH/STRH 16 bit (2 byte)
			;LDRSB 8 bit (signed 1 byte)
			;LDRSH 16 bit (signed 2 byte)
			;LDRD/STRD 2*32 bit (two words)
			;LDM/SDM multiple registers

			;unsigned char 32 bit

			;load/store <Rd>, [<Rn>], <offset> Rn è modificato aggiungendo l'offset dopo
			;load/store <Rd>, [<Rn>, <offset>] Rn non è modificato aggiungendo l'offset dopo
			;SPACE 1 => alloca 1 byte (usato per riservare spazio per modificare un vettore/variabile)
			;DCB alloca uno o più byte
			;DCD alloca una o più parole, dove ogni parola è di 32 bit
			;DCW alloca una o più halfwords, dove ogni halfword è di 16 bit

			;prendere l'indirizzo di un vettore: LDR R3, =name_vector
			;prendere il contenuto sapendo l'indirizzo: LDR R2, [R3]

			;uso di EQU: name EQU 5

			;nostra area di memoria
			AREA my_area, CODE, READWRITE
			;nostra area per poter modificare le variabili in memoria

			AREA asm_functions, CODE, READONLY
			EXPORT name_function_assembler

;nome	RN R4
;nome	RN R4

name_function_assembler

			; save current SP for a faster access
			; to parameters in the stack
			MOV R12, SP
			; save volatile registers
			STMFD SP!, {R4-R8, R10-R11, LR}
			
			MOV R4, #0
			MOV R5, #0
			MOV R6, #0
			MOV R7, #0
			MOV R8, #0
			MOV R9, #0
			MOV R10, #0
			MOV R11, #0
			; my code here

			; setup a value for R0 to return
			MOV R0, R5
			; restore volatile registers
			LDMFD SP!, {R4-R8, R10-R11, PC}

;definizione literal pool
		;LTORG

;my_constant DCB 4,5,5

			END
 
 
 /*
 * Set di Istruzioni ARM
 * Le istruzioni ARM si dividono in categorie principali per la gestione dei dati, 
 * il controllo di flusso, l'accesso alla memoria e altro. Di seguito, l'elenco completo:
 *
 * 1. **Istruzioni Aritmetiche**:
 *    - ADD: Addizione.
 *    - ADC: Addizione con carry.
 *    - SUB: Sottrazione.
 *    - SBC: Sottrazione con carry.
 *    - RSB: Sottrazione inversa.
 *    - MUL: Moltiplicazione (32 bit).
 *    - UMULL: Moltiplicazione senza segno (64 bit).
 *    - SMULL: Moltiplicazione con segno (64 bit).
 *    - MLA: Moltiplicazione con accumulo.
 *    - MLS: Moltiplicazione con sottrazione.
 *    - UDIV: Divisione senza segno.
 *    - SDIV: Divisione con segno.
 *
 * 2. **Istruzioni Logiche**:
 *    - AND: Operazione logica AND.
 *    - ORR: Operazione logica OR.
 *    - EOR: Operazione logica XOR.
 *    - BIC: Bit clear (AND NOT).
 *    - ORN: OR con NOT.
 *    - MVN: Negazione (NOT).
 *
 * 3. **Istruzioni di Confronto**:
 *    - CMP: Confronta registri sottraendo.
 *    - CMN: Confronta registri sommando.
 *    - TST: Testa bit (AND).
 *    - TEQ: Testa equivalenza (XOR).
 *		
 *    -VEDERE SU UN NUMERO E' PARI O DISPARI
 * 
 *		TST R0, #1         ; Testa il bit meno significativo di R0
 *		BEQ pari           ; Se è 0 (pari), salta a 'pari'
 *		B   dispari        ; Altrimenti salta a 'dispari'
 *
 *
 *
 * 4. **Istruzioni di Shift e Rotazione**:
 *    - LSL: Shift logico a sinistra.
 *    - LSR: Shift logico a destra.
 *    - ASR: Shift aritmetico a destra.
 *    - ROR: Rotazione a destra.
 *    - RRX: Rotazione a destra con estensione.
 *
 * 5. **Istruzioni di Accesso alla Memoria**:
 *    - LDR: Carica un valore dalla memoria.
 *    - STR: Salva un valore in memoria.
 *    - LDRB: Carica un byte.
 *    - STRB: Salva un byte.
 *    - LDRH: Carica una mezza parola (16 bit).
 *    - STRH: Salva una mezza parola (16 bit).
 *    - LDRD: Carica due registri.
 *    - STRD: Salva due registri.
 *
 * 6. **Istruzioni di Branch (Salti)**:
 *    - B: Salto incondizionato.
 *    - BL: Salto con link (per subroutine).
 *    - BX: Salto indiretto.
 *    - BLX: Salto indiretto con link.
 *    - CBZ: Confronta e salta se zero.
 *    - CBNZ: Confronta e salta se non zero.
 *
 * 7. **Istruzioni di Controllo**:
 *    - MOV: Sposta un valore.
 *    - MVN: Sposta il complemento a uno.
 *    - MRS: Copia un registro di stato in un registro generico.
 *    - MSR: Copia un registro generico in un registro di stato.
 *    - NOP: Nessuna operazione.
 *
 * 8. **Pseudo-istruzioni**:
 *    - ADR: Calcola un indirizzo relativo al Program Counter.
 *    - ADRL: Calcola un indirizzo relativo (range esteso).
 *    - LDR con costante: Utilizza un literal pool per caricare valori immediati.
 *
 * 9. **Istruzioni di Esecuzione Condizionale**:
 *    Tutte le istruzioni possono essere condizionate usando suffissi:
 *    - EQ (uguale), NE (diverso), GT (maggiore), LT (minore), GE (maggiore o uguale), LE (minore o uguale).
 *
 * 10. **Istruzioni di Sistema**:
 *    - CPS: Cambia modalità di privilegio.
 *    - SVC: Chiamata a un servizio (supervisor call).
 *    - BKPT: Interruzione per debugging.
 *
 * 11. **Istruzioni IT (If-Then)**:
 *    - IT: Permette di eseguire fino a quattro istruzioni in modo condizionale senza branch.
 *
 * Ogni istruzione ARM può essere utilizzata in modalità condizionale, aumentando la flessibilità del codice.
 */
 
 /*
 * Utilizzo delle Espressioni Condizionali e del Suffisso "S" in ARM Assembly
 *
 * In ARM Assembly, ogni istruzione può essere eseguita in modo condizionale,
 * utilizzando un suffisso condizionale basato sui flag impostati nel registro CPSR (Current Program Status Register).
 * Inoltre, è possibile aggiornare i flag di condizione usando il suffisso "S" nelle istruzioni.
 *
 * Principali Condizioni:
 * - EQ: Equal (uguale)         -> Z = 1 (flag Zero impostato, risultato uguale a 0).
 * - NE: Not Equal (diverso)    -> Z = 0 (flag Zero non impostato).
 * - GT: Greater Than (maggiore) -> Z = 0 e N = V (no overflow, risultato maggiore di 0).
 * - LT: Less Than (minore)      -> N != V (risultato minore di 0).
 * - GE: Greater or Equal (maggiore o uguale) -> N = V.
 * - LE: Less or Equal (minore o uguale)      -> Z = 1 oppure N != V.
 * - HI: Unsigned Higher (unsigned maggiore)  -> C = 1 e Z = 0.
 * - LS: Unsigned Lower or Same (unsigned minore o uguale) -> C = 0 o Z = 1.
 * - AL: Always (sempre)       -> Nessuna condizione, istruzione eseguita sempre.
 * - VS: Overflow Set          -> V = 1 (overflow verificato).
 * - VC: Overflow Clear        -> V = 0 (nessun overflow).
 * - MI: Negative (negativo)   -> N = 1 (numero negativo).
 * - PL: Positive or Zero      -> N = 0 (numero positivo o zero).
 *
 * Suffisso "S" per l'aggiornamento dei flag di condizione:
 * Per default, le operazioni di elaborazione dati non influenzano i flag di condizione, ad eccezione delle istruzioni di confronto
 * (come CMP e TST). Per aggiornare i flag di condizione dopo un'operazione, è necessario aggiungere il suffisso "S" all'istruzione.
 * Ad esempio:
 *   - ADDS r0, r1, r2  ; Esegue r0 = r1 + r2 e aggiorna i flag.
 *   - SUBS r3, r4, r5  ; Esegue r3 = r4 - r5 e aggiorna i flag.
 *
 * Esempio di flag aggiornati:
 * Dopo `ADDS r0, r1, r2`:
 * - Z = 1 se il risultato è 0.
 * - N = 1 se il risultato è negativo (MSB = 1).
 * - C = 1 se c'è un carry out nella somma.
 * - V = 1 se c'è overflow nel risultato.
 *
 * Sintassi Condizionale:
 * L'istruzione viene seguita dal suffisso condizionale. Ad esempio:
 *   - ADDEQ r0, r1, r2  ; Esegue r0 = r1 + r2 solo se il flag Zero è impostato.
 *   - SUBNE r3, r4, r5  ; Esegue r3 = r4 - r5 solo se il flag Zero non è impostato.
 *
 * Esempi di utilizzo:
 * 1. Confronto e condizione:
 *    CMP r0, #10          ; Confronta r0 con 10.
 *    MOVEQ r1, #1         ; Se r0 == 10, r1 = 1.
 *    MOVNE r1, #0         ; Altrimenti, r1 = 0.
 *
 * 2. Esecuzione Condizionale Multipla con "IT" (If-Then):
 *    L'istruzione `IT` consente di applicare condizioni fino a 4 istruzioni consecutive:
 *    Sintassi: IT<x> <condizione>
 *    - x specifica il numero di istruzioni condizionali (da 1 a 4) e il loro orientamento (T = vera, E = falsa).
 *    Esempio:
 *    CMP r0, #0           ; Confronta r0 con 0.
 *    ITT NE               ; Se r0 != 0, esegui le due istruzioni successive.
 *    MOVNE r1, #1         ; r1 = 1 se r0 != 0.
 *    STRNE r1, [r2]       ; Salva r1 in memoria se r0 != 0.
 *
 * 3. Rimozione di branch penalty:
 *    Utilizzando le condizioni direttamente sulle istruzioni, puoi evitare branch non necessari.
 *    Esempio (calcolo valore assoluto):
 *    CMP r0, #0           ; Confronta r0 con 0.
 *    IT GE                ; Blocca "If-Then" con condizione GE (>=).
 *    MOVEQ r0, r0         ; Mantieni r0 se >= 0.
 *    NEGGT r0, r0         ; Altrimenti, r0 = -r0.
 *
 * Vantaggi:
 * - Migliora la densità del codice, riducendo il numero di branch.
 * - Riduce la "branch penalty" (penalità dovuta ai salti nel flusso di esecuzione).
 * - Incrementa la leggibilità per operazioni condizionali semplici.
 */



/*
 * Utilizzo dell'Istruzione IT (If-Then) in ARM Assembly
 *
 * L'istruzione IT consente di eseguire fino a 4 istruzioni in modo condizionale 
 * senza dover effettuare salti (branch). Questo migliora l'efficienza riducendo 
 * la branch penalty e aumentando la densità del codice.
 *
 * Sintassi:
 * IT<x><y><z> <condizione>
 * - <x>, <y>, <z>: Specificano il numero di istruzioni nel blocco IT (fino a 4)
 *   e il loro orientamento:
 *   - T: Esegui l'istruzione se la condizione è vera.
 *   - E: Esegui l'istruzione se la condizione è falsa.
 * - <condizione>: Una condizione ARM standard (ad esempio, EQ, NE, GT, ecc.).
 *
 * Regole principali:
 * 1. Massimo 4 istruzioni possono essere condizionate.
 * 2. Le istruzioni all'interno dell'IT Block devono essere consecutive.
 * 3. Non sono permessi salti all'interno del blocco.
 * 4. Non tutte le istruzioni possono aggiornare i flag di condizione all'interno del blocco.
 *
 * Esempi:
 *
 * 1. **Eseguire due istruzioni condizionalmente**
 *    Pseudocodice:
 *    if (r0 == 0) {
 *        r1 = 1;
 *        r2 = 2;
 *    }
 *
 *    Assembly:
 *    CMP r0, #0        ; Confronta r0 con 0
 *    ITT EQ            ; IT Block: due istruzioni condizionate se EQ (uguale)
 *    MOVEQ r1, #1      ; Assegna 1 a r1 se r0 == 0
 *    MOVEQ r2, #2      ; Assegna 2 a r2 se r0 == 0
 *
 * 2. **Istruzioni alternate condizionali**
 *    Pseudocodice:
 *    if (r0 >= r1) {
 *        r2 = r3;
 *    } else {
 *        r2 = r4;
 *    }
 *
 *    Assembly:
 *    CMP r0, r1        ; Confronta r0 con r1
 *    ITE GE            ; IT Block: una istruzione se GE (>=), una se LT (<)
 *    MOVGE r2, r3      ; r2 = r3 se r0 >= r1
 *    MOVLT r2, r4      ; r2 = r4 se r0 < r1
 *
 * 3. **Valore assoluto**
 *    Pseudocodice:
 *    if (r0 < 0) {
 *        r0 = -r0;
 *    }
 *
 *    Assembly:
 *    CMP r0, #0        ; Confronta r0 con 0
 *    IT LT             ; IT Block: una istruzione condizionale se LT (minore)
 *    NEGLT r0, r0      ; r0 = -r0 se r0 < 0
 *
 * 4. **Rimozione della branch penalty**
 *    Pseudocodice:
 *    if (r0 == 0) {
 *        r1 = r1 + r2;
 *    } else {
 *        r3 = r3 - r4;
 *    }
 *
 *    Assembly:
 *    CMP r0, #0        ; Confronta r0 con 0
 *    ITE EQ            ; IT Block: una istruzione se EQ, una se NE
 *    ADDEQ r1, r1, r2  ; r1 = r1 + r2 se r0 == 0
 *    SUBNE r3, r3, r4  ; r3 = r3 - r4 se r0 != 0
 *
 * Vantaggi:
 * - Riduce la branch penalty eliminando salti non necessari.
 * - Migliora la leggibilità del codice per condizioni semplici.
 * - Incrementa l'efficienza nelle operazioni condizionali.
 */




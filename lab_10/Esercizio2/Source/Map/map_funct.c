#include "map.h"
#include "RIT/RIT.h"

#define ScoreX 100
#define ScoreY 0

volatile int rowPac;
volatile int colPac;

volatile int rowGhost;
volatile int colGhost;

volatile int joyStickDirection = 4;
volatile int lastDirection;
volatile int score; 
volatile int lifes;
volatile int nextLifeScore = 1000;
volatile int started;

volatile int timeGenerationPP;

volatile int nPills;
volatile int powerPills = 6;

volatile int chase = 1;
volatile int secondsChase = 10;
volatile int secondsRegeneration = 3;
volatile int eatenGhost = 0; 

extern volatile gamePaused;
extern volatile finished;

//extern  int pacman_death_event;  // Evento morte di Pac-Man
//extern int powerpill_event;     // Evento Powerpill

void countPills(volatile int map [ROWS][COLUMNS]){
	int i; 
	for ( i = 0; i < ROWS; i++) {
		int j;
		for ( j = 0; j < COLUMNS; j++) {
			if (map[i][j] == 0){
				nPills ++ ;
			}
		}
	}
}

/*void drawPill(int row, int col) {
    int startX = (col + 1) * 8; // Calcola la posizione iniziale X basata su colonna
    int startY = (row + 3) * 8; // Calcola la posizione iniziale Y basata su riga
    int x, y;

    // Disegna il quadratino centrale (pill)
    for (y = startY + 3; y < startY + 5; y++) { // Quadrato di 2x2 pixel
        for (x = startX + 3; x < startX + 5; x++) {
            LCD_SetPoint(x, y, 0xFFFF);  // Colore rosa (codice colore esadecimale)
        }
    }

    // Imposta il valore della mappa nel punto specificato a 0
    map[row][col] = 0; 
}*/



void colorMapOnLCD(volatile int map[ROWS][COLUMNS]) {
	nPills=0;
	countPills(map);
	//generatePowerPills(map);
	 srand(LPC_TIM1->TC);
	timeGenerationPP = rand()%40; 
	printLifes(lifes);
	int i; 
	for ( i = 0; i < ROWS; i++) {
		int j;
		for ( j = 0; j < COLUMNS; j++) {
				int startX = (j + 1) * 8; // Spostata di una cella a destra
        int startY = (i + 3) * 8; // Spostata di 3 celle verso il basso
				if (map[i][j] == 1) {  // Se il valore nella matrice è 1
					// Disegna un quadrato di 8x8 pixel
					int x, y;
					for (y = startY; y < startY + 8; y++) { // Righe del quadrato
							for (x = startX; x < startX + 8; x++) { // Colonne del quadrato
									LCD_SetPoint(x, y, 0x001F);  // Blu
							}
					}
				}else if (map[i][j] == 0) {
								
                // Disegna un quadrato 4x4 pixel  al centro della cella
                int x, y;
                for (y = startY + 3; y < startY + 5; y++) { // Quadrato centrale
                    for (x = startX + 3; x < startX + 5; x++) {
                        LCD_SetPoint(x, y, 0xFFFF);  // rosa
                    }
                }
				}else if (map[i][j] == 3) {
					
					// Disegna un quadrato 6x6 pixel rosa al centro della cella
					int x, y;
					for (y = startY + 1; y < startY + 7; y++) { // Righe del quadrato
							for (x = startX + 1; x < startX + 7; x++) { // Colonne del quadrato
									LCD_SetPoint(x, y, 0xF9B0);  // Colore rosa
							}
						}
				}else if (map[i][j] == 5) {
					
					rowPac = i;
					colPac = j;
					
					drawPacman(rowPac, colPac);
				}
				else if (map[i][j] == 6){
					
					rowGhost = i;
					colGhost = j;
					
					drawGhost(rowGhost, colGhost);
				}
	}
	
}
}

	

void generatePowerPills(volatile int map[ROWS][COLUMNS]) {
   
	int foundPlace = 0;
	
		
    // Continua a generare finché non si raggiungono 6 Power Pills
		if  (powerPills > 0) {
			while ( foundPlace == 0){
			// Imposta il seme per il generatore di numeri casuali basato su Timer0
				int seed = LPC_TIM1->TC + nPills + colPac + rowPac; 
				srand(seed); 
				int randomRow = rand() % ROWS;     // Indice riga casuale
				int randomCol = rand() % COLUMNS; // Indice colonna casuale


				// Sostituisci solo se il valore corrente della cella è 0
				if (map[randomRow][randomCol] == 0) {
						map[randomRow][randomCol] = 3;  // Sostituisci con il valore della Power Pill
						powerPills--;
						foundPlace = 1;// Incrementa il contatore
			}
			}
			
    }
		
		printPowerPills();
	
}

int isDirectionValid(int row, int col, int direction) {
    int newRow = row;
    int newCol = col;

    switch (direction) {
        case 0: newRow++; break; // giù
        case 1: newCol--; break; // sinistra
        case 2: newCol++; break; // destra
        case 3: newRow--; break; // su
        default: return 0; // Direzione non valida
    }

    // Controlla se la cella è un muro o un teletrasporto
    return (map[newRow][newCol] != 1 && map[newRow][newCol] != 9);
}


void movePacman() {
    int newRow = rowPac;
    int newCol = colPac;

    // Cambia direzione solo se quella del joystick è valida
    if (joyStickDirection != -1 && isDirectionValid(rowPac, colPac, joyStickDirection)) {
        lastDirection = joyStickDirection;
    }

    // Determina la nuova posizione in base alla direzione
    switch (lastDirection) {
        case 0: // giù
            newRow++;
            break;
        case 1: // sinistra
            newCol--;
            break;
        case 2: // destra
            newCol++;
            break;
        case 3: // su
            newRow--;
            break;
        default:
            break;
    }

    // Se la cella non è un muro (1) o un teletrasportatore (9)
    if (map[newRow][newCol] != 1 && map[newRow][newCol] != 9) {
        // Gestione della raccolta dei punti
        if (map[newRow][newCol] == 0) {
            score += 10;
        } else if (map[newRow][newCol] == 3) {
            score += 50;
						chase = 0;
						//powerpill_event=1; 
        }
				if (newRow == rowGhost && newCol==colGhost && !chase){
					score += 100;
					eatenGhost = 1;
				}

        // Controlla se il punteggio ha raggiunto o superato il prossimo valore per una vita extra
        if (score >= nextLifeScore) {
            lifes++;
            nextLifeScore += 1000;  // Incrementa il punteggio necessario per la prossima vita
            printLifes(lifes);
        }

        // Aggiorna il numero di pillole rimanenti
        if (map[newRow][newCol] == 0 || map[newRow][newCol] == 3) {
            nPills--;
        }

        // Se tutte le pillole sono state raccolte, mostra vittoria
        if (nPills == 0) {
            reset_timer(0);
            disable_timer(0);
            reset_timer(1);
            disable_timer(1);
            char secondsStr[20];
            LCD_Clear(0x0000);
            sprintf(secondsStr, "VICTORY");
            disable_RIT();
            GUI_Text(100, 140, (uint8_t *)secondsStr, 0xFFFF, 0x0000);
            enable_RIT();
            finished = 1;
            return;
        }

        // Aggiorna la visualizzazione del punteggio
        char scoreStr[20];
        sprintf(scoreStr, "Score: %d", score);
        disable_RIT();
        GUI_Text(ScoreX, ScoreY, (uint8_t *)scoreStr, 0xFFFF, 0x0000);
        enable_RIT();

        // Aggiorna Pac-Man nella nuova posizione
        drawPacman(newRow, newCol);
        clearCell(rowPac, colPac);
        rowPac = newRow;
        colPac = newCol;
    }

    // Se la cella contiene un teletrasportatore (9)
    if (map[newRow][newCol] == 9) {
        if (newCol == 0) {
            newCol = COLUMNS - 1;  // Teletrasporto alla colonna opposta
        } else {
            newCol = 0;  // Teletrasporto alla prima colonna
        }

        // Cancella la vecchia posizione
        clearCell(rowPac, colPac);

        // Aggiorna le coordinate di Pac-Man alla nuova colonna teletrasportata
        colPac = newCol;

        // Ridisegna Pac-Man nella nuova posizione teletrasportata
        drawPacman(rowPac, colPac);
    }
}


void printPowerPills(){
	
	int i; 
	for ( i = 0; i < ROWS; i++) {
		int j;
		for ( j = 0; j < COLUMNS; j++) {
				
				if (map[i][j] == 3) {
					// Spostata di 3 celle verso il basso
					int startX = (j + 1) * 8; // Spostata di una cella a destra
					int startY = (i + 3) * 8; 
					
					
					int centerX = startX + 4; // Centro della cella lungo X
					int centerY = startY + 4; // Centro della cella lungo Y
					int radius = 3;           // Raggio della Power Pill (più piccolo del Pacman)

					int x, y;
					for (y = startY; y < startY + 8; y++) {
							for (x = startX; x < startX + 8; x++) {
									// Verifica se il punto (x, y) è all'interno del cerchio
									if (((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY)) <= (radius * radius)) {
											LCD_SetPoint(x, y, 0xFFFF);  // Colore rosa per la Power Pill
									}
							}
					}
				}
			}
		}
	
}


void drawPacman(int row, int col) {
    // Calcola il centro del cerchio in base alla posizione di Pacman
    int startX = (col + 1) * 8; // Spostata di una cella a destra
    int startY = (row + 3) * 8; // Spostata di 3 celle verso il basso

    int centerX = startX + 4; // Centro della cella lungo X
		int centerY = startY + 4; // Centro della cella lungo Y
		int radius = 4;           // Raggio del cerchio
		int x, y;

		for (y = startY; y < startY + 8; y++) {
				for (x = startX; x < startX + 8; x++) {
						// Verifica se il punto (x, y) è all'interno del cerchio
						if (((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY)) <= (radius * radius)) {
								LCD_SetPoint(x, y, 0xFFE0);  // Giallo
						}
				}
    }
}

void drawGhost(int row, int col) {
    // Calcola la posizione iniziale della cella
    int startX = (col + 1) * 8; // Spostata di una cella a destra
    int startY = (row + 3) * 8; // Spostata di 3 celle verso il basso

    int centerX = startX + 4; // Centro della cella lungo X
    int centerY = startY + 3; // Centro del semicerchio superiore
    int radius = 4;           // Raggio del semicerchio superiore
    int x, y;

    // Disegna la parte superiore del fantasma (semicerchio)
    for (y = startY; y < startY + 4; y++) { // Altezza del semicerchio: 4 pixel
        for (x = startX; x < startX + 8; x++) {
            // Verifica se il punto (x, y) è all'interno del semicerchio
            if (((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY)) <= (radius * radius)) {
							if(chase==0){
                LCD_SetPoint(x, y, 0x07E0); // verde
							}
							else
								LCD_SetPoint(x, y, 0xF800); // rosso

            }
        }
    }

    // Disegna la parte inferiore rettangolare del fantasma
    for (y = startY + 4; y < startY + 8; y++) { // Altezza del rettangolo: 4 pixel
        for (x = startX; x < startX + 8; x++) {
           if(chase==0){
                LCD_SetPoint(x, y, 0x07E0); // verde
							}
							else
								LCD_SetPoint(x, y, 0xF800); // rosso
        }
    }

    // Disegna \"onde\" per il bordo inferiore del fantasma
    for (x = startX; x < startX + 8; x++) {
        if ((x - startX) % 2 == 0) { // Disegna onde alternando i pixel
            LCD_SetPoint(x, startY + 6, 0x0000); // Nero per creare le onde
						LCD_SetPoint(x, startY + 7, 0x0000); // Nero per creare le onde

        }
    }
}


void clearCell(int row, int col) {
    int startX = (col + 1) * 8; // Posizione iniziale X
    int startY = (row + 3) * 8; // Posizione iniziale Y
    int x, y;

    // Cancella il contenuto della cella disegnando un rettangolo nero
    for (y = startY; y < startY + 8; y++) {
        for (x = startX; x < startX + 8; x++) {
            LCD_SetPoint(x, y, 0x0000);  // Nero
        }
    }

    // Controlla se le coordinate corrispondono a rowGhost e colGhost
    if (row == rowGhost && col == colGhost) {
        if (map[row][col] == 3) { // Disegna la Power Pill
            int centerX = startX + 4; // Centro della cella lungo X
            int centerY = startY + 4; // Centro della cella lungo Y
            int radius = 3;          // Raggio della Power Pill

            for (y = startY; y < startY + 8; y++) {
                for (x = startX; x < startX + 8; x++) {
                    // Verifica se il punto (x, y) è all'interno del cerchio
                    if (((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY)) <= (radius * radius)) {
                        LCD_SetPoint(x, y, 0xFFFF);  // Rosa per la Power Pill
                    }
                }
            }
        } else if (map[row][col] == 0) { // Disegna una pillola normale
            for (y = startY + 3; y < startY + 5; y++) { // Quadrato centrale
                for (x = startX + 3; x < startX + 5; x++) {
                    LCD_SetPoint(x, y, 0xFFFF);  // Rosa per la pillola
                }
            }
        }
        // Non modificare il valore della mappa in questo caso
        return;
    }

    // Se non corrisponde a rowGhost e colGhost, svuota la cella nella mappa
    if (map[row][col] != 9) {
        map[row][col] = 2; // Imposta la cella come vuota (2)
    }
}


void printLifes(int lifes) {
    int startX = 0;                // Posizione iniziale X del primo cerchio
    int startY = (ROWS + 4) * 8;   // Posizione iniziale Y di tutti i cerchi
    int spacing = 12;              // Spaziatura tra i centri dei cerchi
    int i;

    // Cancella tutte le vite (lifes + 1 per includere una vita extra eventualmente visibile)
    for (i = 0; i < lifes + 1; i++) {
        int centerX = startX + i * spacing + 4; // Calcola il centro del cerchio i-esimo lungo X
        int centerY = startY + 4;              // Centro del cerchio lungo Y
        int radius = 4;                        // Raggio del cerchio
        int y;

        for (y = startY; y < startY + 8; y++) {
            int x;
            for (x = startX + i * spacing; x < startX + i * spacing + 8; x++) { // Usa i * spacing
                // Verifica se il punto (x, y) è all'interno del cerchio
                if (((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY)) <= (radius * radius)) {
                    LCD_SetPoint(x, y, 0x0000); // Cancella il punto con colore nero
                }
            }
        }
    }

    // Disegna le vite rimanenti
    for (i = 0; i < lifes; i++) {
        int centerX = startX + i * spacing + 4; // Calcola il centro del cerchio i-esimo lungo X
        int centerY = startY + 4;              // Centro del cerchio lungo Y
        int radius = 4;                        // Raggio del cerchio
        int y;

        for (y = startY; y < startY + 8; y++) {
            int x;
            for (x = startX + i * spacing; x < startX + i * spacing + 8; x++) { // Usa i * spacing
                // Verifica se il punto (x, y) è all'interno del cerchio
                if (((x - centerX) * (x - centerX) + (y - centerY) * (y - centerY)) <= (radius * radius)) {
                    LCD_SetPoint(x, y, 0xFFE0); // Disegna il punto giallo
                }
            }
        }
    }
}



// Struttura per rappresentare un nodo
typedef struct {
    int row, col;  // Coordinate del nodo
    int gCost;     // Costo g (distanza dal punto di partenza)
    int hCost;     // Costo h (distanza stimata fino alla destinazione)
    int fCost;     // Costo f (gCost + hCost)
    int parentRow; // Riga del nodo genitore
    int parentCol; // Colonna del nodo genitore
} Node;

volatile int openSet[ROWS * COLUMNS][2];  // Array per i nodi da esplorare
volatile int closedSet[ROWS][COLUMNS];    // Mappa dei nodi esplorati
volatile Node nodes[ROWS][COLUMNS];       // Mappa dei nodi

// Funzione per calcolare la distanza Manhattan
int manhattanDistance(int row1, int col1, int row2, int col2) {
    return abs(row1 - row2) + abs(col1 - col2);
}

void updateGhost() {
    // Inizializza openSet
    int openSetSize = 0;  

    // Inizializza il nodo iniziale (posizione del fantasma)
    nodes[rowGhost][colGhost] = (Node){rowGhost, colGhost, 0, 0, 0, -1, -1};
    openSet[openSetSize][0] = rowGhost;
    openSet[openSetSize][1] = colGhost;
    openSetSize++;

    // Inizializza manualmente l'array closedSet a zero
		int i;
    for (i = 0; i < ROWS; i++) {
				int j;
        for (j = 0; j < COLUMNS; j++) {
            closedSet[i][j] = 0;
            nodes[i][j] = (Node){-1, -1, 0, 0, 0, -1, -1};  // Inizializza i nodi
        }
    }

    // Direzioni per il movimento: giù, sinistra, destra, su
    int directions[4][2] = {
        {1, 0},  // giù
        {0, -1}, // sinistra
        {0, 1},  // destra
        {-1, 0}  // su
    };

    // Verifica la distanza di Manhattan tra il fantasma e Pac-Man
    int distance = manhattanDistance(rowGhost, colGhost, rowPac, colPac);

    while (openSetSize > 0) {
        // Trova il nodo con il fCost più basso o più alto nell'openSet in base a `chase`
        int currentIndex = 0;
				int m;
        for (m = 1; m < openSetSize; m++) {
            int row = openSet[m][0];
            int col = openSet[m][1];
            if ((chase && nodes[row][col].fCost < nodes[openSet[currentIndex][0]][openSet[currentIndex][1]].fCost) ||
                (!chase && nodes[row][col].fCost > nodes[openSet[currentIndex][0]][openSet[currentIndex][1]].fCost)) {
                currentIndex = m;
            }
        }

        // Rimuovi il nodo corrente dall'openSet
        int currentRow = openSet[currentIndex][0];
        int currentCol = openSet[currentIndex][1];
        openSet[currentIndex][0] = openSet[--openSetSize][0];
        openSet[currentIndex][1] = openSet[openSetSize][1];

        // Aggiungi il nodo corrente al closedSet
        closedSet[currentRow][currentCol] = 1;

        // Se il fantasma ha raggiunto o si è allontanato abbastanza da Pac-Man, interrompi
        if (chase && currentRow == rowPac && currentCol == colPac) {
            break;
        }
        if (!chase && manhattanDistance(currentRow, currentCol, rowPac, colPac) > ROWS + COLUMNS) {
            break;
        }

        // Esplora i vicini
				int n;
        for (n = 0; n < 4; n++) {
            int neighborRow = currentRow + directions[n][0];
            int neighborCol = currentCol + directions[n][1];

            // Controlla se il vicino è valido e non esplorato
            if (isDirectionValid(currentRow, currentCol, n) && !closedSet[neighborRow][neighborCol]) {
                int tentativeGCost = nodes[currentRow][currentCol].gCost + 1;

                // Se il nodo vicino non è nell'openSet o ha un gCost minore, aggiornalo
                if (nodes[neighborRow][neighborCol].gCost == 0 || 
                    tentativeGCost < nodes[neighborRow][neighborCol].gCost) {
                    nodes[neighborRow][neighborCol] = (Node){
                        neighborRow, neighborCol,
                        tentativeGCost,
                        chase ? manhattanDistance(neighborRow, neighborCol, rowPac, colPac)
                              : -manhattanDistance(neighborRow, neighborCol, rowPac, colPac),
                        tentativeGCost + manhattanDistance(neighborRow, neighborCol, rowPac, colPac),
                        currentRow, currentCol
                    };

                    // Aggiungi il nodo vicino all'openSet
                    openSet[openSetSize][0] = neighborRow;
                    openSet[openSetSize][1] = neighborCol;
                    openSetSize++;
                }
            }
        }
    }

    // Ricostruisci il percorso
    int newRow = rowPac, newCol = colPac;

    if (nodes[newRow][newCol].parentRow == -1 && nodes[newRow][newCol].parentCol == -1) {
        return;  // Nessun percorso valido
    }

    // Modalità chase: segue Pac-Man
    if (chase) {
        while (nodes[newRow][newCol].parentRow != rowGhost || nodes[newRow][newCol].parentCol != colGhost) {
            int tempRow = nodes[newRow][newCol].parentRow;
            int tempCol = nodes[newRow][newCol].parentCol;
            newRow = tempRow;
            newCol = tempCol;
        }
    } 
    // Modalità flee: si allontana da Pac-Man
     else {
        // Cerchiamo di allontanarci da Pac-Man
        int maxDistance = -1;
        int bestRow = rowGhost;
        int bestCol = colGhost;

        // Controlliamo tutte le direzioni valide
				int n;
        for (n = 0; n < 4; n++) {
            int neighborRow = rowGhost + directions[n][0];
            int neighborCol = colGhost + directions[n][1];

            // Se il movimento è valido
            if (isDirectionValid(rowGhost, colGhost, n)) {
                int newDistance = manhattanDistance(neighborRow, neighborCol, rowPac, colPac);
                
                // Se la nuova distanza è maggiore della distanza corrente, scegli quella direzione
                if (newDistance > maxDistance) {
                    maxDistance = newDistance;
                    bestRow = neighborRow;
                    bestCol = neighborCol;
                }
            }
        }

        // Imposta la nuova posizione del fantasma
        newRow = bestRow;
        newCol = bestCol;
    }


    // Cancella la vecchia posizione e aggiorna
    drawGhost(newRow, newCol);
    clearCell(rowGhost, colGhost);
    rowGhost = newRow;
    colGhost = newCol;

    if (rowGhost == rowPac && colGhost == colPac && chase) {
        if (lifes > 0) {
            lifes--;
            clearCell(rowGhost, colGhost);
            clearCell(rowPac, colPac);
            rowPac = 18;
            colPac = 13;
            rowGhost = 15;
            colGhost = 15;
            printLifes(lifes);
            drawPacman(rowPac, colPac);
            drawGhost(rowGhost, colGhost);

            gamePaused = 1;

            // Mostra il messaggio "PAUSE"
            disable_RIT();
            GUI_Text(200, 0, (uint8_t *)"PAUSE", 0xFFFF, 0x0000);  // Testo bianco con sfondo nero
            enable_RIT();
            // Disabilita i timer
            disable_timer(0);
            disable_timer(1);
            disable_timer(2);
        } else {
            reset_timer(1);
            disable_timer(1);
            terminateGame();
        }
    }
}



void terminateGame(){
			finished = 1;
			reset_timer(0);
			disable_timer(0);
			reset_timer(1);
			disable_timer(1);
			reset_timer(2);
			disable_timer(2);
			char secondsStr[20];  // La stringa per il punteggio (assumiamo che il punteggio non superi i 20 caratteri)
			LCD_Clear(0x0000);
			sprintf(secondsStr, "GAME OVER");
			disable_RIT();
			GUI_Text(80,140, (uint8_t *)secondsStr,0xFFFF, 0x0000);
			enable_RIT();
}





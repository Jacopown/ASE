#define COLUMNS 28
#define ROWS 33


#include "LPC17xx.h"
#include <stdlib.h>  // Per srand() e rand()
#include <stdio.h> // Per usare sprintf
#include "timer/timer.h"
#include <string.h> // Per memset
#include <adc/adc.h>


extern volatile int map[ROWS][COLUMNS];

void colorMapOnLCD(volatile int map[ROWS][COLUMNS]);

void generatePowerPills(volatile int map[ROWS][COLUMNS]);

void countPills(volatile int map [ROWS][COLUMNS]);

void movePacman();

void drawPacman(int row, int col);

void drawGhost(int row,int col);

void clearCell(int row, int col);

void printLifes(int lifes);

int isDirectionValid(int row, int col, int direction);

void printPowerPills();

void updateGhost() ;

void terminateGame();

void drawPill(int row,int col);

int processMovement();

int moveGhost();

void checkCollisionWithPacman();





	


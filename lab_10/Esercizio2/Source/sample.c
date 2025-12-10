/****************************************Copyright (c)****************************************************
**                                      
**                                 http://www.powermcu.com
**
**--------------File Info---------------------------------------------------------------------------------
** File name:               main.c
** Descriptions:            The GLCD application function
**
**--------------------------------------------------------------------------------------------------------
** Created by:              AVRman
** Created date:            2010-11-7
** Version:                 v1.0
** Descriptions:            The original version
**
**--------------------------------------------------------------------------------------------------------
** Modified by:             Paolo Bernardi
** Modified date:           03/01/2020
** Version:                 v2.0
** Descriptions:            basic program for LCD and Touch Panel teaching
**
*********************************************************************************************************/

/* Includes ------------------------------------------------------------------*/
#include "LPC17xx.h"
#include "GLCD/GLCD.h"
#include "TouchPanel/TouchPanel.h"
#include "timer/timer.h"
#include "RIT/RIT.h"
#include "button_EXINT/button.h"
#include "joystick/joystick.h"
#include "led/led.h"

#define SIMULATOR 1

#ifdef SIMULATOR
extern uint8_t ScaleFlag; // <- ScaleFlag needs to visible in order for the emulator to find the symbol (can be placed also inside system_LPC17xx.h but since it is RO, it needs more work)
#endif

/*
* COSE DA RICORDARE
*
* per funzione assembler, definirla nel file asm_functions.s e definire il la funzione come extern
*
* timer2 e timer3 attivare tramite wizard in system_LPC17xx.c in Power Control for Peripherals Register
*
* La frequenza nel nostro caso ? 25MHz = 25.000.000 Hz
* count = [s] * [Hz]
* 1 ms = 10^-3 s       1 ns = 10^-9 s
* 1 MHz = 10^6 Hz
*
* quando si chiede un led che lampeggi si pu? usare:
* - met? valore del match register per raggiugere il periodo richiesto
* - si dimezza il periodo richiesto ed utilizziamo una variabile locale per gestire l'on e l'off
*
* inizializzazione timer: init_timer(uint8_t timer_num, uint32_t Prescaler, uint8_t MatchReg, uint8_t SRImatchReg, uint32_t TimerInterval)
* dove SRImatchReg :
* - 1? bit (LSB) : interrupt
* - 2? bit       : reset
* - 3? bit (MSB) : stop
* (di default il registro MSR ? settato a 3 (interrup e reset)
*
* shift sinistro : <<
* shift destro : >>
*
* per prendere il valore del TimerCounter (TC) con il Timer 1:
*       val_int = LPC_TIM1 -> TC
*/

//scheletro funzione assembler
extern void name_function_assembler(int r0, int r1, int r2, int r3);
volatile uint8_t NUMBER = 0;
volatile uint8_t Timer1_Flag = 0;

int main(void)
{
  SystemInit();  												/* System Initialization (i.e., PLL)  */
	BUTTON_init();												/* Inizializzazione Buttons 					*/
  //LCD_Initialization();									/* Inizializzazione Display 					*/
	//TP_Init();														/* Inizializzazione TouchPanel 				*/
	joystick_init();											/* Inizializzazione Joystick 					*/
	LED_init();
	//TouchPanel_Calibrate();								/* Calibrazione touch display         */

	init_RIT(0x004C4B40);									/* RIT Initialization 50 msec       	*/
	enable_RIT();

	init_timer(1, 24, 0, 3, 211000);
	init_timer(2, 24, 0, 3, 307000);
			
	enable_timer(1);
	enable_timer(2);
	
	
	LPC_SC->PCON |= 0x1;									/* power-down	mode										*/
	LPC_SC->PCON &= ~(0x2);
	
  while (1)	
  {
		__ASM("wfi");
  }
}



/*
Operatori logici in C:
1. NOT (!)       : Inverte il valore logico (vero/falso).
   Esempio: int x = 1; int risultato = !x;  // risultato = 0
2. AND (&&)      : Restituisce vero (1) se entrambe le espressioni sono vere.
   Esempio: int a = 1, b = 1; int risultato = a && b;  // risultato = 1
3. OR ()       : Restituisce vero (1) se almeno una delle espressioni è vera.
   Esempio: int a = 1, b = 0; int risultato = a  b;  // risultato = 1
4. XOR logico    : Non esiste un operatore diretto, ma si può simulare:
   Sintassi: (espressione1  espressione2) && !(espressione1 && espressione2)
   Esempio: int a = 1, b = 0; int risultato = (a  b) && !(a && b);  // risultato = 1

Operatori bit a bit in C:
1. NOT (~)       : Inverte ogni bit (complemento a 1).
   Esempio: int x = 0b1100; int risultato = ~x;  // risultato = 0b...11110011
2. AND (&)       : Restituisce 1 solo dove entrambi i bit sono 1.
   Esempio: int x = 0b1100, y = 0b1010; int risultato = x & y;  // risultato = 0b1000
3. OR (|)        : Restituisce 1 se almeno uno dei bit è 1.
   Esempio: int x = 0b1100, y = 0b1010; int risultato = x | y;  // risultato = 0b1110
4. XOR (^)       : Restituisce 1 dove i bit sono diversi.
   Esempio: int x = 0b1100, y = 0b1010; int risultato = x ^ y;  // risultato = 0b0110

Operatori di spostamento bit:
1. Shift a sinistra (<<) : Sposta i bit a sinistra, riempiendo con 0.
   Esempio: int x = 0b0011; int risultato = x << 2;  // risultato = 0b1100
2. Shift a destra (>>)   : Sposta i bit a destra, riempiendo con 0 o con il bit del segno (dipende dal compilatore).
   Esempio: int x = 0b1100; int risultato = x >> 2;  // risultato = 0b0011
*/
/*********************************************************************************************************
      END FILE
*********************************************************************************************************/

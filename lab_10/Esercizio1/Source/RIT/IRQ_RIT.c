/*********************************************************************************************************
**--------------File Info---------------------------------------------------------------------------------
** File name:           IRQ_RIT.c
** Last modified Date:  2014-09-25
** Last Version:        V1.00
** Descriptions:        functions to manage T0 and T1 interrupts
** Correlated files:    RIT.h
**--------------------------------------------------------------------------------------------------------
*********************************************************************************************************/
#include "LPC17xx.h"
#include "RIT.h"
#include "../led/led.h"
#include "../timer/timer.h"
#include "../GLCD/GLCD.h"

/******************************************************************************
** Function name:		RIT_IRQHandler
**
** Descriptions:		REPETITIVE INTERRUPT TIMER handler
**
** parameters:			None
** Returned value:		None
**
******************************************************************************/
int right_activate;
int down_activate;
int left_activate;
int up_activate;
int done;


volatile int down_0 = 0;
volatile int down_1 = 0;
volatile int down_2 = 0;

extern char led_value;

void RIT_IRQHandler (void)
{					
	static int J_select = 0;
	static int J_down = 0;
	static int J_left = 0;
	static int J_right = 0;
	static int J_up = 0;
	
	if((LPC_GPIO1->FIOPIN & (1<<25)) == 0){	
		/* Joytick J_Select pressed p1.25*/
		
		J_select++;
		switch(J_select){
			case 1:
 				//code here
				break;
			default:
				break;
		}
	}
	else{
			J_select=0;
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<26)) == 0){	
		/* Joytick J_Down pressed p1.26 --> using J_DOWN due to emulator issues*/
		
		J_down++;
		switch(J_down){
			case 1:
				//code here
			down_activate =1;
			
			if (right_activate && down_activate){  // sud est
			}
			
			if( down_activate && left_activate){  // sud ovest
				//done =1; // duplica il codice anche nell altro medesimo if 
			}
			
				break;
			default:
				break;
		}
	}
	else{
			J_down=0;
			// scrivi  qui se vuoi gestire quando viene rilasciato 
			down_activate =0;
			//done =0;
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<27)) == 0){	
		/* Joytick J_Left pressed p1.27*/
		J_left++;
		switch(J_left){
			case 1:
				//code here
				left_activate =1;
			
				if(left_activate && up_activate){  // nord ovest
				}
				if( down_activate && left_activate){  // sud ovest
					//done =1;
				}
			
			
				
				break;
			default:
				break;
		}
	}
	else{
			J_left=0;
			left_activate =0;
		done =0; 
	}
	
	if((LPC_GPIO1->FIOPIN & (1<<28)) == 0){	
		/* Joytick J_right pressed p1.28*/
		
		J_right++;
		switch(J_right){
			case 1:
				//code here
			right_activate =1;
			
			if(up_activate && right_activate){ 		// nord est
				}
			if (right_activate && down_activate){  // sud est
			}
			
				break;
			default:
				break;
		}
	}
	else{
			J_right=0;
			right_activate =0;

	}
	
	if((LPC_GPIO1->FIOPIN & (1<<29)) == 0){	
		/* Joytick J_up pressed p1.29*/
		
		J_up++;
		switch(J_up){
			case 1:
				//code here
				up_activate =1;
				if(left_activate && up_activate){  // nord ovest
				}
				if (up_activate && right_activate){ // nord est
				}
				
			
				break;
			default:
				break;
		}
	}
	else{
			J_up=0;
			up_activate = 0;
	}
	
	
	/* button management */
	if(down_0 != 0){
		down_0++; 
		if((LPC_GPIO2->FIOPIN & (1<<10)) == 0){	/* INT0 pressed */			
			switch(down_0){
				case 2:				
					//code here
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			down_0=0;			
			NVIC_EnableIRQ(EINT0_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 20);     /* External interrupt 0 pin selection */
		}
	}
	
	if(down_1!=0){ 
		down_1++;
		if((LPC_GPIO2->FIOPIN & (1<<11)) == 0){	/* KEY1 pressed */			
			switch(down_1){
				case 2:				
					
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			down_1=0;			
			NVIC_EnableIRQ(EINT1_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 22);     /* External interrupt 0 pin selection */
		}
	}
	
	if(down_2 != 0){
		down_2++;	
		if((LPC_GPIO2->FIOPIN & (1<<12)) == 0){	/* KEY2 pressed */			
			switch(down_2){
				case 2:		
					//code here
					break;
				default:
					break;
			}
		}
		else {	/* button released */
			down_2=0;			
			NVIC_EnableIRQ(EINT2_IRQn);							 /* enable Button interrupts			*/
			LPC_PINCON->PINSEL4    |= (1 << 24);     /* External interrupt 0 pin selection */
		}
		
	}
	reset_RIT();
  LPC_RIT->RICTRL |= 0x1;	/* clear interrupt flag */
	
  return;
}

/******************************************************************************
**                            End Of File
******************************************************************************/

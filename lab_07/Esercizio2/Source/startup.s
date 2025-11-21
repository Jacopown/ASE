;/**************************************************************************//**
; * @file     startup_LPC17xx.s
; * @brief    CMSIS Cortex-M3 Core Device Startup File for
; *           NXP LPC17xx Device Series
; * @version  V1.10
; * @date     06. April 2011
; *
; * @note
; * Copyright (C) 2009-2011 ARM Limited. All rights reserved.
; *
; * @par
; * ARM Limited (ARM) is supplying this software for use with Cortex-M
; * processor based microcontrollers.  This file can be freely distributed
; * within development tools that are supporting such ARM based processors.
; *
; * @par
; * THIS SOFTWARE IS PROVIDED "AS IS".  NO WARRANTIES, WHETHER EXPRESS, IMPLIED
; * OR STATUTORY, INCLUDING, BUT NOT LIMITED TO, IMPLIED WARRANTIES OF
; * MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE APPLY TO THIS SOFTWARE.
; * ARM SHALL NOT, IN ANY CIRCUMSTANCES, BE LIABLE FOR SPECIAL, INCIDENTAL, OR
; * CONSEQUENTIAL DAMAGES, FOR ANY REASON WHATSOEVER.
; *
; ******************************************************************************/

; *------- <<< Use Configuration Wizard in Context Menu >>> ------------------

; <h> Stack Configuration
;   <o> Stack Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Stack_Size      EQU     0x00000200

                AREA    STACK, NOINIT, READWRITE, ALIGN=3
Stack_Mem       SPACE   Stack_Size
__initial_sp


; <h> Heap Configuration
;   <o>  Heap Size (in Bytes) <0x0-0xFFFFFFFF:8>
; </h>

Heap_Size       EQU     0x00000200

                AREA    HEAP, NOINIT, READWRITE, ALIGN=3	; 2*3
__heap_base
Heap_Mem        SPACE   Heap_Size
__heap_limit


                PRESERVE8
                THUMB


; Vector Table Mapped to Address 0 at Reset

                AREA    RESET, DATA, READONLY
                EXPORT  __Vectors

__Vectors       DCD     __initial_sp              ; Top of Stack
                DCD     Reset_Handler             ; Reset Handler
                DCD     NMI_Handler               ; NMI Handler
                DCD     HardFault_Handler         ; Hard Fault Handler
                DCD     MemManage_Handler         ; MPU Fault Handler
                DCD     BusFault_Handler          ; Bus Fault Handler
                DCD     UsageFault_Handler        ; Usage Fault Handler
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     0                         ; Reserved
                DCD     SVC_Handler               ; SVCall Handler
                DCD     DebugMon_Handler          ; Debug Monitor Handler
                DCD     0                         ; Reserved
                DCD     PendSV_Handler            ; PendSV Handler
                DCD     SysTick_Handler           ; SysTick Handler

                ; External Interrupts
                DCD     WDT_IRQHandler            ; 16: Watchdog Timer
                DCD     TIMER0_IRQHandler         ; 17: Timer0
                DCD     TIMER1_IRQHandler         ; 18: Timer1
                DCD     TIMER2_IRQHandler         ; 19: Timer2
                DCD     TIMER3_IRQHandler         ; 20: Timer3
                DCD     UART0_IRQHandler          ; 21: UART0
                DCD     UART1_IRQHandler          ; 22: UART1
                DCD     UART2_IRQHandler          ; 23: UART2
                DCD     UART3_IRQHandler          ; 24: UART3
                DCD     PWM1_IRQHandler           ; 25: PWM1
                DCD     I2C0_IRQHandler           ; 26: I2C0
                DCD     I2C1_IRQHandler           ; 27: I2C1
                DCD     I2C2_IRQHandler           ; 28: I2C2
                DCD     SPI_IRQHandler            ; 29: SPI
                DCD     SSP0_IRQHandler           ; 30: SSP0
                DCD     SSP1_IRQHandler           ; 31: SSP1
                DCD     PLL0_IRQHandler           ; 32: PLL0 Lock (Main PLL)
                DCD     RTC_IRQHandler            ; 33: Real Time Clock
                DCD     EINT0_IRQHandler          ; 34: External Interrupt 0
                DCD     EINT1_IRQHandler          ; 35: External Interrupt 1
                DCD     EINT2_IRQHandler          ; 36: External Interrupt 2
                DCD     EINT3_IRQHandler          ; 37: External Interrupt 3
                DCD     ADC_IRQHandler            ; 38: A/D Converter
                DCD     BOD_IRQHandler            ; 39: Brown-Out Detect
                DCD     USB_IRQHandler            ; 40: USB
                DCD     CAN_IRQHandler            ; 41: CAN
                DCD     DMA_IRQHandler            ; 42: General Purpose DMA
                DCD     I2S_IRQHandler            ; 43: I2S
                DCD     ENET_IRQHandler           ; 44: Ethernet
                DCD     RIT_IRQHandler            ; 45: Repetitive Interrupt Timer
                DCD     MCPWM_IRQHandler          ; 46: Motor Control PWM
                DCD     QEI_IRQHandler            ; 47: Quadrature Encoder Interface
                DCD     PLL1_IRQHandler           ; 48: PLL1 Lock (USB PLL)
                DCD     USBActivity_IRQHandler    ; 49: USB Activity interrupt to wakeup
                DCD     CANActivity_IRQHandler    ; 50: CAN Activity interrupt to wakeup


                IF      :LNOT::DEF:NO_CRP
                AREA    |.ARM.__at_0x02FC|, CODE, READONLY
CRP_Key         DCD     0xFFFFFFFF
                ENDIF


                AREA    arrays, DATA, READWRITE
POOR_SUP	    SPACE 7*4*2
GOOD_SUP	    SPACE 7*4*2
MINT_SUP	    SPACE 7*4*2
POOR	    	SPACE 7*4
GOOD	    	SPACE 7*4
MINT	    	SPACE 7*4

                AREA    |.text|, CODE, READONLY
					
cards				rn 		0
condition			rn 		1
purchase_price		rn 		2
current_price		rn 		3
num_cards			rn 		4
poor				rn		5
good				rn		6
mint				rn		7

Reset_Handler   PROC
                EXPORT  Reset_Handler             [WEAK] 
                
				ldr   cards,          =CARDS      ; 0
				ldr   condition,      =CONDITION  ; 1
				ldr   num_cards,      =NUM_CARDS
				ldrb  num_cards,      [num_cards] ; 4

				eor r2, r2
				eor r9, r9
				eor r10, r10
				
				ADD num_cards, #-1
				EOR r12, r12
main_loop
				ldr r11, [cards, r12, LSL #2]
				PUSH{r3, r11}
				BL  dif
				POP{r3, r11} ; diff, id
        
				EOR r7, r7
condition_loop
				ldr r8, [condition, r7, LSL #2]
				ADD r7, r7, #2
				CMP r8, r11
				BNE condition_loop
				SUB r7, r7, #1
				ldr r8, [condition, r7, LSL #2]
				
				ldr poor, =POOR_SUP                   
				ldr good, =GOOD_SUP                   
				ldr mint, =MINT_SUP                   
				
				cmp r8, #0
				streq r11, [poor, r2, LSL #2]
				addeq r2, r2, #1
				streq r3, [poor, r2, LSL #2]
				addeq r2, r2, #1
				beq vec_set
				
				cmp r8, #1
				streq r11, [good, r9, LSL #2]
				addeq r9, r9, #1
				streq r3, [good, r9, LSL #2]
				addeq r9, r9, #1
				beq vec_set
				
				cmp r8, #2
				streq r11, [mint, r10, LSL #2]
				addeq r10, r10, #1
				streq r3, [mint, r10, LSL #2]
				addeq r10, r10, #1
vec_set
				ADD r12, #1
				CMP r12, num_cards
				BLE main_loop
				
				; poor r5
				; good r6
				; mint r7
				LSR r2, r2, #3
				SUB r2, r2, #1
				PUSH{r2, r5}
				BL InsertionSort
				POP{r2, r5}
				
				LSR r9, r9, #3
				SUB r9, r9, #1
				PUSH{r9, r6}
				BL InsertionSort
				POP{r9, r6}
				
				LSR r10, r10, #3
				SUB r10, r10, #1
				PUSH{r10, r7}
				BL InsertionSort
				POP{r10, r7}
				
				
				

				orr r0,r0,#1
				mov r1, r2	
				
				LDR     R0, =stop
				
stop            BX      R0
				ENDP
; ----------------------------------------------------------------------	
dif  PROC
; purchase_price	rn 		2
; current_price		rn 		3
        PUSH{purchase_price, current_price, r7, r8, r9, r10, r12, lr}
				ldr   purchase_price, =PURCHASE_PRICE
				ldr   current_price,  =CURRENT_PRICE
        ldr   r10, [sp, #36] ; id

				EOR r7, r7
purchase_loop
				ldr r8, [purchase_price, r7, LSL #2]
				ADD r7, #2
				CMP r8, r10
				BNE purchase_loop
				ADD r7, #-1
				ldr r9, [purchase_price, r7, LSL #2]

				EOR r7, r7
current_loop
				ldr r8, [current_price, r7, LSL #2]
				ADD r7, #2
				CMP r8, r10
				BNE current_loop
				ADD r7, #-1
				ldr r12, [current_price, r7, LSL #2]
				SUB r12, r12, r9
        str r12, [sp, #32]
        
        POP{purchase_price, current_price, r7, r8, r9, r10, r12, pc}
        ENDP
; ----------------------------------------------------------------------	
InsertionSort	PROC

				PUSH    {R0-R8, LR}   
				LDR     R5, [SP, #44]
				LDR     R4, [SP, #40]
				LSL     R4, R4, #3
				MOV     R0, #8

OuterLoop_Proc
				CMP     R0, R4
				BGT     EndSort_Proc
				LDR     R2, [R5, R0]  
				ADD     R8, R5, R0
				LDR     R3, [R8, #4]
				SUB     R1, R0, #8     

InnerLoop_Proc
				CMP     R1, #0
				BLT     InsertKey_Proc 
				ADD     R8, R5, R1				
				LDR     R6, [R8, #4]
				CMP     R6, R3
				BLE     InsertKey_Proc  
				LDR     R7, [R5, R1]    
				STR     R7, [R8, #8]
				STR     R6, [R8, #12]
				SUB     R1, R1, #8    
				B       InnerLoop_Proc

InsertKey_Proc
				ADD     R12, R5, R1     ; Ricalcola indirizzo base j (R5 + R1)
				STR     R2, [R8, #8]   ; Scrivi Key.ID in posizione corretta
				STR     R3, [R8, #12]
				ADD     R0, R0, #8    
				B       OuterLoop_Proc

EndSort_Proc
				POP     {R0-R8, PC}
				ENDP
; ----------------------------------------------------------------------	

				ALIGN
				LTORG
				ALIGN 2
PIPPO			SPACE 4096
CARDS			DCD	0x134, 3, 275, 0x2B9, 0xDC, 151, 2087
CONDITION 		DCD 2087, 2, 275, 0x0, 308, 0x1, 0xDC, 2, 151, 2, 0x3, 0, 697, 2
PURCHASE_PRICE 	DCD 0x3, 2000, 0x113, 2, 151, 9, 0x134, 45, 2087, 17, 220, 5, 697, 350
CURRENT_PRICE 	DCD 0xDC, 3, 151, 16, 3, 3300, 697, 420, 308, 63, 275, 1, 0x827, 3
NUM_CARDS 		DCB 7
				ALIGN 2
				SPACE 4096

; Dummy Exception Handlers (infinite loops which can be modified)

NMI_Handler     PROC
                EXPORT  NMI_Handler               [WEAK]

                B       .
				
                ENDP
HardFault_Handler\
                PROC
                EXPORT  HardFault_Handler         [WEAK]
                ; your code
				orr r0,r0,#1
				mov r1, r2
				BX	r0
                ENDP
MemManage_Handler\
                PROC
                EXPORT  MemManage_Handler         [WEAK]
                B       .
                ENDP
BusFault_Handler\
                PROC
                EXPORT  BusFault_Handler          [WEAK]
                B       .
                ENDP
UsageFault_Handler\
                PROC
                EXPORT  UsageFault_Handler        [WEAK]
                B       .
                ENDP
SVC_Handler     PROC
                EXPORT  SVC_Handler               [WEAK]
                B       .
                ENDP
DebugMon_Handler\
                PROC
                EXPORT  DebugMon_Handler          [WEAK]
                B       .
                ENDP
PendSV_Handler  PROC
                EXPORT  PendSV_Handler            [WEAK]
                B       .
                ENDP
SysTick_Handler PROC
                EXPORT  SysTick_Handler           [WEAK]
                B       .
                ENDP

Default_Handler PROC

                EXPORT  WDT_IRQHandler            [WEAK]
                EXPORT  TIMER0_IRQHandler         [WEAK]
                EXPORT  TIMER1_IRQHandler         [WEAK]
                EXPORT  TIMER2_IRQHandler         [WEAK]
                EXPORT  TIMER3_IRQHandler         [WEAK]
                EXPORT  UART0_IRQHandler          [WEAK]
                EXPORT  UART1_IRQHandler          [WEAK]
                EXPORT  UART2_IRQHandler          [WEAK]
                EXPORT  UART3_IRQHandler          [WEAK]
                EXPORT  PWM1_IRQHandler           [WEAK]
                EXPORT  I2C0_IRQHandler           [WEAK]
                EXPORT  I2C1_IRQHandler           [WEAK]
                EXPORT  I2C2_IRQHandler           [WEAK]
                EXPORT  SPI_IRQHandler            [WEAK]
                EXPORT  SSP0_IRQHandler           [WEAK]
                EXPORT  SSP1_IRQHandler           [WEAK]
                EXPORT  PLL0_IRQHandler           [WEAK]
                EXPORT  RTC_IRQHandler            [WEAK]
                EXPORT  EINT0_IRQHandler          [WEAK]
                EXPORT  EINT1_IRQHandler          [WEAK]
                EXPORT  EINT2_IRQHandler          [WEAK]
                EXPORT  EINT3_IRQHandler          [WEAK]
                EXPORT  ADC_IRQHandler            [WEAK]
                EXPORT  BOD_IRQHandler            [WEAK]
                EXPORT  USB_IRQHandler            [WEAK]
                EXPORT  CAN_IRQHandler            [WEAK]
                EXPORT  DMA_IRQHandler            [WEAK]
                EXPORT  I2S_IRQHandler            [WEAK]
                EXPORT  ENET_IRQHandler           [WEAK]
                EXPORT  RIT_IRQHandler            [WEAK]
                EXPORT  MCPWM_IRQHandler          [WEAK]
                EXPORT  QEI_IRQHandler            [WEAK]
                EXPORT  PLL1_IRQHandler           [WEAK]
                EXPORT  USBActivity_IRQHandler    [WEAK]
                EXPORT  CANActivity_IRQHandler    [WEAK]

WDT_IRQHandler
TIMER0_IRQHandler
TIMER1_IRQHandler
TIMER2_IRQHandler
TIMER3_IRQHandler
UART0_IRQHandler
UART1_IRQHandler
UART2_IRQHandler
UART3_IRQHandler
PWM1_IRQHandler
I2C0_IRQHandler
I2C1_IRQHandler
I2C2_IRQHandler
SPI_IRQHandler
SSP0_IRQHandler
SSP1_IRQHandler
PLL0_IRQHandler
RTC_IRQHandler
EINT0_IRQHandler
EINT1_IRQHandler
EINT2_IRQHandler
EINT3_IRQHandler
ADC_IRQHandler
BOD_IRQHandler
USB_IRQHandler
CAN_IRQHandler
DMA_IRQHandler
I2S_IRQHandler
ENET_IRQHandler
RIT_IRQHandler
MCPWM_IRQHandler
QEI_IRQHandler
PLL1_IRQHandler
USBActivity_IRQHandler
CANActivity_IRQHandler

                B       .

                ENDP


                ALIGN


; User Initial Stack & Heap

                EXPORT  __initial_sp
                EXPORT  __heap_base
                EXPORT  __heap_limit                

                END

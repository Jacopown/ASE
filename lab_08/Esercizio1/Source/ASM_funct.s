				AREA asm_functions, CODE, READONLY				
                EXPORT  ASM_funct
ASM_funct
				MOV   r12, sp
				STMFD sp!,{r4-r8,r10-r11,lr}				
				LDR   r4, [r12]
				MOV	  r0, r5			
				LDMFD sp!,{r4-r8,r10-r11,pc}		
                END
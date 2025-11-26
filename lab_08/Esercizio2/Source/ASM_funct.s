				AREA    asm_data, DATA, READONLY, ALIGN=4
                EXPORT  Input_Values
                EXPORT  NUM_VALUES

Input_Values    DCD     0x40000000, 0x40800000, 0x41200000, 0x41C80000
                DCD     0x42C80000, 0x447A0000, 0x3F800000, 0x42480000
NUM_VALUES      DCB     8
                ALIGN


                AREA    asm_functions, CODE, READONLY				
                EXPORT  fast_magic_calc

fast_magic_calc PROC
                LDR     R1, =0x5f3759df
                LSR     R0, R0, #1
                SUB     R0, R1, R0
                
                BX      LR
                ENDP
                
                END
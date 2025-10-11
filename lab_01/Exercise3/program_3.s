.section .data
V1: .byte 2, 6, -3, 11, 9, 18, -13, 16, 5, 1
V2: .byte  4, 2, -13, 3, 9, 9, 7, 16, 4, 7
V3: .space 10
size: .byte 10
flag1: .byte 1
flag2: .byte 0
flag3: .byte 0

.section .text
.globl _start 
_start:
Main:
        la    x1, V1            # load V1 addres in register x1
        lb    x3, 0(x1)         # preload cache
        la    x2, V2            # load V2 addres in register x2
        lb    x3, 0(x2)         # preload cache
        la    x11, V3           # load V3 addres in register x11
        lb    x3, 0(x11)        # preload cache
        la    x14, flag1        # load flag1 address in register x14
        lb    x8, flag1         # load flag1 value in regester x8
        la    x15, flag2        # load flag2 address in register x14
        la    x16, flag3        # load flag3 address in register x14
        lb    x5, size          # load size value in x5 register
        li    x6, 0             #  i = 0
        li    x12, 0            #  k = 0
Loopi:
        beq   x5, x6, LoopEnd   #if size == i jump to LoopEnd label
        li    x7, 0             #  j = 0
        add   x13, x1, x6       # load V1[i] value in register x3
        lb    x3, 0(x13)
        addi  x6, x6, 1         # i++
Loopj:
        beq   x5, x7, Loopi     # if size == j jump to Loopi label
        add   x13, x2, x7       # load V2[j] value in register x4
        lb    x4, 0(x13) 
        addi  x7, x7, 1         # j++
        bne   x3, x4, Loopj     # if V1[i] != V2[j] jump to Loopj label
        add   x13, x11, x12     # else V3[k] = V1[i]
        sb    x3, 0(x13)
        addi  x12, x12, 1       # k++
        li    x8, 0             # set flag1 to 0
        j     Loopj
LoopEnd:
        sb    x8, 0(x14)        # store final flag1 value
        li    x6, 0             # i = 0
        li    x7, 1             # j = 1
        addi  x12, x12, -1      # k = k - 1 so the nex loop works correctly
        ble   x12, x7, End      # if V3 size <= 1 jump to End label
        add   x13, x11, x6      # load V3[i] in x1
        lb    x20, 0(x13)
        add   x13, x11, x7      # load V3[j] in x2
        lb    x21, 0(x13)
        beq   x20, x21, End     # if V3[i] == V3[j] jump to End label
        bgt   x20, x21, Dec     # if V3[i] > V3[j] jump to Dec label
        blt   x20, x21, Asc     # if V[i] < V3[j] jump to Asc label
Dec:
        beq   x7, x12, SetFlag2 # if j == k jump to SetFlag2 label
        addi  x6, x6, 1         # i++
        addi  x7, x7, 1         # j++
        add   x13, x11, x6      # load V3[i] in x1
        lb    x20, 0(x13)
        add   x13, x11, x7      # load V3[j] in x2
        lb    x21, 0(x13)
        bgt   x20, x21, Dec     # if V3[i] > V3[j] jump to Dec label
        j     End
Asc:
        beq   x7, x12, SetFlag3 # if j == k jump to SetFlag3 label
        addi  x6, x6, 1         # i++
        addi  x7, x7, 1         # j++
        add   x13, x11, x6      # load V3[i] in x1
        lb    x20, 0(x13)
        add   x13, x11, x7      # load V3[j] in x2
        lb    x21, 0(x13)
        blt   x20, x21, Asc     # if V[i] < V3[j] jump to Asc label
        j     End
SetFlag2:
        li    x9, 1             # flag2 = 1
        sb    x9, 0(x15)
        j     End
SetFlag3:
        li    x18, 1            #flag3 = 1
        sb    x18, 0(x16)
        j     End
End:
        # exit() syscall. This is needed to end the simulation gracefully
        li    a0, 0
        li    a7, 93
        ecall

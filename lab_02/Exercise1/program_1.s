# Data section
.section .data
# Place here your program data.
# In this example, two vector of floats
# a vector of ints and a single int are defined
V1: .float 1.0, 2.0, 3.0, 4.0
V2: .float 5.0, 6.0, 7.0, 8.0
V3: .float 0.9, 0.10, 0.11, .012
V4: .space 128
V5: .space 128
V6: .space 128

# Code section
.section .text
.globl _start 
_start:
          la      x1, V1            # load V1 address in x1
          flw     f1, 0(x1)         # load V1 in cache
          la      x2, V2            # load V2 address in x2
          flw     f1, 0(x1)         # load V2 in cache
          la      x3, V3            # load V3 address in x3
          flw     f1, 0(x1)         # load V3 in cache

          la      x4, V4            # load V4 address in x4
          la      x5, V5            # load V5 address in x5
          la      x6, V6            # load V6 address in x6

          addi    x7, x0, 31        # i = 31
Main:
          blt     x7, x0 End        # if i < 0 jump to End 
          flw     f1, 0(x1)         # f1 = V1[i]
          flw     f2, 0(x2)         # f2 = V2[i]
          flw     f3, 0(x3)         # f3 = V3[i]

          fmul.s  f7, f1, f1        # f7 = V1[i] * V1[i]
          fsub.s  f7, f7, f2        # f7 = V1[i] * V1[i] - V2[i]
          add     x8, x7, x4
          fsw     f7, 0(x8)         # V4[i] = V1[i] * V1[i] - V2[i]

          fdiv.s  f8, f7, f3        # f8 = V4[i]/V3[i]
          fsub.s  f8, f7, f2        # f8 = V4[i]/V3[i] - V2[i]
          add     x8, x7, x5
          fsw     f8, 0(x8)         # V5[i] = V4[i]/V3[i] - V2[i]

          fsub.s  f9, f7, f1        # f9 = V4[i] - V1[i]
          fmul.s  f9, f9, f8        # f9 = (V4[i] - V1[i]) * V5[i]
          add     x8, x7, x6
          fsw     f9, 0(x8)         # V6[i] = (V4[i] - V1[i]) * V5[i]

          addi    x7, x7, -1        # i--
          j       Main
End:
li a0, 0
li a7, 93
ecall

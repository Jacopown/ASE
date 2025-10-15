# Data section
#.section .data
.data
V1: .float 4.6,1.1,1.3,7.1,2,4.7,7.4,1.9,7.5,8.1,7.3,3.9,3.9,3.9,5.5,8.1,8.5,8.1,5.5,9,2.1,5,1.2,9.4,8.6,2,6.8,5.7,8.8,1.7,4.6,6.4
V2: .float 2.4,3.3,6.4,9.1,9.1,8.5,5.5,5.1,3.2,5.5,4.6,4.7,9.6,2.3,1.6,1,8.1,5.7,3.2,2.1,8.6,2.7,5.2,2.2,6.7,2.3,3.2,2.2,8.5,6.1,7.4,4.5
V3: .float 2.5,6.3,8.6,1.4,9.1,4.5,3.8,9.7,3.5,7.8,9.9,7.5,5.2,9.6,4.6,5.1,4,9.5,8.4,1.1,3.6,7.7,8.2,7.3,4.2,2.1,7.2,2,7.5,1.2,5.7,3
V4: .space 128
V5: .space 128
V6: .space 128

# Code section
#.section .text
.text
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
          slli 	  x9, x7, 2
Main:
          blt     x7, x0 End        # if i < 0 jump to End 
          flw     f1, 0(x1)         # f1 = V1[i]
          flw     f2, 0(x2)         # f2 = V2[i]
          flw     f3, 0(x3)         # f3 = V3[i]

          fmul.s  f7, f1, f1        # f7 = V1[i] * V1[i]
          fsub.s  f7, f7, f2        # f7 = V1[i] * V1[i] - V2[i]
          add     x8, x9, x4
          fsw     f7, 0(x8)         # V4[i] = V1[i] * V1[i] - V2[i]

          fdiv.s  f8, f7, f3        # f8 = V4[i]/V3[i]
          fsub.s  f8, f7, f2        # f8 = V4[i]/V3[i] - V2[i]
          add     x8, x9, x5
          fsw     f8, 0(x8)         # V5[i] = V4[i]/V3[i] - V2[i]

          fsub.s  f9, f7, f1        # f9 = V4[i] - V1[i]
          fmul.s  f9, f9, f8        # f9 = (V4[i] - V1[i]) * V5[i]
          add     x8, x9, x6
          fsw     f9, 0(x8)         # V6[i] = (V4[i] - V1[i]) * V5[i]

          addi    x7, x7, -1
          slli	  x9, x7, 2	
                  # i--
          j       Main
End:
li a0, 0
li a7, 93
ecall

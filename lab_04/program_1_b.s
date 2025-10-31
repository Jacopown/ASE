.section .data
w: .float 4.6,1.1,1.3,7.1,2,4.7,7.4,1.9,7.5,8.1,7.3,3.9,3.9,3.9,5.5,8.1
i: .float 2.4,3.3,6.4,9.1,9.1,8.5,5.5,5.1,3.2,5.5,4.6,4.7,9.6,2.3,1.6,1
y: .float
b: .byte 0xab
mask: .word 0x7F800000
k: .byte 16

          .section .text
          .globl _start 
_start:
          la        x1, w             # load w address in x1
          flw       f1, 0(x1)         # load w in cache
          la        x2, i             # load i address in x2
          flw       f1, 0(x2)         # load i in cache
          la        x3, b             # load b address in x3
          lb        x4, 0(x3)         # load b in x4 register for the float cast
          la        x3, k             # load k address in x3 
          lb        x5, 0(x3)         # load k in x5 register
          la        x8, mask
          lw        x9, 0(x8)
          la        x11, y
          add       x6, x0, x0
          slli      x7, x6, 2         # iteratore per vettore float
          fcvt.s.w  f3, x4            # f3 = b float cast 
          fmv.w.x   f5, x0
Main:
          beq       x6, x5, EndLoop   # if j == x5 jump to End 

          add       x12, x1, x7
          flw       f1, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f2, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f6, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f7, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f9, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f10, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f12, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f13, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f15, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f16, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f18, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f19, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f21, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f22, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f24, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f25, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float

          add       x12, x1, x7
          flw       f27, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f28, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f1, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f2, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f6, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f7, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f9, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f10, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f12, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f13, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f15, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f16, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f18, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f19, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float
          add       x12, x1, x7
          flw       f21, 0(x12)        # load w[j] in f1
          add       x12, x2, x7
          flw       f22, 0(x12)        # load i[j] in f2
          addi      x6, x6, 1
          slli      x7, x6, 2         # iteratore per vettore float

          fmul.s    f4, f1, f2        # f3 = w[j] * i[j]
          fmul.s    f8, f6, f7        # f3 = w[j] * i[j]
          fmul.s    f11, f10, f9        # f3 = w[j] * i[j]
          fmul.s    f14, f12, f13        # f3 = w[j] * i[j]
          fmul.s    f17, f15, f16        # f3 = w[j] * i[j]
          fmul.s    f20, f18, f19        # f3 = w[j] * i[j]
          fmul.s    f23, f21, f22        # f3 = w[j] * i[j]
          fmul.s    f26, f24, f25        # f3 = w[j] * i[j]
          fadd.s    f5, f4, f5
          fmul.s    f29, f27, f28        # f3 = w[j] * i[j]
          fadd.s    f5, f8, f5
          fmul.s    f4, f1, f2        # f3 = w[j] * i[j]
          fadd.s    f5, f11, f5
          fmul.s    f8, f6, f7        # f3 = w[j] * i[j]
          fadd.s    f5, f14, f5
          fmul.s    f11, f10, f9        # f3 = w[j] * i[j]
          fadd.s    f5, f17, f5
          fmul.s    f14, f12, f13        # f3 = w[j] * i[j]
          fadd.s    f5, f20, f5
          fmul.s    f17, f15, f16        # f3 = w[j] * i[j]
          fadd.s    f5, f23, f5
          fmul.s    f20, f18, f19        # f3 = w[j] * i[j]
          fadd.s    f5, f26, f5
          fmul.s    f23, f21, f22        # f3 = w[j] * i[j]
          fadd.s    f5, f29, f5
          fadd.s    f5, f4, f5
          fadd.s    f5, f8, f5
          fadd.s    f5, f11, f5
          fadd.s    f5, f14, f5
          fadd.s    f5, f17, f5
          fadd.s    f5, f20, f5
          fadd.s    f5, f23, f5

          j         Main
EndLoop:
          fadd.s    f4, f3, f4        # f4 = f4 + b
          fmv.x.w   x10, f4
          fsw       f4, 0(x11)
          and       x10, x10, x9
          beq       x10, x9, EspUno
          j         End
EspUno:
          fmv.w.x   f4, x0
          fsw       f4, 0(x11)
End:
          li a0, 0
          li a7, 93
          ecall




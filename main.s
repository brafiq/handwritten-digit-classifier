.import read_matrix.s
.import write_matrix.s
.import matmul.s
.import dot.s
.import relu.s
.import argmax.s
.import utils.s

.globl main

.text
main:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0: int argc
    #   a1: char** argv
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>

    # Exit if incorrect number of command line args

    #  put argv on the stack

    addi sp, sp, -4
    sw a1, 0(sp)


    addi t0, x0, 5
    addi a1, x0, 3
    bne a0, t0, bad_args

	  # =====================================
    # LOAD MATRICES
    # =====================================



    # ==================Load pretrained m0=================

    #  creates and moves two int pointers into a1 and a2

    addi a0, x0, 4
    jal ra malloc
    addi sp, sp, -4
    sw a0, 0(sp)

    addi a0, x0, 4
    jal ra malloc
    mv a2, a0

    lw a1, 0(sp)
    addi sp, sp, 4



    lw t0, 0(sp)  # t0 <-- address of argv
    lw a0, 4(t0)  # a0 <-- filename string of M0_PATH


    #  read matrix M0
    jal ra read_matrix


    #  store dimensions of M0 matrix on stack
    addi sp, sp, -12
    sw a0, 0(sp)  #  a0 <-- address of M0
    lw t0, 0(a2)
    sw t0, 4(sp)  #  t0 <-- num cols of M0
    lw t0, 0(a1)
    sw t0, 8(sp)  #  t0 <-- num rows of M0


    #=================Load pretrained m1=================

    lw t0, 12(sp)  # t0 <-- address of argv
    lw a0, 8(t0)  # a0 <-- filename string of M1_PATH

    #  read matrix M1
    jal ra read_matrix



    #  store dimensions of M1 matrix on stack
    addi sp, sp, -12
    sw a0, 0(sp)  #  a0 <-- address of M1
    lw t0, 0(a2)
    sw t0, 4(sp)  #  t0 <-- num cols of M1
    lw t0, 0(a1)
    sw t0, 8(sp)  #  t0 <-- num rows of M1


    #=================Load input matrix=================

    lw t0, 24(sp)  # t0 <-- address of argv
    lw a0, 12(t0)  # a0 <-- filename string of INPUT_PATH

    #  read matrix INPUT matrix
    jal ra read_matrix

    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)


    #=================LINEAR LAYER=================

    #  a0  <-- address of INPUT matrix
    mv a3, a0
    lw a4, 0(a1)  #  a4 <-- num rows in INPUT matrix
    lw a5, 0(a2)  #  a5 <-- num cols in INPUT read_matrix


    lw a1, 20(sp)  # a1 <-- num rows of M0

    #  store num cols of INPUT on stack
    addi sp, sp, -4
    sw a5, 0(sp)

    #  calculate num elements in LINEAR LAYER matrix
    mul a0, a1, a5
    slli a0, a0, 2  #  a0 <-- num elements in LINEAR LAYER matrix


    jal ra malloc
    mv a6, a0

    # load arguments of M0
    lw a0, 16(sp)
    lw a1, 24(sp)
    lw a2, 20(sp)

    #  multiply M0 * INPUT
    jal ra matmul


    #=================NONLINEAR LAYER=================

    lw a1, 0(sp)  #  a1 <-- num cols of NONLINEAR LAYER matrix
    lw t1, 24(sp) #  t1 <-- num rows of NONLINEAR LAYER matrix

    mul a1, a1, t1
    mv a0, a6     #  a0 <-- address of NONLINEAR LAYER matrix

    jal ra relu

    mv a3, a0

    #=================LINEAR LAYER 2=================

    lw t1, 0(sp)  # t1 <-- num cols of SCORE matrix
    lw t2, 12(sp) # t2 <-- num rows of SCORE matrix

    mul t2, t1, t2
    slli a0, t2, 2

    jal ra malloc

    mv a6, a0

    lw a0, 4(sp)

    lw a1, 12(sp)
    lw a2, 8(sp)

    lw a4, 24(sp)
    lw a5, 0(sp)

    jal ra matmul

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix

    lw t0, 28(sp)  #  t0 <-- argv address
    lw a0, 16(t0)  #  a0 <-- string name of output file


    lw a2, 12(sp)  # a2 <-- height of M1
    lw a3, 0(sp)  # a3 <-- width of INPUT
    mv a1, a6
    addi sp, sp, -4
    sw a1, 0(sp)

    #jal print_int_array

    mul t0, a2, a3

    addi sp, sp, -4
    sw t0, 0(sp)

    jal ra write_matrix


    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax

    lw a0, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 8

    jal ra argmax

    # Print classification

    mv a1, a0
    jal print_int


    # Print newline afterwards for clarity
    li a1 '\n'
    jal print_char


    #addi sp, sp, 32

    jal exit


bad_args:
    li a1 3
    jal exit2

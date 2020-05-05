.import ../matmul.s
.import ../utils.s
.import ../dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
d:  .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    la s0, m0
    la s1, m1
    la s2, d

    # Call matrix multiply, m0 * m1
    mv a0, s0
    mv a3, s1
    mv a6, s2
    addi a1, x0, 3
    addi a2, x0, 3
    addi a4, x0, 3
    addi a5, x0, 3

    addi sp, sp, -28
    sw a0, 0(sp)
    sw a1, 4(sp)
    sw a2, 8(sp)
    sw a3, 12(sp)
    sw a4, 16(sp)
    sw a5, 20(sp)
    sw a6, 24(sp)

    jal ra matmul

    lw a0, 0(sp)
    lw a1, 4(sp)
    lw a2, 8(sp)
    lw a3, 12(sp)
    lw a4, 16(sp)
    lw a5, 20(sp)
    lw a6, 24(sp)
    addi sp, sp, 28

    # Print the output (use print_int_array in utils.s)
    mv a0, a6
    mv a2, a5

    jal print_int_array


    # Exit the program
    jal exit

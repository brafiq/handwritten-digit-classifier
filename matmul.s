.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   If the dimensions don't match, exit with exit code 2
# Arguments:
# 	  a0 is the pointer to the start of m0
#	  a1 is the # of rows (height) of m0
#	  a2 is the # of columns (width) of m0
#	  a3 is the pointer to the start of m1
# 	  a4 is the # of rows (height) of m1
#	  a5 is the # of columns (width) of m1
#	  a6 is the pointer to the the start of d
# Returns:
#	  None, sets d = matmul(m0, m1)
# =======================================================
matmul:

    # Error if mismatched dimensions
    bne a2, a4, mismatched_dimensions

    # Prologue
    addi sp, sp, -4
    sw ra, 0(sp)

outer_loop_start:
    add t0, x0, x0  # t0 <-- counter1 = 0; counter1 < height m0 * width m0; counter += width m0
    add t1, x0, x0  # t1 <-- counter2 starting at 0 -> width of m1
    add t2, x0, x0  # t2 <-- counter3 starting at 0 -> m0 height * m1 width
    j inner_loop_start

inner_loop_start:

    # for row i in m0, find dot product against each column in m1

    # stop when we have no more columns in m1
    bge t1, a5, inner_loop_end

    # store everything on stack

    addi sp, sp, -28
    sw t0, 0(sp)
    sw t1, 4(sp)
    sw t2, 8(sp)
    sw a0, 12(sp)
    sw a1, 16(sp)
    sw a3, 20(sp)
    sw a4, 24(sp)

    # SET UP ARGS FOR DOT

    # get address of element we want to start at for row vector
    slli t3, t0, 2
    add a0, t3, a0  # a0 is the pointer to the start of v0

    # get address of starting element of column vector
    slli t3, t1, 2
    add a1, t3, a3  # a1 is the pointer to the start of v1

    addi a3, x0, 1  # a3 is the stride of m0 width vector
    add a4, a5, x0  # a4 is the stride of m1 height vector

    # CALL DOT
    jal ra, dot
    mv t4, a0

    # get variables back from stack
    lw t0, 0(sp)
    lw t1, 4(sp)
    lw t2, 8(sp)
    lw a0, 12(sp)
    lw a1, 16(sp)
    lw a3, 20(sp)
    lw a4, 24(sp)
    addi sp, sp, 28

    # store resulting dot product in index of d
    slli t3, t2, 2
    add t3, t3, a6
    sw t4, 0(t3)

    # Print integer result
    #mv a1 a0
    #jal ra print_int

    # Print newline
    #li a1 '\n'
    #jal ra print_char

    # increment output counter
    addi t2, t2, 1
    addi t1, t1, 1

    # go to next column
    j inner_loop_start

inner_loop_end:
	# update counters
    add t0, t0, a2  # go to next row of m0
    add t1, x0, x0  # restart column index counter for m1

	# check to see if we have no more rows in m0

    mul t4, a1, a2


	  blt t0, t4, inner_loop_start
    j outer_loop_end

outer_loop_end:
    # Epilogue
    lw ra, 0(sp)
    addi sp, sp, 4

    ret


mismatched_dimensions:
    li a1 2
    jal exit2

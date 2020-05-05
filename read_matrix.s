.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is a pointer to an integer, we will set it to the number of rows
#   a2 is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 is the pointer to the matrix in memory
# ==============================================================================
read_matrix:
	# Prologue

	addi sp, sp, -12
	sw ra, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)

	# open file
	mv a1, a0
	addi a2, x0, 0

	jal fopen

	# check successful fopen
	addi t0, x0, -1
	beq a0, t0, eof_or_error

	# setup args for fread
	mv a1, a0  # a1 <-- file descriptor
  addi sp, sp, -4
	sw a1, 0(sp)

	# make space for buffer
	addi a0, x0, 4

	jal malloc

  lw a1, 0(sp)

	mv a2, a0  # a2 <-- buffer size 4 bytes

	addi a3, x0, 4  # a3 <-- number of bytes to read

	jal fread
	bne a0, a3, eof_or_error

	lw t0, 0(a2)  # t0 <-- height of matrix (number of rows)

	addi sp, sp, -4
  sw t0, 0(sp)

	jal fread

	bne a0, a3, eof_or_error

	lw t0, 0(sp) # t0 <-- height of matrix (number of rows)



	lw t1, 0(a2)  # t1 <-- width of matrix (number of columns)

	mul t3, t0, t1  # t0 <-- number of elements in matrix

	addi sp, sp, -4
	sw t1, 0(sp)


	# make space for matrix size t0 x t1
	slli a0, t3, 2

  jal malloc

	mv a2, a0  # a2 <-- address of matrix

	lw a1, 8(sp)
	slli a3, t3, 2

	jal fread

	bne a0, a3, eof_or_error
	addi sp, sp, -4
	sw a2, 0(sp)

	# Epilogue

	lw a1, 12(sp)
	jal fclose
	addi t4, t4, -1
	beq t4, a0, eof_or_error
	lw ra, 16(sp)
	lw a1, 20(sp)
	lw a2, 24(sp)
	lw t0, 8(sp)
	lw t1, 4(sp)
	lw a0, 0(sp)
	addi sp, sp, 28
	sw t0, 0(a1)
	sw t1, 0(a2)
	ret

eof_or_error:
	li a1 1
	jal exit2

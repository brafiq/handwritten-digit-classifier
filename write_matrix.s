.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 is the pointer to string representing the filename
#   a1 is the pointer to the start of the matrix in memory
#   a2 is the number of rows in the matrix
#   a3 is the number of columns in the matrix
# Returns:
#   None
# ==============================================================================
write_matrix:

    # Prologue
	addi sp, sp, -20
	sw a0, 0(sp)
	sw a1, 4(sp)
	sw a2, 8(sp)
	sw a3, 12(sp)
	sw ra, 16(sp)

	# malloc buffer and move pointer to a2
	addi a0, x0, 4
	jal malloc
	mv t0, a0

	# call fopen on file path and 1 for permissions
	lw a1, 0(sp)
	addi a2, x0, 1
	jal fopen


	# check for successful fopen
	addi t1, x0, -1
	beq a0, t1, eof_or_error

	# set a1 to be the file descriptor
	mv a1, a0

  # write dimensions to output file
  lw t2, 8(sp)
  sw t2, 0(t0)
  mv a2, t0
  addi a3, x0, 1
  addi a4, x0, 4
  jal fwrite

  lw t2, 12(sp)
  sw t2, 0(t0)
  jal fwrite

	lw a2, 4(sp)

	addi a4, x0, 4

	# get row and column values for matrix
	lw t0, 8(sp)
	lw t1, 12(sp)

	# set a3 to number of elements
	mul a3, t0, t1

	jal fwrite

	bne a0, a3, eof_or_error

	jal fclose
	addi t0, t0, -1
	beq a0, t0, eof_or_error

    # Epilogue
	lw ra, 16(sp)
	addi sp, sp, 20

    ret

eof_or_error:
    li a1 1
    jal exit2

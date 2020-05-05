.import ../read_matrix.s
.import ../utils.s

.data
file_path: .asciiz "./test_input.bin"

.text
main:
	# Read matrix into memory

	#  make space for two integer pointers
	addi a0, x0, 4
	jal malloc
	mv a1, a0

	addi a0, x0, 4

	addi sp, sp, -4
	sw a1, 0(sp)

	jal malloc

	lw a1, 0(sp)
	addi sp, sp, 4

	mv a2, a0

	#  load the file path
	la a0, file_path

	#  read matrix
	jal read_matrix

	lw a1, 0(a1)
	lw a2, 0(a2)

	# Print out elements of matrix
	jal print_int_array

	# Terminate the program
	addi a0, x0, 10
	ecall

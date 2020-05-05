.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 is the pointer to the array
#	a1 is the # of elements in the array
# Returns:
#	None
# ==============================================================================
relu:
    # Prologue
	# make space for address and size of array
	addi sp, sp, -4
	sw ra, 0(sp)
	jal ra, loop_start

loop_start:
	add t0, x0, x0   # t0 <-- counter
	j loop_continue

loop_continue:
	beq t0, a1, loop_end
	slli t1, t0, 2  # t1 <-- 4x counter to get diff of next element
	add t3, t1, a0  # t3 <-- now contains address of next element
	lw t1, 0(t3)	# t1 <-- element at index of counter

	addi t0, t0, 1
	bge t1, x0, loop_continue		# check if value of element is less than zero
	sw x0, 0(t3)
	j loop_continue

loop_end:
	# Epilogue
	lw ra, 0(sp)
	addi sp, sp, 4
	jr ra

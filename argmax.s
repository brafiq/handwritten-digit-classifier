.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 is the pointer to the start of the vector
#	a1 is the # of elements in the vector
# Returns:
#	a0 is the first index of the largest element
# =================================================================
argmax:
	# Prologue

loop_start:
	add t0, x0, x0 # t0 <-- contains max index
	add t1, x0, x0 # t1 <-- contains max value
	add t2, x0, x0 # t2 <-- counter variable

	j loop_continue

loop_continue:
	beq a1, t2, loop_end  # if our counter == num of elements, end loop

	slli t2, t2, 2  # t2 <-- 4x counter to get diff of next element
	add t5, t2, a0  # t5 <-- now contains address of next element
	srli t2, t2, 2  # t2 <-- restored to counter value
	lw t5, 0(t5)	# t5 <-- element at index of counter

	blt t1, t5, set_maxes  # set new maxes if we found new max element
	addi t2, t2, 1
	j loop_continue

set_maxes:
	add t1, t5, x0  # set max to new max
	add t0, t2, x0  # set max_index to new index
	j loop_continue

loop_end:

	# Epilogue
	add a0, t0, x0  # store argmax in a0
	ret

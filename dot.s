.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 is the pointer to the start of v0
#   a1 is the pointer to the start of v1
#   a2 is the length of the vectors
#   a3 is the stride of v0
#   a4 is the stride of v1
# Returns:
#   a0 is the dot product of v0 and v1
# =======================================================
dot:
	# Prologue

loop_start:
	add t0, x0, x0  # t0 <-- counter for v0
	add t1, x0, x0  # t1 <-- counter for v1
	add t2, x0, x0  # t2 <-- dot product sum
	add t3, x0, x0  # t3 <-- counter for length
	j loop_continue

loop_continue:
	bge t3, a2, loop_end

	slli t0, t0, 2  # t0 <-- counter shifted by 4
	add t4, t0, a0  # t4 <-- address of next element in v0
	srli t0, t0, 2  # t0 <-- counter restored from shift
	lw t4, 0(t4)    # t4 <-- element of interest for v0

	slli t1, t1, 2  # t1 <-- counter shifted by 4
	add t5, t1, a1  # t5 <-- address of next element in v1
	srli t1, t1, 2  # t1 <-- counter restored from shift
	lw t5, 0(t5)    # t5 <-- element of interest for v1

	mul t4, t4, t5  # t4 <-- product of EOI from v0 and v1 
	add t2, t4, t2  # update dot product sum

	# update counters using respective strides
	add t0, t0, a3
	add t1, t1, a4

	# update vector length counter
	addi t3, t3, 1
	j loop_continue


loop_end:
	# Epilogue
	add a0, t2, x0
	ret

.import ../dot.s
.import ../utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 4 5 6 7 8 9
vector1: .word 1 2 3 4 5 6 7 8 9


.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1

    # Set vector attributes
    addi s2 x0 2  # store length of arrays in a2 (CHANGE THIS WHEN CHANGING TEST ARRAYS)
    addi s3 x0 1  # store the stride of v0 in a3 (CHANGE THIS WHEN CHANGING TEST ARRAYS)
    addi s4 x0 1  # store the stride of v1 in a4 (CHANGE THIS WHEN CHANGING TEST ARRAYS)

    # Call dot function
    mv a0 s0  # store front of v0 in a0
    mv a1 s1  # store front of v1 in a1
    mv a2 s2
    mv a3 s3
    mv a4 s4
    jal ra dot

    # Print integer result
	  mv a1 a0
    jal ra print_int

    # Print newline
	  li a1 '\n'
    jal ra print_char

    # Exit
    jal exit

(BEGINNING)
// Store the first number in register D
@3
D=M

// Perform an AND operation with the second number and store the result in register D
@4
D=D&M

// Store the result of the AND operation in memory location 0
@0
M=D

// Reset register D to the first number
@3
D=M

// Perform an OR operation with the second number and store the result in register D
@4
D=D|M

// Store the result of the OR operation in memory location 1
@1
M=D

// Negate the result of the AND operation and store it in register D
@0
D=!M

// Perform an AND operation with the negated result and the OR result and store the result in memory location 5
@1
D=D&M
@5
M=D

// Jump to the beginning of the code to start over
@BEGINNING
0;JMP
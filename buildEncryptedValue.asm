//// Start adding the left 8 bits and the right 8bits together ////

// Reset the right shift counter for the use to shift the left part back to its original place
@8
D=A
// Store the value 8 in the memory location RSCOUNT
@RSCOUNT
M=D

// Check of the counter is equal to zero if ture jump to DONE if false continue
(SHIFT)
@RSCOUNT
D=M
// Jump if the shifting is done
@DONE
D;JEQ

// Shift to the left by adding the value in R3 to itself using the Data register and Memory register
@R3
D=M
M=M+D

// Subtract one from the counter and jump to SHIFT which is the start to shift again
@RSCOUNT
M=M-1
// Jump back at the start
@SHIFT
0;JMP

// The shifting is done
(DONE)

// Load the left that is in R2 then store it in the Data register
@R2
D=M
// Load the right that is in R3 stored in the Memory register then do a bitwise OR with the left part that is stored in the Data register
@R3
D=M|D
// Store the value in memory location R0
@R0
M=D
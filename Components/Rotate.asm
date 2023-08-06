// Set the MSB bit masker
@16384 // 0100 0000 0000 0000
D=A    // Load lower 15-bits
D=D+A  // Left shift by 1
@MSB
M=D // 1000 0000 0000 0000

// Bit Rotation
(LOOP)
// Check if loop is done
@R4
D=M
@STOP_IF_ZERO
D;JEQ     // if D (counter) equals zero, jump to STOP_IF_ZERO

// Check if the MSB is 1
@R3
D=M
@MSB
D=D&M
@SKIP
D;JEQ

// If true rotate bit
@R3
D=M+1
M=M+D

(SUBCOUNT)
// Subtract the R4 by 1
@R4
D=M
M=D-1
// Loop back at the start
@LOOP
0;JMP     // jump to POWERLOOP to repeat the loop

///////////////////////////////////////////////////

// Set the final value of rotation and loop and wait for the next value
(STOP_IF_ZERO)
@R3
D=M
@R5
M=D
@LOOP
0;JMP

// Shift to the left and don't rotate
(SKIP)
@R3
D=M
M=M+D
@SUBCOUNT
0;JMP
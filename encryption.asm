// 16384 or 0100 0000 0000 0000 in binary store it to a Data register to be shifted to 32768 or 1000 0000 0000 0000 in binary
@16384
D=A
D=D+A
// Store the value 32768 to the variable MSB which will be used for masking the most significant bit to indicate if there should be a rotation or not
@MSB
M=D

//// Start the encryption process ////

/// Store Li ///
// Load the Li using the Address register to the Data register to store it
@R3
D=M
// Store Li in the Data register to the Memory register to be used to calculate the Ri+1
@Li
M=D

/// Li+1 = Ri ///
// Load Ri 
@R2
D=M
// Store it to create Li+1
@R3
M=D

// ¬Ki //
@R1
D=!M
@255
D=D&A
@R1
M=D

// F(Ri, Ki) = Ri ⊕ ¬Ki //

@R2
D=M

@R1
D=D&M

@buffer
M=D

@R2
D=M

@R1
D=D|M

@buffer1
M=D

@buffer
D=!M

@buffer1
D=D&M
@FUNCTION
M=D

// Ki //
@R1
D=!M
@255
D=D&A
@R1
M=D

// Ri+1 = Li ⊕ F(Ri, Ki) //

@Li
D=M

@FUNCTION
D=D&M

@buffer
M=D

@Li
D=M

@FUNCTION
D=D|M

@buffer1
M=D

@buffer
D=!M

@buffer1
D=D&M
@R0
M=D

//// Rotate Key ////

// Check if the MSB is 1
@R1
D=M
@128
D=D&A
@NOROTATION
D;JEQ

// If true rotate bit
@R1
D=M+1
D=M+D
@255
D=D&A
@R1
M=D
@SKIP
0;JMP

(NOROTATION)
@R1
D=M
M=M+D

(SKIP)
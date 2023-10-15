(BEGINNING)

// If this RAM slot is reset to zero perform new encryption calculations otherwise keep looping until a new value is required to encrypt
@R0
D=M
@BEGINNING
D;JNE

//// Masking The Left Section Of The Value ////
// 32640 or 0111 1111 1000 0000 in binary store it to a Data register to be shifted to 65280 or 1111 1111 0000 0000 in binary
@32640
D=A
D=D+A
// Load the value stored on RAM[2] in the Memory register then perform bitwise and with the masking value stored in the Data Register
@R2
D=D&M
// Store the mask for the 8 bits on the left to RAM[1] for shifting to the right
@R3
M=D

//// Value memory location only store the 8 bits on the right ////
// 255 or 0000 0000 1111 1111 used to mask the 8 bits use the Address register to store the value to the Data Register
@255
D=A
// Mask the 8 bits on the right by bitwise and of Data register storing the mask and the Memory register storing the value then update the memory slot
@R2
D=D&M
M=D

// 16384 or 0100 0000 0000 0000 in binary store it to a Data register to be shifted to 32768 or 1000 0000 0000 0000 in binary
@16384
D=A
D=D+A
// Store the value 32768 to the variable MSB which will be used for masking the most significant bit to indicate if there should be a rotation or not
@MSB
M=D

//// Rotate bits of the 8 bits on the left 8 times which is equivalent to right shifting to be used in the encryption operations ////

// Use the address register to store the value 8 in the data register which is used for counting
@8
D=A
// Store the value 8 to the variable RSCOUNT
@RSCOUNT
M=D

// Start rotation
(LOOP)
// Check RSCOUNT is equal to zero if true stop rotaton using @STOP_IF_ZERO
@RSCOUNT
D=M
// Stop rotation if the Data register which stores the counter is zero
@STOP_IF_ZERO
D;JEQ     // if D (counter) equals zero, jump to STOP_IF_ZERO

// Load the value stored in RAM[1] from the memory register to the data register
@R3
D=M
// Load the value of the most significant bit mask from the memory register then use bitwise and with the data register which stores the value to be rotated
@MSB
D=D&M
// If the mask equals zero jump to FINROTATION if it is equal to one continue
@FINROTATION
D;JEQ

// Load the value stored in RAM[1] shift it to the left by one and add a bit in the beginning
@R3
D=M+1
M=M+D

// Used to subtract from counter
(SUBCOUNT)
// Subtract the RSCOUNT by 1
@RSCOUNT
M=M-1
// Loop back at the start
@LOOP
0;JMP     // jump to POWERLOOP to repeat the loop

// Shift to the left and don't add a bit (don't do any bit rotations)
(FINROTATION)
@R3
D=M
M=M+D
// Subtract from counter
@SUBCOUNT
0;JMP

// Set the final value of rotation and loop and wait for the next value
(STOP_IF_ZERO)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ¬Ki //
@R1
D=!M
@255
D=D&A
@R1
M=D

// Create an encryption counter for the first 3 rounds when the counter hits zero rotate the last key twice
@3
D=A
// Store the value three in the variable ENCRYPTCOUNT
@ENCRYPTCOUNT
M=D

// Create a counter for all rounds 
@4
D=A
@FINALENCRYPT
M=D

//// Start the encryption process ////

(ENCRYPTLOOP)

// Jump to encrypt when the counter is bigger than zero
@ENCRYPTCOUNT
D=M
@ENCRYPT
D;JNE

// When the first three rounds are done rotate the last key again
@SECONDROTATE
0;JMP

(ENCRYPT)

// Before encrypting subtract the overall encryption counter
@FINALENCRYPT
M=M-1

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
@R2
M=D

@FINALENCRYPT
D=M
@FINISHED
D;JEQ

//// Rotate Key ////

(SECONDROTATE)
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
// Check if the first three rounds are done
@ENCRYPTCOUNT
D=M
@ENCRYPT
D;JEQ

@ENCRYPTCOUNT
M=M-1
@ENCRYPTLOOP
0;JMP
(FINISHED)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

// Shift to the left by adding the value in R2 to itself using the Data register and Memory register
@R2
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
@BEGINNING
0;JMP
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

// Rotate till we start with K3
@3
D=A
@LASTKEYCOUNT
M=D

(LASTKEYLOOP)
@LASTKEYCOUNT
D=M
@LASTKEYDONE
D;JEQ

// Check if the MSB is 1
@R1
D=M
@128
D=D&A
@SHIFTLASTKEY
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

(SHIFTLASTKEY)
@R1
D=M
M=M+D

(SKIP)
@LASTKEYCOUNT
M=M-1
@LASTKEYLOOP
0;JMP
(LASTKEYDONE)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ¬Ki //
@R1
D=!M
@255
D=D&A
@R1
M=D

// Create an encryption counter for the first 4 rounds
@4
D=A
// Store the value three in the variable ENCRYPTCOUNT
@ENCRYPTCOUNT
M=D

//// Start the encryption process ////

(ENCRYPTLOOP)
@ENCRYPTCOUNT
D=M
@FINISHED
D;JEQ

/// Store Ri+1 ///
// Load the Ri+1 using the Address register to the Data register to store it
@R2
D=M
// Store Ri+1 in the Data register to the Memory register to be used to calculate the Li
@Ri+1
M=D

/// Ri = Li+1 ///
// Load Li+1
@R3
D=M
// Store it to create Ri
@R2
M=D

// F(Li+1, Ki) = Li+1 ⊕ ¬Ki //

@R3
D=M

@R1
D=D&M

@buffer
M=D

@R3
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

// Li = Ri+1 ⊕ F(Li+1, Ki) //

@Ri+1
D=M

@FUNCTION
D=D&M

@buffer
M=D

@Ri+1
D=M

@FUNCTION
D=D|M

@buffer1
M=D

@buffer
D=!M

@buffer1
D=D&M
@R3
M=D

@7
D=A
@7COUNTER
M=D
//// Rotate Key ////

(ROTATE7)
@7COUNTER
D=M
@DONE7
D;JEQ

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

@7COUNTER
M=M-1
@ROTATE7
0;JMP
(DONE7)

@ENCRYPTCOUNT
M=M-1
@ENCRYPTLOOP
0;JMP
(FINISHED)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

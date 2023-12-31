//// Masking The Left Section Of The Value ////
// 32640 or 0111 1111 1000 0000 in binary store it to a Data register to be shifted to 65280 or 1111 1111 0000 0000 in binary
@32640
D=A
D=D+A
// Load the value stored on RAM[2] in the Memory register then perform bitwise and with the masking value stored in the Data Register
@R2
D=D&M
// Store the mask for the 8 bits on the left to RAM[1] for shifting to the right
@R1
M=D

//// Value memory location only store the 8 bits on the right ////
// 255 or 0000 0000 1111 1111 used to mask the 8 bits use the Address register to store the value to the Data Register
@255
D=A
// Mask the 8 bits on the right by bitwise and of Data register storing the mask and the Memory register storing the value then update the memory slot
@R2
D=D&M
M=D

//// Rotate bits of the 8 bits on the left 8 times which is equivalent to right shifting to be used in the encryption operations ////

// Use the address register to store the value 8 in the data register which is used for counting
@8
D=A
// Store the value 8 to the variable RSCOUNT
@RSCOUNT
M=D

// 16384 or 0100 0000 0000 0000 in binary store it to a Data register to be shifted to 32768 or 1000 0000 0000 0000 in binary
@16384
D=A
D=D+A
// Store the value 32768 to the variable MSB which will be used for masking the most significant bit to indicate if there should be a rotation or not
@MSB
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
@R1
D=M
// Load the value of the most significant bit mask from the memory register then use bitwise and with the data register which stores the value to be rotated
@MSB
D=D&M
// If the mask equals zero jump to SKIP if it is equal to one continue
@SKIP
D;JEQ

// Load the value stored in RAM[1] shift it to the left by one and add a bit in the beginning
@R1
D=M+1
M=M+D

// Used to subtract from counter
(SUBCOUNT)
// Subtract the RSCOUNT by 1
@RSCOUNT
D=M
M=D-1
// Loop back at the start
@LOOP
0;JMP     // jump to POWERLOOP to repeat the loop

// Shift to the left and don't add a bit (don't do any bit rotations)
(SKIP)
@R1
D=M
M=M+D
// Subtract from counter
@SUBCOUNT
0;JMP

// Set the final value of rotation and loop and wait for the next value
(STOP_IF_ZERO)
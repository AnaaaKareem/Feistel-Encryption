# Feistel-Encryption

The Value: 11010101 10101111
The Initial Key: 11001100

// Derived Keys
K0: 1100 1100
K1: 1001 1001 // Rotated 1 times
K2: 0011 0011 // Rotated 1 times
K3: 1100 1100 // Rotated 2 times

// Split The Value into 2 parts Left and Right

Left: 11010101
Right: 10101111

// Round 1
K0: 1100 1100
R0: 1010 1111
L0: 1101 0101

L1 = R0
L1 = 10101111

F(R0, K0) = R0 ⊕ ¬K0
F(10101111, 11001100) = 1010 1111 ⊕ 0011 0011 = 1001 1100

R1 = L0 ⊕ F(R0, K0)

R1 = 1101 0101 ⊕ 1001 1100
R1 = 0100 1001

// Round 2

// Round 3

// Round 4

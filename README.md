# Feistel-Encryption

The Value: 1101 0101 1010 1111
The Initial Key: 11001100

// Derived Keys
K0: 1100 1100 // Initial Key
K1: 1001 1001 // Rotated 1 times
K2: 0011 0011 // Rotated 1 times
K3: 0110 0110 // Rotated 2 times

// Split The Value into 2 parts Left and Right

Left: 1101 0101
Right: 1010 1111

## Round 1
K0: 1100 1100
R0: 1010 1111
L0: 1101 0101

L1 = R0
L1 = 1010 1111

F(R0, K0) = R0 ⊕ ¬K0
F(1010 1111, 1100 1100) = 1010 1111 ⊕ 0011 0011 = 1001 1100

R1 = L0 ⊕ F(R0, K0)
R1 = 1101 0101 ⊕ 1001 1100
R1 = 0100 1001

## Round 2
K1: 1001 1001
R1: 0100 1001
L1: 1010 1111

L2 = R1
L2 = 0100 1001

F(R1, K1) = R1 ⊕ ¬K1
F(0100 1001, 1001 1001) = 0100 1001 ⊕ 0110 0110 = 0010 1111

R2 = L1 ⊕ F(R1, K1)
R2 = 1010 1111 ⊕ 0010 1111
R2 = 1000 0000

## Round 3
K2: 0011 0011
R2: 1000 0000
L2: 0100 1001

L3 = R2
L3 = 1000 0000

F(R2, K2) = R2 ⊕ ¬K2
F(1000 0000, 0011 0011) = 1000 0000 ⊕ 1100 1100 = 0100 1100

R3 = L2 ⊕ F(R2, K2)
R3 = 0100 1001 ⊕ 0100 1100
R3 = 0000 0101

## Round 4
K3: 0110 0110
R3: 0000 0101
L3: 1000 0000

L4 = R3
L4 = 0000 0101

F(R3, K3) = R3 ⊕ ¬K3
F(0000 0101, 1100 1100) = 0000 0101 ⊕ 1001 1001 = 1001 1100

R4 = L3 ⊕ F(R3, K3)
R4 = 1000 0000 ⊕ 1001 1100
R4 = 0001 1100

Value After Encryption: 0000 0101 0001 1100

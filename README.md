# Feistel Encryption

The **Feistel Encryption Simulation** is a low-level implementation of the Feistel Cipher using **Hack Assembly Language**. It models the encryption and decryption processes by splitting 16-bit blocks into left and right halves and applying a series of rounds with a rotating key.

The program works directly with memory registers to perform bitwise operations, simulating the core logic of a symmetric structure used in block ciphers.

---

## Input and Interaction

The program runs on the **Nand2Tetris CPU Emulator**. It interacts directly with the system's RAM:

* **RAM[0] (R0)**: The input value (16-bit) to be encrypted or decrypted. The program monitors this register and starts execution when a non-zero value is detected.
* **RAM[1] (R1)**: The 8-bit Key used for the encryption/decryption rounds.

**Interaction Flow:**

1. Load the program.
2. Set `RAM[1]` to your desired Key.
3. Set `RAM[0]` to the Value to encrypt.
4. The program detects the change and begins processing.

---

## Output Format

Upon completion of the encryption or decryption rounds, the final result is written back to the input register:

* **RAM[0]**: Contains the final 16-bit Encrypted or Decrypted value.

---

## How to Compile and Run

### Requirements

Allowed execution environment: **Nand2Tetris Software Suite** (specifically the `CPUEmulator`).

### Execution

1. Launch the **CPUEmulator** from the Nand2Tetris tools.
2. Use the **Load Program** button to select `FeistelEncryption.asm` or `FeistelDecryption.asm`.
3. **Set Inputs**:
    * Click on `RAM[1]` and enter the key value (e.g., `204` for `11001100`).
    * Click on `RAM[0]` and enter the data value (e.g., `54703` for `1101010110101111`).
4. **Run**:
    * Press the **Run** button (Fast Forward icon) to execute the logic.
    * Wait for the program to enter the infinite loop at the end (or pause execution).
5. **Verify**:
    * Check `RAM[0]` for the result.

---

## Program Features

* **Hack Assembly Implementation**: Written in the low-level machine language of the Hack computer.
* **4-Round Feistel Network**: Implements a standard 4-cycle structure of processing and swapping halves.
* **Dynamic Key Rotation**: The key stored in `RAM[1]` is rotated bitwise in every round to enhance security simulation.
* **Bitwise Logic**: specific logical functions `F(R, K)` implemented using NAND, AND, OR, and NOT gates standard to the ALU.

---

## Author and License

It is not licensed and is free to use and modify.

---

## Algorithm Trace Analysis

The following is a manual trace of the encryption and decryption logic used in this project.

### Feistel-Encryption

The Value: 1101 0101 1010 1111
The Initial Key: 11001100

// Derived Keys
K0: 1100 1100 // Initial Key
K1: 1001 1001 // Rotated 1 time
K2: 0011 0011 // Rotated 1 time
K3: 0110 0110 // Rotated 1 time

// Split The Value into 2 parts Left and Right

Left: 1101 0101
Right: 1010 1111

#### Round 1

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

#### Round 2

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

#### Round 3

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

#### Round 4

K3: 0110 0110
R3: 0000 0101
L3: 1000 0000

L4 = R3
L4 = 0000 0101

F(R3, K3) = R3 ⊕ ¬K3
F(0000 0101, 1001 1001) = 0000 0101 ⊕ 1001 1001 = 1001 1100

R4 = L3 ⊕ F(R3, K3)
R4 = 1000 0000 ⊕ 1001 1100
R4 = 0001 1100

Final Value After Encryption: 0001 1100 0000 0101

### Feistel-Decryption

The Value: 0000 0101 0001 1100
The Initial Key: 11001100

// Derived Keys
K3: 0110 0110 // Rotated 1 time
K2: 0011 0011 // Rotated 1 time
K1: 1001 1001 // Rotated 1 time
K0: 1100 1100 // Initial Key

// Split The Value into 2 parts Left and Right

Left: 0000 0101
Right: 0001 1100

#### Round 1

K3: 0110 0110
R4: 0001 1100
L4: 0000 0101

R3 = L4
R3 = 0000 0101

F(L4, K3) = L4 ⊕ ¬K3
F(0000 0101, 0110 0110) = 0000 0101 ⊕ 1001 1001 = 1001 1100

L3 = R4 ⊕ F(L4, K3)
L3 = 0001 1100 ⊕ 1001 1100
L3 = 1000 0000

#### Round 2

K2: 0011 0011
R3: 0000 0101
L3: 1000 0000

R2 = L3
R2 = 1000 0000

F(L3, K2) = L3 ⊕ ¬K2
F(1000 0000, 0011 0011) = 1000 0000 ⊕ 1100 1100 = 0100 1100

L2 = R3 ⊕ F(L3, K2)
L2 = 0000 0101 ⊕ 0100 1100 = 0100 1001
L2 = 0100 1001

#### Round 3

K1: 1001 1001
R2: 1000 0000
L2: 0100 1001

R1 = L2
R1 = 0100 1001

F(L2, K1) = L2 ⊕ ¬K1
F(0100 1001, 1001 1001) = 0100 1001 ⊕ 0110 0110 = 0010 1111

L1 = R2 ⊕ F(L2, K1)
L1 = 1000 0000 ⊕ 0010 1111 = 1010 1111
L1 = 1010 1111

#### Round 4

K0: 0011 0011
R1: 0100 1001
L1: 1010 1111

R0 = L1
R0 = 1010 1111

F(L1, K0) = L1 ⊕ ¬K0
F(1010 1111, 0011 0011) = 1010 1111 ⊕ 0011 0011 = 1001 1100

L0 = R1 ⊕ F(L1, K0)
L0 = 0100 1001 ⊕ 1001 1100 = 1101 0101
L0 = 1101 0101

Final Value After Decryption: 1101 0101 1010 1111

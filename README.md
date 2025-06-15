# ALU-system-with-a-status-register-using-VHDL
This VHDL project models a **register-ALU system with a status register**, suitable for educational or basic processor design purposes. Here's a structured explanation of each module and how they integrate:

---

## 🔧 **1. `reg.vhd` – General-Purpose Register Module**

### **Function:**

Implements an 8-bit register with load (`L`) and enable (`E`) control signals.

### **Key Behavior:**

* **`L = '1'`**: Load input `x` into internal `temp`.
* **`E = '1'`**: Output `temp` to `y`.
* If neither `L` nor `E` is active, outputs `'XXXXXXXX'` (unknowns).

### **Purpose:**

Used to store and retrieve values — modeled like CPU registers (e.g., A, B, SR).

---

## 🧮 **2. `ALU.vhd` – Arithmetic Logic Unit**

### **Inputs:**

* `inp1`, `inp2` (8-bit inputs)
* `sel` (3-bit operation selector)
* `e` (enable)
* `clock`

### **Outputs:**

* `result` (8-bit output of ALU)
* `sr` (status register: carry, auxiliary carry, parity, sign, zero, overflow)

### **Operations (`sel` controlled):**

| `sel` | Operation | Description         |
| ----- | --------- | ------------------- |
| "000" | Add       | Signed addition     |
| "001" | Subtract  | Signed subtraction  |
| "010" | Increment | inp1 + 1            |
| "011" | Decrement | inp1 - 1            |
| "100" | AND       | Bitwise AND         |
| "101" | OR        | Bitwise OR          |
| "110" | XOR       | Bitwise XOR         |
| "111" | NOT       | Bitwise NOT on inp1 |

### **Status Register (`sr`):**

| Bit | Flag            | Meaning                   |
| --- | --------------- | ------------------------- |
| 7   | Reserved        | Unused (`'0'`)            |
| 6   | Reserved        | Unused (`'0'`)            |
| 5   | Overflow (`o`)  | Signed overflow           |
| 4   | Zero     (`z`)  | Result is zero            |
| 3   | Sign     (`s`)  | MSB of result             |
| 2   | Parity   (`p`)  | XOR of all bits in result |
| 1   | Aux Carry(`ac`) | Carry from bit 3          |
| 0   | Carry    (`c`)  | Carry from MSB            |

---

## 🧠 **3. `ALUwithSR.vhd` – Top-Level Integration Module**

### **Goal:**

Coordinates interaction between:

* Registers (A, B, SR)
* ALU
* External `value` bus

### **Control Signals:**

* `la`, `ea`: Load/enable for A register
* `lb`, `eb`: Load/enable for B register
* `lsr`, `esr`: Load/enable for Status Register
* `ealu`: Enable ALU
* `sel`: ALU operation selector
* `clock`

### **Ports:**

* `value`: Acts as bidirectional bus (inout), used to load/store data to/from registers or ALU.

### **Internal Wiring:**

* Three register instances: A, B, and SR
* ALU instance
* Signals for data interconnections and result/status forwarding

### **Process Highlights:**

* Uses a **`controls`** vector (7-bit) to encode combinations of control signals for decoding operations.
* Specific control patterns trigger read/write operations or ALU execution:

  * `"0101100"`: Write ALU result back to A (`ain <= alu_result`)
  * `"0100000"`: Output A to `value`
  * `"0001000"`: Output B to `value`
  * `"0000001"`: Output SR to `value`

### **Bidirectional Bus (`value`):**

Acts like a simple system bus. High impedance (`'Z'`) when not actively reading/writing.

---

## 🧩 **How It All Works Together:**

1. **Load Inputs:**

   * External data is placed on `value`.
   * Control signals like `la`, `lb`, `lsr` set to load data into A, B, or SR.

2. **ALU Execution:**

   * With `ealu = '1'`, the ALU processes inputs from A and B registers based on `sel`.
   * ALU outputs result and status.

3. **Output Handling:**

   * Based on `ea`, `eb`, `esr`, etc., output result or status register to `value`.

---

## 🧪 **Usage Example:**

To perform `A = A + B`:

1. Load values into A and B via `value` + `la`/`lb`.
2. Set `ealu = '1'`, `sel = "000"` (Add).
3. Wait for result to be computed.
4. Optionally, load `alu_result` back into A (using appropriate control code).
5. Enable SR (`lsr`/`esr`) to store or read flags like zero/carry/overflow.

---

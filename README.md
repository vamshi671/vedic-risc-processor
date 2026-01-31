# Vedic Multiplier Based RISC Processor

## 📌 Project Overview
This project implements a simple RISC processor architecture in Verilog HDL.  
The design integrates a **Vedic multiplier** for efficient multiplication operations and demonstrates a complete CPU datapath including instruction fetch, decode, execute, and write-back stages.

The processor is modular, fully synthesizable, and verified using waveform-based simulation.

---

## 🧠 Architecture Overview
The processor consists of the following main blocks:
- Program Counter (PC)
- Instruction Memory
- Control Unit
- Register File (8×8)
- ALU (Arithmetic, Logical, and Vedic Multiplier)
- Datapath Integration
- Top-level CPU module

---

## ⚙️ Instruction Set (Sample)
| Opcode | Operation |
|--------|-----------|
| 0000   | ADD       |
| 0001   | SUB       |
| 0010   | AND       |
| 0011   | MUL (Vedic) |

---

## 🧪 Verification & Simulation
The design was simulated using **Icarus Verilog**.  
Waveforms were visualized using the **WaveTracer VS Code extension** by loading generated `.vcd` files.

### ✔ Module-level verification
- ALU
- Register File (8×8)
- Vedic 2×2 Multiplier
- Vedic 4×4 Multiplier

### ✔ System-level verification
- Complete CPU (`cpu_top`)

### ✔ Key signals verified
- Program Counter (PC)
- Instruction Fetch
- Opcode Decode
- Register Read and Write
- ALU Operation Selection
- ALU Result
- Vedic Multiplier Output

Waveform screenshots are provided in the `waveforms/` directory.

---

## 📂 Project Structure
```text
VEDIC_RISC/
├── RTL/            # Verilog RTL source files
├── testbenches/    # Testbench files
├── waveforms/      # Waveform screenshots (PNG)
└── README.md
## 🛠️ Tools Used
- **Verilog HDL** – RTL design and modeling
- **Icarus Verilog** (`iverilog`, `vvp`) – Compilation and simulation
- **WaveTracer (VS Code Extension)** – Waveform visualization using `.vcd` files
- **Visual Studio Code** – Code editor
- **Git & GitHub** – Version control and project hosting

---

## 🚀 How to Run

### 1️⃣ Prerequisites
Make sure the following tools are installed:
- Icarus Verilog (`iverilog`, `vvp`)
- Visual Studio Code (optional)
- WaveTracer VS Code extension

---

### 2️⃣ Compile the Design
Run the following command from the project root directory:

```bash
iverilog -o cpu \
testbenches/tb_cpu_top.v \
RTL/cpu_top.v \
RTL/datapath.v \
RTL/control_unit.v \
RTL/alu_core.v \
RTL/alu_4bit.v \
RTL/regfile_8x8.v \
RTL/instr_mem.v \
RTL/pc.v \
RTL/vedic_2x2.v \
RTL/vedic_4x4.v
```

---

### 3️⃣ Run the Simulation
```bash
vvp cpu
```

This will generate a `.vcd` waveform file, which can be viewed using the **WaveTracer** extension in VS Code.

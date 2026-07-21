# Custom 8-bit CPU with Vedic Multiplier ALU

A small RISC-style CPU implemented in Verilog, featuring a hardware multiplier built from cascaded **Vedic multiplier** submodules instead of a standard `*` operator. Includes a full fetch–decode–execute datapath, register file, control unit, and self-checking testbenches for every module.

## Features

- **4-instruction ISA**: `ADD`, `SUB`, `AND`, `MUL`
- **16-bit instruction format**: `[15:12] opcode | [11:9] rd | [7:5] rs1 | [3:1] rs2`
- **8x8 register file** with R0 hardwired to zero (write-protected)
- **4x4 Vedic multiplier** built from four cascaded 2x2 Vedic multiplier submodules
- **Full CPU datapath**: PC → instruction memory → control unit → register file → ALU
- **Self-checking testbenches** with automated `PASS` / `FAIL` reporting for every module

## Project structure

```
.
├── design_vedic_2x2.v      # 2x2 Vedic multiplier
├── design_vedic_4x4.v      # 4x4 Vedic multiplier (built from four 2x2 units)
├── design_alu_4bit.v       # ALU: ADD, SUB, AND, and Vedic MUL
├── design_regfile_8x8.v    # 8x8 register file (R0 = zero register)
├── design_datapath.v       # Decode + control unit + regfile + ALU
├── design_cpu_top.v        # Top-level CPU: PC + instruction memory + datapath
├── tb_vedic_2x2.v          # Self-checking testbench
├── tb_vedic_4x4.v          # Self-checking testbench
├── tb_alu_4bit.v           # Self-checking testbench
├── tb_regfile_8x8.v        # Self-checking testbench
├── tb_datapath.v           # Testbench with live console monitor
├── tb_cpu_top.v            # Full CPU-level testbench
└── waveforms/              # Simulation waveform screenshots
```

## Module overview

| Module | Description |
|---|---|
| `vedic_2x2` | Computes a 2-bit x 2-bit product using the Vedic (Urdhva-Tiryagbhyam) cross-multiplication method. |
| `vedic_4x4` | Splits each 4-bit input into two 2-bit halves, computes four partial products with `vedic_2x2` instances, and combines them with shifted addition. |
| `alu_4bit` | 4-bit ALU supporting ADD, SUB, AND, and MUL (via `vedic_4x4`), selected by a 2-bit opcode. |
| `regfile_8x8` | 8 general-purpose 8-bit registers, synchronous write / combinational read, R0 always reads as 0. |
| `control_unit` | Decodes the instruction opcode into an ALU operation and a register-write enable signal. |
| `datapath` | Wires together instruction decode, control unit, register file, and ALU for one instruction cycle. |
| `cpu_top` | Adds a program counter and instruction memory on top of the datapath for a complete, running CPU. |

## Running the simulation

Using [Icarus Verilog](http://iverilog.icarus.com/):

```bash
# Example: simulate the 4x4 Vedic multiplier
iverilog -o vedic_4x4_sim design_vedic_4x4.v tb_vedic_4x4.v
vvp vedic_4x4_sim

# Example: simulate the full CPU
iverilog -o cpu_sim design_cpu_top.v tb_cpu_top.v
vvp cpu_sim
```

Each unit-level testbench (`tb_vedic_2x2`, `tb_vedic_4x4`, `tb_alu_4bit`, `tb_regfile_8x8`) prints a `PASS`/`FAIL` line per test vector and a final summary:

```
PASS: a=3 b=4 p=12
...
ALL TESTS PASSED
```

Waveforms can be viewed by opening the generated `.vcd` file in GTKWave or a similar viewer. Reference waveform captures are included in `waveforms/`.

## Example program (`instr_mem`)

The default program preloaded in `cpu_top` demonstrates all four operations, using the simulation-only register preload (`regs[i] = i`):

```
r3 = r1 + r2   (ADD)
r4 = r1 - r2   (SUB)
r5 = r1 & r2   (AND)
r6 = r5 * r4   (MUL, via Vedic multiplier)
```

## Notes

- The register file's `regs[i] = i` initial block is for simulation convenience only (giving testbenches non-zero operands before the first write) and is not synthesizable reset behavior; a real `reset` always clears all registers to 0.
- `tb_datapath.v` and `tb_cpu_top.v` verify behavior via VCD waveforms and live console monitoring rather than automated assertions.

// ===== Flattened design for EDA Playground =====

`ifndef ISA_DEFS_VH
`define ISA_DEFS_VH
// isa_defs.vh
// Instruction Set Architecture definitions
//
// Instruction layout (16 bits):
//   [15:12] opcode
//   [11:9]  rd   (3-bit register address, 8 registers)
//   [8]     unused
//   [7:5]   rs1  (3-bit register address)
//   [4]     unused
//   [3:1]   rs2  (3-bit register address)
//   [0]     unused
//
// NOTE: rd/rs1/rs2 are 3 bits wide (not 4) because regfile_8x8 only has
// 8 registers. This file previously declared 4-bit fields at the wrong
// bit positions, which never matched what datapath.v actually decoded
// (and this file was never `included anywhere, so the mismatch was silent).

// Instruction fields
`define OPCODE 15:12
`define RD     11:9
`define RS1    7:5
`define RS2    3:1

// Opcodes
`define OP_ADD 4'b0000
`define OP_SUB 4'b0001
`define OP_AND 4'b0010
`define OP_MUL 4'b0011

`endif // ISA_DEFS_VH

// ----- regfile_8x8.v -----
module regfile_8x8 (
    input        clk,
    input        reset,
    input        we,
    input  [2:0] rs1,
    input  [2:0] rs2,
    input  [2:0] rd,
    input  [7:0] wd,
    output [7:0] rd1,
    output [7:0] rd2
);

    reg [7:0] regs [0:7];

    integer i;
    initial begin
        // Simulation-only preload so datapath/CPU testbenches have
        // non-zero operands available before the first write.
        // A real reset (below) always clears everything to 0, and R0
        // is permanently write-protected as the architectural zero
        // register, matching tb_regfile_8x8's expectation that writes
        // to R0 never take effect.
        for (i = 0; i < 8; i = i + 1)
            regs[i] = i;
    end

    // Synchronous reset + write, with R0 hardwired to zero
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            for (i = 0; i < 8; i = i + 1)
                regs[i] <= 8'd0;
        end else if (we && rd != 3'd0) begin
            regs[rd] <= wd;
        end
    end

    // Read combinational, R0 always reads as 0 even before first reset
    assign rd1 = (rs1 == 3'd0) ? 8'd0 : regs[rs1];
    assign rd2 = (rs2 == 3'd0) ? 8'd0 : regs[rs2];

endmodule


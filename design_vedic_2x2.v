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

// ----- vedic_2x2.v -----
module vedic_2x2 (
    input  [1:0] a,
    input  [1:0] b,
    output [3:0] p
);

    wire p0;
    wire [1:0] temp1;
    wire [1:0] temp2;

    // LSB multiplication
    assign p0 = a[0] & b[0];

    // Cross multiplication
    assign temp1 = (a[1] & b[0]) + (a[0] & b[1]);

    //  MSB multiplication + carry
    assign temp2 = (a[1] & b[1]) + temp1[1];


    assign p[0] = p0;
    assign p[1] = temp1[0];
    assign p[2] = temp2[0];
    assign p[3] = temp2[1];

endmodule


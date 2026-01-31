// isa_defs.vh
// Instruction Set Architecture definitions

// Instruction fields
`define OPCODE 15:12
`define RD     11:8
`define RS1    7:4
`define RS2    3:0

// Opcodes
`define OP_ADD 4'b0000
`define OP_SUB 4'b0001
`define OP_AND 4'b0010
`define OP_MUL 4'b0011

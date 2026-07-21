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

// ----- datapath.v -----

module datapath (
    input        clk,
    input        reset,
    input [15:0] instruction
);

    // Instruction decode
    wire [3:0] opcode;
    wire [2:0] rd, rs1, rs2;

    assign opcode = instruction[`OPCODE];
    assign rd     = instruction[`RD];
    assign rs1    = instruction[`RS1];
    assign rs2    = instruction[`RS2];

    // Control
    wire [1:0] alu_op;
    wire       reg_write;

    // Data
    wire [7:0] reg_data1, reg_data2;
    wire [7:0] alu_result;

    // Control Unit
    control_unit CU (
        .opcode(opcode),
        .alu_op(alu_op),
        .reg_write(reg_write)
    );

    // Register File
    regfile_8x8 RF (
        .clk(clk),
        .reset(reset),
        .we(reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(alu_result),
        .rd1(reg_data1),
        .rd2(reg_data2)
    );

    // ALU
    alu_core ALU (
        .A(reg_data1[3:0]),
        .B(reg_data2[3:0]),
        .op(alu_op),
        .result(alu_result)
    );

endmodule

// ----- control_unit.v -----
module control_unit (
    input  [3:0] opcode,
    output reg [1:0] alu_op,
    output reg       reg_write
);

always @(*) begin
    reg_write = 1'b1;

    case (opcode)
        4'b0000: alu_op = 2'b00; // ADD
        4'b0001: alu_op = 2'b01; // SUB
        4'b0010: alu_op = 2'b10; // AND
        4'b0011: alu_op = 2'b11; // MUL
        default: begin
            alu_op    = 2'b00;
            reg_write = 1'b0;
        end
    endcase
end

endmodule

// ----- alu_core.v -----
module alu_core (
    input  [3:0] A,
    input  [3:0] B,
    input  [1:0] op,
    output [7:0] result
);
    alu_4bit alu (
        .A(A),
        .B(B),
        .op(op),
        .result(result)
    );
endmodule

// ----- alu_4bit.v -----
module alu_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input  [1:0] op,
    output reg [7:0] result
);

    wire [4:0] add_out;
    wire [4:0] sub_out;
    wire [3:0] and_out;
    wire [7:0] mul_out;

    // ADD
    assign add_out = A + B;

    // SUB
    assign sub_out = A - B;

    // AND
    assign and_out = A & B;

    // Vedic Multiplier 
    vedic_4x4 mul (
        .a(A),
        .b(B),
        .p(mul_out)
    );

    // ALU selection
    always @(*) begin
        case (op)
            2'b00: result = {3'b000, add_out}; 
            2'b01: result = {3'b000, sub_out}; 
            2'b10: result = {4'b0000, and_out}; 
            2'b11: result = mul_out;             
            default: result = 8'b0;
        endcase
    end

endmodule

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

// ----- vedic_4x4.v -----
module vedic_4x4 (
    input  [3:0] a,
    input  [3:0] b,
    output [7:0] p
);

    // Split inputs into high and low 2-bit parts
    wire [1:0] a_low  = a[1:0];
    wire [1:0] a_high = a[3:2];
    wire [1:0] b_low  = b[1:0];
    wire [1:0] b_high = b[3:2];

    // Outputs of 2x2 multipliers
    wire [3:0] m0, m1, m2, m3;

    // Instantiate four 2x2 Vedic multipliers
    vedic_2x2 M0 (.a(a_low),  .b(b_low),  .p(m0));
    vedic_2x2 M1 (.a(a_low),  .b(b_high), .p(m1));
    vedic_2x2 M2 (.a(a_high), .b(b_low),  .p(m2));
    vedic_2x2 M3 (.a(a_high), .b(b_high), .p(m3));

    // Combine partial products with shifts
    assign p = m0
             + (m1 << 2)
             + (m2 << 2)
             + (m3 << 4);

endmodule


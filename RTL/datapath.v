module datapath (
    input        clk,
    input [15:0] instruction
);

    // Instruction decode
    wire [3:0] opcode;
    wire [2:0] rd, rs1, rs2;

    assign opcode = instruction[15:12];
    assign rd     = instruction[11:9];
    assign rs1    = instruction[7:5];
    assign rs2    = instruction[3:1];

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

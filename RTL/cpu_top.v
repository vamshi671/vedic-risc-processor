module cpu_top (
    input clk,
    input reset
);

    wire [7:0] pc_val;
    wire [15:0] instr;

    pc PC (
        .clk(clk),
        .reset(reset),
        .pc(pc_val)
    );

    instr_mem IM (
        .addr(pc_val),
        .instr(instr)
    );

    datapath DP (
        .clk(clk),
        .instruction(instr)
    );

endmodule

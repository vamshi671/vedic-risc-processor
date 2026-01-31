module regfile_8x8 (
    input        clk,
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
        for (i = 0; i < 8; i = i + 1)
            regs[i] = i;   // preload for testing
    end

    // Write on clock
    always @(posedge clk) begin
        if (we)
            regs[rd] <= wd;
    end

    // Read combinational
    assign rd1 = regs[rs1];
    assign rd2 = regs[rs2];

endmodule

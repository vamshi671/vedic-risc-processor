module tb_regfile_8x8;

    reg         clk;
    reg         we;
    reg  [2:0]  rs1, rs2, rd;
    reg  [7:0]  wd;
    wire [7:0]  rd1, rd2;

    // Instantiate Register File
    regfile_8x8 uut (
        .clk(clk),
        .we(we),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .wd(wd),
        .rd1(rd1),
        .rd2(rd2)
    );

    // Clock generation (10 time units period)
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        we  = 0;
        rs1 = 0;
        rs2 = 0;
        rd  = 0;
        wd  = 0;

        $dumpfile("regfile_8x8.vcd");
        $dumpvars(0, tb_regfile_8x8);

        // ---- Write operations ----
        #10;
        we = 1; rd = 3'd1; wd = 8'd10;   // R1 = 10
        #10;
        rd = 3'd2; wd = 8'd25;           // R2 = 25
        #10;
        rd = 3'd3; wd = 8'd100;          // R3 = 100

        // Try writing to R0 (should NOT change)
        #10;
        rd = 3'd0; wd = 8'd55;           // R0 must stay 0

        // Disable write
        #10;
        we = 0;

        // ---- Read operations ----
        #10;
        rs1 = 3'd1; rs2 = 3'd2;          // Expect 10, 25
        #10;
        rs1 = 3'd3; rs2 = 3'd0;          // Expect 100, 0
        #10;
        rs1 = 3'd2; rs2 = 3'd1;          // Expect 25, 10

        #20;
        $finish;
    end

endmodule

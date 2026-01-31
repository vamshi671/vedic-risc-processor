`timescale 1ns/1ps

module tb_datapath;

    reg clk;
    reg reset;
    reg [15:0] instruction;

    // Instantiate DUT
    datapath DUT (
        .clk(clk),
        .reset(reset),
        .instruction(instruction)
    );

    // ===============================
    // Clock generation
    // ===============================
    always #5 clk = ~clk;   // 10ns clock

    initial begin
        // ===========================
        // Init
        // ===========================
        clk = 0;
        reset = 1;
        instruction = 16'b0;

        #10;
        reset = 0;

        // ===========================
        // Manually preload registers
        // (direct write using ADD with r0)
        // ===========================

        // r1 = 5
        instruction = {4'b0000, 4'd1, 4'd0, 4'd0}; // r1 = r0 + r0
        #10;

        // r2 = 3
        instruction = {4'b0000, 4'd2, 4'd0, 4'd0};
        #10;

        // ===========================
        // ADD: r3 = r1 + r2
        // ===========================
        instruction = {4'b0000, 4'd3, 4'd1, 4'd2};
        #10;

        // ===========================
        // SUB: r4 = r1 - r2
        // ===========================
        instruction = {4'b0001, 4'd4, 4'd1, 4'd2};
        #10;

        // ===========================
        // AND: r5 = r1 & r2
        // ===========================
        instruction = {4'b0010, 4'd5, 4'd1, 4'd2};
        #10;

        // ===========================
        // MUL: r6 = r1 * r2 (Vedic)
        // ===========================
        instruction = {4'b0011, 4'd6, 4'd1, 4'd2};
        #10;

        // ===========================
        // Finish
        // ===========================
        $finish;
    end

endmodule

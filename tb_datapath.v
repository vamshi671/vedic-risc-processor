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

    // ===============================
    // Waveform dump (added)
    // ===============================
    initial begin
        $dumpfile("datapath.vcd");
        $dumpvars(0, DUT);
    end

    // ===============================
    // Live console print (added)
    // ===============================
    initial begin
        $monitor("t=%0t instr=%h opcode=%b rd=%0d rs1=%0d rs2=%0d",
                  $time, instruction, instruction[15:12], instruction[11:9],
                  instruction[7:5], instruction[3:1]);
    end

    initial begin
        // ===========================
        // Init
        // ===========================
        clk = 0;
        reset = 1;
        instruction = 16'b0;

        #10;
        reset = 0;

        // regfile_8x8 preloads regs[i] = i, so r1=1, r2=2, r4=4, r5=5, etc.
        // Instruction format: opcode[15:12] rd[11:9] _ rs1[7:5] _ rs2[3:1] _

        // ADD: r3 = r1 + r2  (expect 1 + 2 = 3)
        instruction = {4'b0000, 3'd3, 1'b0, 3'd1, 1'b0, 3'd2, 1'b0};
        #10;

        // SUB: r6 = r5 - r2  (expect 5 - 2 = 3)
        instruction = {4'b0001, 3'd6, 1'b0, 3'd5, 1'b0, 3'd2, 1'b0};
        #10;

        // AND: r7 = r5 & r4  (expect 5 & 4 = 4)
        instruction = {4'b0010, 3'd7, 1'b0, 3'd5, 1'b0, 3'd4, 1'b0};
        #10;

        // MUL: r6 = r5 * r4 (Vedic, expect 5 * 4 = 20)
        instruction = {4'b0011, 3'd6, 1'b0, 3'd5, 1'b0, 3'd4, 1'b0};
        #10;

        // Finish
        $finish;
    end

endmodule
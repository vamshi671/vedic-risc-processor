module tb_vedic_4x4;

    reg  [3:0] a, b;
    wire [7:0] p;

    // Instantiate the DUT
    vedic_4x4 uut (
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin
        $dumpfile("vedic_4x4.vcd");
        $dumpvars(0, tb_vedic_4x4);

        // Test cases
        a = 4'd0;  b = 4'd0;   #20;   // 0  x 0  = 0
        a = 4'd3;  b = 4'd4;   #20;   // 3  x 4  = 12
        a = 4'd9;  b = 4'd6;   #20;   // 9  x 6  = 54
        a = 4'd7;  b = 4'd8;   #20;   // 7  x 8  = 56
        a = 4'd15; b = 4'd15;  #20;   // 15 x 15 = 225

        $finish;
    end

endmodule

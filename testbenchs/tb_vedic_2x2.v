module tb_vedic_2x2;

    reg  [1:0] a, b;
    wire [3:0] p;

    // Instantiate the DUT
    vedic_2x2 uut (
        .a(a),
        .b(b),
        .p(p)
    );

    initial begin
        $dumpfile("vedic_2x2.vcd");
        $dumpvars(0, tb_vedic_2x2);

        // Test cases
        a = 2'b00; b = 2'b00; #20;   // 0 × 0 = 0
        a = 2'b01; b = 2'b01; #20;   // 1 × 1 = 1
        a = 2'b10; b = 2'b11; #20;   // 2 × 3 = 6
        a = 2'b11; b = 2'b11; #20;   // 3 × 3 = 9
        a = 2'b01; b = 2'b10; #20;   // 1 × 2 = 2

        $finish;
    end

endmodule

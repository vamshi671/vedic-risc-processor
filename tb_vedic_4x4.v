module tb_vedic_4x4;

    reg  [3:0] a, b;
    wire [7:0] p;

    // Instantiate the DUT
    vedic_4x4 uut (
        .a(a),
        .b(b),
        .p(p)
    );

    integer errors = 0;

    task check(input [7:0] expected);
        begin
            if (p !== expected) begin
                errors = errors + 1;
                $display("FAIL: a=%0d b=%0d p=%0d expected=%0d", a, b, p, expected);
            end else
                $display("PASS: a=%0d b=%0d p=%0d", a, b, p);
        end
    endtask

    initial begin
        $dumpfile("vedic_4x4.vcd");
        $dumpvars(0, tb_vedic_4x4);

        // Test cases
        a = 4'd0;  b = 4'd0;   #20; check(0);    // 0  x 0  = 0
        a = 4'd3;  b = 4'd4;   #20; check(12);   // 3  x 4  = 12
        a = 4'd9;  b = 4'd6;   #20; check(54);   // 9  x 6  = 54
        a = 4'd7;  b = 4'd8;   #20; check(56);   // 7  x 8  = 56
        a = 4'd15; b = 4'd15;  #20; check(225);  // 15 x 15 = 225

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule

module tb_vedic_2x2;

    reg  [1:0] a, b;
    wire [3:0] p;

    // Instantiate the DUT
    vedic_2x2 uut (
        .a(a),
        .b(b),
        .p(p)
    );

    integer errors = 0;

    task check(input [3:0] expected);
        begin
            if (p !== expected) begin
                errors = errors + 1;
                $display("FAIL: a=%0d b=%0d p=%0d expected=%0d", a, b, p, expected);
            end else
                $display("PASS: a=%0d b=%0d p=%0d", a, b, p);
        end
    endtask

    initial begin
        $dumpfile("vedic_2x2.vcd");
        $dumpvars(0, tb_vedic_2x2);

        // Test cases
        a = 2'b00; b = 2'b00; #20; check(0);    // 0 x 0 = 0
        a = 2'b01; b = 2'b01; #20; check(1);    // 1 x 1 = 1
        a = 2'b10; b = 2'b11; #20; check(6);    // 2 x 3 = 6
        a = 2'b11; b = 2'b11; #20; check(9);    // 3 x 3 = 9
        a = 2'b01; b = 2'b10; #20; check(2);    // 1 x 2 = 2

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule

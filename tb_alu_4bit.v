module tb_alu_4bit;

    reg  [3:0] A, B;
    reg  [1:0] op;
    wire [7:0] result;

    // Instantiate ALU
    alu_4bit uut (
        .A(A),
        .B(B),
        .op(op),
        .result(result)
    );

    integer errors = 0;

    task check(input [7:0] expected);
        begin
            if (result !== expected) begin
                errors = errors + 1;
                $display("FAIL: op=%b A=%0d B=%0d result=%0d expected=%0d", op, A, B, result, expected);
            end else
                $display("PASS: op=%b A=%0d B=%0d result=%0d", op, A, B, result);
        end
    endtask

    initial begin
        $dumpfile("alu_4bit.vcd");
        $dumpvars(0, tb_alu_4bit);

        //ADD
        op = 2'b00;
        A = 4'd5;  B = 4'd3;  #20; check(8);
        A = 4'd9;  B = 4'd6;  #20; check(15);

        // SUB
        op = 2'b01;
        A = 4'd10; B = 4'd4;  #20; check(6);
        A = 4'd7;  B = 4'd2;  #20; check(5);

        // AND
        op = 2'b10;
        A = 4'b1100; B = 4'b1010; #20; check(8);
        A = 4'b0110; B = 4'b0011; #20; check(2);

        // MUL (Vedic)
        op = 2'b11;
        A = 4'd3;  B = 4'd4;  #20; check(12);
        A = 4'd9;  B = 4'd6;  #20; check(54);
        A = 4'd15; B = 4'd15; #20; check(225);

        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("%0d TEST(S) FAILED", errors);

        $finish;
    end

endmodule

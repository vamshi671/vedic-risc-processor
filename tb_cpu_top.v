module tb_cpu_top;

    reg clk = 0;
    reg reset = 1;

    cpu_top DUT (
        .clk(clk),
        .reset(reset)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("cpu.vcd");

        // 🔥 DUMP EVERYTHING UNDER DUT (THIS IS THE KEY)
        $dumpvars(0, DUT);

        #10 reset = 0;
        #120 $finish;
    end

endmodule

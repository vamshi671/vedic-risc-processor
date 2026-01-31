module alu_core (
    input  [3:0] A,
    input  [3:0] B,
    input  [1:0] op,
    output [7:0] result
);
    alu_4bit alu (
        .A(A),
        .B(B),
        .op(op),
        .result(result)
    );
endmodule

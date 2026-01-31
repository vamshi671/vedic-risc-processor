module alu_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input  [1:0] op,
    output reg [7:0] result
);

    wire [4:0] add_out;
    wire [4:0] sub_out;
    wire [3:0] and_out;
    wire [7:0] mul_out;

    // ADD
    assign add_out = A + B;

    // SUB
    assign sub_out = A - B;

    // AND
    assign and_out = A & B;

    // Vedic Multiplier 
    vedic_4x4 mul (
        .a(A),
        .b(B),
        .p(mul_out)
    );

    // ALU selection
    always @(*) begin
        case (op)
            2'b00: result = {3'b000, add_out}; 
            2'b01: result = {3'b000, sub_out}; 
            2'b10: result = {4'b0000, and_out}; 
            2'b11: result = mul_out;             
            default: result = 8'b0;
        endcase
    end

endmodule

module control_unit (
    input  [3:0] opcode,
    output reg [1:0] alu_op,
    output reg       reg_write
);

always @(*) begin
    reg_write = 1'b1;

    case (opcode)
        4'b0000: alu_op = 2'b00; // ADD
        4'b0001: alu_op = 2'b01; // SUB
        4'b0010: alu_op = 2'b10; // AND
        4'b0011: alu_op = 2'b11; // MUL
        default: begin
            alu_op    = 2'b00;
            reg_write = 1'b0;
        end
    endcase
end

endmodule

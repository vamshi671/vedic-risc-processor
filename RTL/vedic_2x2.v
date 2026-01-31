module vedic_2x2 (
    input  [1:0] a,
    input  [1:0] b,
    output [3:0] p
);

    wire p0;
    wire [1:0] temp1;
    wire [1:0] temp2;

    // LSB multiplication
    assign p0 = a[0] & b[0];

    // Cross multiplication
    assign temp1 = (a[1] & b[0]) + (a[0] & b[1]);

    //  MSB multiplication + carry
    assign temp2 = (a[1] & b[1]) + temp1[1];


    assign p[0] = p0;
    assign p[1] = temp1[0];
    assign p[2] = temp2[0];
    assign p[3] = temp2[1];

endmodule

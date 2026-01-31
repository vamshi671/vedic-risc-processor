module vedic_4x4 (
    input  [3:0] a,
    input  [3:0] b,
    output [7:0] p
);

    // Split inputs into high and low 2-bit parts
    wire [1:0] a_low  = a[1:0];
    wire [1:0] a_high = a[3:2];
    wire [1:0] b_low  = b[1:0];
    wire [1:0] b_high = b[3:2];

    // Outputs of 2x2 multipliers
    wire [3:0] m0, m1, m2, m3;

    // Instantiate four 2x2 Vedic multipliers
    vedic_2x2 M0 (.a(a_low),  .b(b_low),  .p(m0));
    vedic_2x2 M1 (.a(a_low),  .b(b_high), .p(m1));
    vedic_2x2 M2 (.a(a_high), .b(b_low),  .p(m2));
    vedic_2x2 M3 (.a(a_high), .b(b_high), .p(m3));

    // Combine partial products with shifts
    assign p = m0
             + (m1 << 2)
             + (m2 << 2)
             + (m3 << 4);

endmodule

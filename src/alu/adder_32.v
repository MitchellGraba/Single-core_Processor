`include "src/alu/lookahead_generator_16.v"

module adder_32(
    input wire [31:0] x,y,

    output wire [31:0] sum,
    output wire c32
);

wire c16;

wire c0 = 0;

lookahead_generator_16 lower(
    x[15:0],y[15:0],c0,
    sum[15:0],c16
);

lookahead_generator_16 upper(
    x[31:16],y[31:16],c16,
    sum[31:16],c32
);

endmodule
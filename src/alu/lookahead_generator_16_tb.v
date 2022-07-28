`include "src/alu/lookahead_generator_16.v"
`timescale 1ms/1ms

module lookahead_generator_16_tb();

reg [15:0] x,y;
reg c0;

wire [15:0] sum;
wire c16;

lookahead_generator_16 my_generator(x,y,c0,sum,c16);

initial begin
    x=0;y=0;c0=0;
    $monitor("x=%d,y=%d,c0=%b | sum=%d,c16=%b",x,y,c0,sum,c16);
    x=7;y=8;c0=1;#10;
    x=60000;y=340;#10;
    x=60000;y=60000;#10;
end

endmodule
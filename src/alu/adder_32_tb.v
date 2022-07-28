`include "src/alu/adder_32.v"
`timescale 1ms/1ms

module adder_32_tb();

reg signed [31:0] x,y;
wire signed [31:0] sum;
wire c32;

adder_32 my_adder(x,y,sum,c32);

initial begin
    $monitor("x=%d,y=%d | sum=%d,c32=%d",x,y,sum,c32);
    x=20;y=-4;#10;
end

endmodule
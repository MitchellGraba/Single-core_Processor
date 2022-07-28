`timescale 1ms/1ms
`include "src/register64.v"

module register_tb();

wire [31:0] Q;
reg clk,register,input_enable,low_enable,high_enable,reset;
reg [63:0] D;

register64 register_a(clr,clk,input_enable,low_enable,high_enable,D,Q);

initial begin
	$monitor("clr=%b,  write_enable=%b, low_enable = %b, high_enable = %b, D=%d, Q=%d",reset,input_enable,low_enable, high_enable,D,Q);
	low_enable=1;
	clk=0; reset=0; input_enable=1; D = 64'h 00000000FFFFFFFF;  high_enable = 0; low_enable = 0; #10;
	clk=1; #10;
	clk=0; #10;
    input_enable = 0;
    high_enable = 0;
	low_enable = 1;
    clk=1; #10;
	clk=0; #10;
    low_enable = 0;
    high_enable = 1;

	
end

endmodule

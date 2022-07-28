`timescale 1ms/1ms
`include "src/register.v"

module register_tb();

wire [31:0] Q;
reg clk,register,input_enable,output_enable,reset;
integer D;

register register_a(clr,clk,input_enable,output_enable,D,Q);

initial begin
	$monitor("clr=%b, clk=%b, input_enable=%b, output_enable=%b | D=%d, Q=%d",reset,clk,input_enable,output_enable,D,Q);
	output_enable=1;
	clk=0; reset=0; input_enable=1; D=24; #10;
	clk=1; #10;
	if (Q!=24) $display("ERROR");
	clk=0; #10;
	
	reset=1; #10;

	reset=0;clk=1;input_enable=0; #10;

	output_enable=0;
	#100;
	if (Q!=0) $display("ERROR");
	$finish;
end

endmodule

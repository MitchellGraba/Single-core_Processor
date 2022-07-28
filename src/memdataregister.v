`include "src/register.v"

module memdataregister(
	input reset,clk,input_enable,output_enable,
	input [31:0] D,
	output [31:0] Q,
	input [31:0] Mdata,
	input Read
);

register my_register(reset,clk,input_enable,output_enable,Read?Mdata:D,Q);

endmodule
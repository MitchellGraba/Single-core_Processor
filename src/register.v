`ifndef REGISTER

module register(reset,clk,input_enable,output_enable,D,Q);

input reset,clk,input_enable,output_enable;
input [31:0] D;
reg [31:0] data;
output wire [31:0] Q;

assign Q = output_enable ? data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

initial begin
	data<=0;
end

always @ (posedge clk) begin
	if (reset) begin
		data<=0;
	end
	else if (input_enable) begin
		data<=D;
	end
end

endmodule

`endif

`define REGISTER
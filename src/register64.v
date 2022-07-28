module register64(reset,clk,input_enable,low_enable, high_enable, D,Q);
//supted
input reset,clk,input_enable, low_enable, high_enable;
input [63:0] D;
reg [63:0] data;

output wire [31:0] Q;

assign Q = low_enable ? data[31:0] : high_enable ? data[63:32] : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

initial data<=0;

always @ (posedge clk) begin
	if (reset) begin
		data<=0;
	end
	else if (input_enable) begin
		data<=D;
	end
end

endmodule
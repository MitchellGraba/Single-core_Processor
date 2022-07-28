module ram(
    input wire clk,
    input wire [31:0] addr_in,
    input wire [31:0] data_in,
    input wire write_enable,
    output wire [31:0] data_out
);

reg [31:0] my_memory [511:0];

genvar index;
generate
for (index=0;index<512;index=index+1) begin : mem_cells
    // initialize data so i can tell where it is by value
    initial my_memory[index] = 512-1-index;
end
endgenerate

always @(posedge clk) begin
    if (write_enable)    my_memory[addr_in] = data_in;
end

assign data_out = my_memory[addr_in];

endmodule
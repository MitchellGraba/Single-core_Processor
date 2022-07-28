module decoder4to16(
    input wire [3:0] rnum,
    output wire [15:0] r_select_vec
);

genvar i;
generate

for(i = 0; i < 16; i = i + 1) begin : r_selection
    assign r_select_vec[i] = (i == rnum);
end
endgenerate

endmodule
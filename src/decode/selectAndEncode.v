module selectAndEncode(
    input wire [15:0] r_select_vec,
    input wire r_in_enable,
    input wire r_out_enable,
    input wire BA_out,
    output wire [15:0] r_out,
    output wire [15:0] r_in
);

assign r_in = r_in_enable ? r_select_vec : 0;
assign r_out = (r_out_enable | BA_out) ? r_select_vec : 0;

endmodule
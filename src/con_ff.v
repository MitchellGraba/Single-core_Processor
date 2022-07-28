module con_ff(
    input wire [31:0] IR,
    input wire signed [31:0] bus,
    output wire do_branch
);

wire [3:0] c2 = IR[22:19];
wire [1:0] c2_low = c2[1:0];

assign do_branch = 
    // eq 0
    (c2_low==2'b00 ? bus==0 : 0) |
    // neq 0
    (c2_low==2'b01 ? bus!=0 : 0) |
    // gtr 0
    (c2_low==2'b10 ? bus>0 : 0) |
    // lessthan 0
    (c2_low==2'b11 ? bus<0 : 0)
;

endmodule
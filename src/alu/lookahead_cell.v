module lookahead_cell(
    input wire x,y,c,
    output wire g,p,sum
);

assign g=x&y;
assign p=x|y;
assign sum = x^y^c;

endmodule
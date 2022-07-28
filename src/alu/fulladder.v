module fulladder(
    input x,y,cin,
    output cout,sum
);

assign cout=(x&y) | (x&cin) | (y&cin);
assign sum=x^y^cin;

endmodule
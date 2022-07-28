`timescale 1ms/1ms
`include "src/alu/carrylookahead.v"

module carrylookahead_tb();

reg [3:0] x,y;
reg c0;
wire [3:0] sum;
wire P,G;

carrylookahead mycarrylookahead(x,y,c0,sum,P,G);

initial begin
    c0=0;x=0;y=0;
    $monitor("x=%d,y=%d,sum=%d,P=%b,G=%b",x,y,sum,P,G);
    x=10;y=3;#10;
    x=4;#10;
    x=8;y=7;#10;
    x=8;y=10;#10;
end

endmodule
`timescale 1ms/1ms
`include "src/alu/lookahead_cell.v"

module lookahead_cell_tb();

reg x,y,c;
wire g,p,sum;

lookahead_cell my_cell(x,y,c,g,p,sum);

initial begin
    x<=0;y<=0;c<=0;#10;
    $monitor("x=%b, y=%b, c=%b, g=%b,p=%b,sum=%b",x,y,c,g,p,sum);
    x<=0;y<=1;c<=0;#10;
    x<=1;y<=1;c<=0;#10;
    x<=0;y<=0;c<=1;#10;
    x<=1;y<=1;c<=1;#10;
end

endmodule
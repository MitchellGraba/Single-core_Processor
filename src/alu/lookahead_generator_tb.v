`timescale 1ms/1ms
`include "src/alu/lookahead_generator.v"

module lookahead_generator_tb();

reg [3:0] p,g;
reg c0;

wire P,G;
wire [3:1] c;

lookahead_generator my_generator(p,g,c0,P,G,c);

initial begin
    p=0;g=0;c0=0;
    $monitor("p=%b,g=%b,c0=%b | P=%b,G=%b,c=%b",p,g,c0,P,G,c);
    p=4'b0010;g=4'b0010;c0=0;#10;
    p=4'b1100;g=4'b0011;c0=0;#10;
    p=4'b1111;g=4'b1111;c0=1;#10;
end

endmodule
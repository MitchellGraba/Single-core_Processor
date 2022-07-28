// TODO finish this

`include "src/alu/fulladder.v"

module carrylookahead(
    input [3:0] x,y,
    input c0,
    output [3:0] sum,
    output wire P,G
);

wire [3:0] p,g;
wire [4:0] c;

assign g=x&y;
assign p=x|y;

assign c[0] = c0;
assign c[1] = g[0]|(p[0]&c[0]);
assign c[2] = g[1]|(p[1]&c[1]);
assign c[3] = g[2]|(p[2]&c[2]);
assign c[4] = g[3]|(p[3]&c[3]);

assign P = p[0]&p[1]&p[2]&p[3];
assign G = (g[0]&p[1]&p[2]&p[3]) | (g[1]&p[2]&p[3]) | (g[2]&p[3]) | g[3];

// ditch the carries because we dont care about them    
wire[3:0] throwaway;

fulladder adder_bit0(x[0],y[0],c[0],throwaway[0],sum[0]);
fulladder adder_bit1(x[1],y[1],c[1],throwaway[1],sum[1]);
fulladder adder_bit2(x[2],y[2],c[2],throwaway[2],sum[2]);
fulladder adder_bit3(x[3],y[3],c[3],throwaway[3],sum[3]);

endmodule
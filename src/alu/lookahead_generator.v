module lookahead_generator(
    input wire [3:0] p,g,
    input wire c0,

    output wire P,G,
    output [3:1] c
);

assign c[1] = g[0] | (p[0]&c0);
assign c[2] = g[1] | (p[1]&c[1]);
assign c[3] = g[2] | (p[2]&c[2]);

assign P = p[0]&p[1]&p[2]&p[3];
assign G = 
    (g[0]&p[1]&p[2]&p[3]) |
    (g[1]&p[2]&p[3]) |
    (g[2]&p[3]) |
    (g[3]);

endmodule
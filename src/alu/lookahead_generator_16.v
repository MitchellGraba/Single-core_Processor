`include "src/alu/lookahead_generator.v"
`include "src/alu/lookahead_cell.v"

module lookahead_generator_16(
    input wire [15:0] x,y,
    input wire c0,

    output wire [15:0] sum,
    output wire c16
);

// low level carry line
wire [16:0] c;
assign c[0] = c0;

// low level generate proporgate
wire [15:0] g,p;
// mid level generate propogate
wire [3:0] G,P;
// top level generate propogate
wire GG,PP;

wire [3:1] cc;
assign c[4] = cc[1];
assign c[8] = cc[2];
assign c[12] = cc[3];

genvar index;
generate
// low level lookahead cell
for (index=0;index<16;index=index+1) begin : low_cells
    lookahead_cell cell_inst(
        x[index],y[index],c[index],
        g[index],p[index],sum[index]
    );
end
// mid level generators
for (index=0;index<4;index=index+1) begin : mid_cells
    lookahead_generator generator_inst(
        p[index*4+3:index*4],g[index*4+3:index*4],c[index*4],
        P[index],G[index],c[index*4+3:index*4+1]
    );
end
endgenerate

// top level generator
lookahead_generator top_gen(
    P,G,c0,
    PP,GG,cc
);

assign c[16] = (c0&PP) | GG;
assign c16 = c[16];

endmodule
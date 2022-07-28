`include "src/alu/adder_32.v"
`include "src/alu/boothmult.v"
`include "src/alu/division.v"
`include "src/alu/shiftright.v"
`include "src/alu/shiftleft.v"
`include "src/alu/rotateright.v"
`include "src/alu/rotateleft.v"

module alu(
    input [31:0] A,B,
    output [63:0] C,

    input ADD,SUB,MUL,DIV,SHR,SHL,ROR,ROL,AND,OR,NEG,NOT,

    input INC,

    input clk,start
);

wire [32:0] add_out;

adder_32 adder(
    .x(A),
    .y(B),
    .sum(add_out[31:0]),
    .c32(add_out[32])
);

wire [31:0] B_Signed = B;
wire [32:0] subtract_out;

adder_32 subtractor(
    .x(A),
    .y(-B_Signed),
    .sum(subtract_out[31:0]),
    .c32(subtract_out[32])
);

wire [63:0] product;
wire mult_done;

boothmult multiplier(
    .M(A),
    .Q(B),
    .clk(clk),
    .start(start),
    .out(product),
    .done(mult_done)
);

wire [63:0] div_out;

wire reset = 0;

division divider(
    .clk(clk),
    .reset(reset),
    .start(start),
    .A(A),
    .B(B),
    .D(div_out[31:0]),
    .R(div_out[63:32])
);

wire [31:0] neg_out = !B;
wire [31:0] not_out = ~B;

wire [31:0] shiftright_out,shiftleft_out,rotateright_out,rotateleft_out;
shiftright shifter_right(
    .A(A),
    .B(B[5:0]),
    .clk(clk),
    .start(start),
    .C(shiftright_out)
);
shiftleft shifter_left(
    .A(A),
    .B(B[5:0]),
    .clk(clk),
    .start(start),
    .C(shiftleft_out)
);
rotateright rotate_right(
    .A(A),
    .B(B[5:0]),
    .clk(clk),
    .start(start),
    .C(rotateright_out)
);
rotateleft rotate_left(
    .A(A),
    .B(B[5:0]),
    .clk(clk),
    .start(start),
    .C(rotateleft_out)
);

assign C = 
    (AND ? (A&B) : 0) |
    (OR ? (A|B) : 0) |
    (ADD ? add_out : 0) |
    (MUL ? product : 0) |
    (SUB ? subtract_out : 0) |
    (DIV ? div_out : 0) | 
    (NOT ? not_out : 0) |
    (NEG ? neg_out : 0) |
    (SHR ? shiftright_out : 0) | 
    (SHL ? shiftleft_out : 0) |
    (ROR ? rotateright_out : 0) |
    (ROL ? rotateleft_out : 0) |
    (INC ? (B+1) : 0)
;

endmodule
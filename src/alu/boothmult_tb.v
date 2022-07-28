`timescale 1ms/1ms
`include "src/alu/boothmult.v"

module boothmult_tb();

reg [31:0] M = 2;
reg [31:0] Q = 3;
wire [63:0] out;

wire [31:0] upper,lower;
assign upper = out[63:32];
assign lower = out[31:0];

wire done;

reg clk,start;

boothmult my_boothmult(M,Q,clk,start,out,done);

initial begin
    clk=0;start=1;#10;clk=1;#10;start=0;#10;
    $monitor("M=%d, Q=%d, out=%d, upper=%b, lower=%b, done=%d",M,Q,out,upper,lower,done);
    // clock cycles (32 of them)
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    clk=1;#10;clk=0;#10;
    // extry cycle to see if it breaks
    clk=1;#10;clk=0;#10;
end

endmodule
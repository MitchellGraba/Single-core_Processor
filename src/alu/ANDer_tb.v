`timescale 1ms/1ms
`include "src/alu/ANDer.v"

module and_tb();

reg [31:0] rx,ry;
wire [31:0] rz;

ANDer my_ander(rx,ry,rz);

initial begin
    $display("AND testbench");
    $monitor("rx=%b, ry=%b, rz=%b",rx,ry,rz);
    rx=4;ry=2;#10;
    rx=4;ry=7;#10;
end

endmodule

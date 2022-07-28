`timescale 1ms/1ms
`include "src/alu/fulladder.v"

module fulladder_tb();

reg x,y,cin;
wire cout,sum;

fulladder my_fulladder(x,y,cin,cout,sum);

initial begin
    $display("Fulladder testbench");
    $monitor("x=%b, y=%b, cin=%b, cout=%b, sum=%b",x,y,cin,cout,sum);
    x=0;y=0;cin=0;#10;
    x=0;y=1;cin=0;#10;
    x=1;y=0;cin=1;#10;
    x=1;y=1;cin=1;#10;
end

endmodule
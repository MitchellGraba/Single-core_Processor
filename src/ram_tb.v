`include "src/ram.v"

module ram_tb();

reg clk,write_enable;
reg [31:0] addr_in,data_in;
wire [31:0] data_out;

ram uut(
    .clk(clk),
    .addr_in(addr_in),
    .data_in(data_in),
    .write_enable(write_enable),
    .data_out(data_out)
);

initial begin
    // put 4 at location 7
    addr_in = 7;data_in=4;write_enable=1;
    clk=0;#1;clk=1;#1;
    write_enable=0;
    clk=0;#1;clk=1;#1;
    // read location 7
    $display("data out is %d",data_out);
    // put 5 at location 27
    addr_in=27; data_in=5;write_enable=1;
    clk=0;#1;clk=1;#1;
    write_enable=0;
    clk=0;#1;clk=1;#1;
    // read location 27
    $display("data out is %d",data_out);
    addr_in=7;
    clk=0;#1;clk=1;#1;
    // read location 7 again
    $display("data out is %d",data_out);
end

endmodule
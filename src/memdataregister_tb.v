`timescale 1ms/1ms
`include "src/memdataregister.v"

module memdataregister_tb();

wire [31:0] Q;
reg clk,reset,Read,MDRin,MDRout;
reg [31:0] Mdata;
wire [31:0] bus;

memdataregister uut(reset,clk,MDRin,MDRout,bus,bus,Mdata,Read);

initial begin
	$monitor("MDRin=%b, MDRout=%b, Mdata=%d | bus=%d",MDRin,MDRout,Mdata,bus);
	clk=0;reset=0;MDRin=0;MDRout=0;Mdata=23;Read=0;

    $display("read data in");
    MDRin=1;Read=1;
	clk=1; #10;clk=0;#10;
    
    $display("dont read data in");
    MDRin=0;Read=1;Mdata=35;
    clk=1;#10;clk=0;#10;

    $display("display final data");
    MDRout=1;
    clk=1;#10;clk=0;#10;
    
	$finish;
end

endmodule

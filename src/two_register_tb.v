`include "src/register.v"

module two_register_tb();

reg clk,reset;
reg Ain,Aout,Bin,Bout;
wire [31:0] bus;

reg const_en;
reg [31:0] const;

register A(reset,clk,Ain,Aout,const_en?const:bus,bus);
register B(reset,clk,Bin,Bout,const_en?const:bus,bus);

initial begin
    $monitor("A=%d, B=%d, bus=%d",Aout,Bout,bus);
    reset=0;
    Ain=0;Aout=0;Bin=0;Bout=0;
    // write 50 straight to A
    Ain=1;const_en=1;const=50;
    clk=0;#10;clk=1;#10;
    // move A->B
    Aout=1;const_en=0;Bin=1;
    clk=0;#10;clk=1;#10;
    // display B
    Aout=0;Bout=1;Bin=0;
    clk=0;#10;clk=1;#10;
    // write 70 t A
    Bout=0;Ain=1;const_en=1;const=70;
    clk=0;#10;clk=1;#10;
    // display A (should be 70)
    Ain=0;const_en=0;Aout=1;
    clk=0;#10;clk=1;#10;
    // display B (should be 50)
    Aout=0;Bout=1;
    clk=0;#10;clk=1;#10;

end

endmodule
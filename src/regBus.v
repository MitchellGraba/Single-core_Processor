`include "src/register.v"
`include "src/register64.v"
`include "src/memdataregister.v"

module regBus(
    input clk,reset,
    
    input PCout,MARin,IncPC,Zin,
    input Zlowout,PCin,Read,
    input [31:0] Mdatain,
    input MDRin,MDRout,IRin,
    input R2out,Yin,
    input R4out,
    input R5in,
    

    output wire [31:0] bus
);

register PC(reset,clk,PCin,PCout,bus,bus);
register IR(reset,clk,IRin,1'b0,bus,bus);
register MAR(reset,clk,MARin,MARout,bus,bus);
memdataregister MDR(reset,clk, MDRin, MDRout, bus, bus, Mdatain, Read);

register64 Z(reset,clk,Zin,Zlowout,1'b0,bus,bus);


register Y(reset,clk,Yin,Yout,bus,bus);
register reg2(reset,clk,R2in,R2out,bus,bus);
register reg4(reset,clk,R4in,R4out,bus,bus);
register reg5(reset,clk,R5in,R5out,bus,bus);

endmodule
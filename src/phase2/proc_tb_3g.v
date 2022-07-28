`include "src/proc.v"

module proc_tb();

reg clk;
wire [31:0] OutPort;
reg [31:0] InPort = 37;
reg InStrobe = 1;


wire [31:0] r0 = uut.r_direct[0];
wire [31:0] r1 = uut.r_direct[1];
wire [31:0] r2 = uut.r_direct[2];
wire [31:0] PC = uut.PC.data;
wire [31:0] IR = uut.IR.data;
wire [31:0] MAR = uut.MAR.data;
wire [31:0] MDR = uut.MDR.my_register.data;


proc uut(
    .clk(clk),
    .OutPort(OutPort),
    .InPort(InPort),
    .InStrobe(InStrobe)
);

initial begin   
    clk = 0;  
    forever #50 clk = ~clk;  
end

wire signed [17:0] immediate = 35;
wire signed [31:0] signedbus = uut.bus;




initial begin
    // wait for other modules to initialize
    #2;
    // Setup address in register
    // give PC some non zero value
    uut.PC.data=7;
    // populate HI and LO
    uut.HI.data = 100;
    uut.LO.data = 10;
    // Instruction (opcode,ra,rb,rc, dontcare)
    uut.proc_ram.my_memory[7] = { 5'd2, 4'd2, 2'd0, 2'd0, 1'd0, immediate };
    uut.proc_ram.my_memory[8] = { 5'd2, 4'd2, 2'd0, 2'd0, 1'd0, immediate };

    $dumpfile("wave/3g.vcd");
    // general proc vars
    $dumpvars(1,
        uut.PCout,uut.MARin,uut.IncPC,uut.Zin,uut.Zlowout,uut.MDRout,uut.IRin,
        uut.Gra,uut.Grb,uut.Grc,
        uut.Read,uut.MDRin,
        uut.BAout,uut.Yin,uut.MARin,uut.bus,
        uut.Rin,uut.Rout,
        PC,IR,
        r0,r1,r2, OutPort, InPort 
    );


    $display("TEST FOR 3G (out R2)");
    // T0
    uut.PCout=1;uut.MARin=1;uut.IncPC=1;uut.Zin=1;
    #150;
    uut.PCout=0;uut.MARin=0;uut.IncPC=0;uut.Zin=0;
    // T1
    uut.Zlowout=1;uut.PCin=1;uut.Read=1;uut.MDRin=1;
    #150;

    uut.Zlowout=0;uut.PCin=0;uut.Read=0;uut.MDRin=0;
    // T2
    uut.MDRout=1;uut.IRin=1;
    #150;
    $display("Putting %b from MDR to IR",uut.bus);
    uut.MDRout=0;uut.IRin=0;
    // T3
    uut.Gra=1;uut.Rout=1;uut.OUTin=1;
    #100;
    $display("seeing %d on output port",OutPort);
    uut.Gra=0;uut.Rout=0;uut.OUTin=0;

    $display("TEST FOR 3G (in R2)");
    // T0
    uut.PCout=1;uut.MARin=1;uut.IncPC=1;uut.Zin=1;
    #150;
    uut.PCout=0;uut.MARin=0;uut.IncPC=0;uut.Zin=0;
    // T1
    uut.Zlowout=1;uut.PCin=1;uut.Read=1;uut.MDRin=1;
    #150;

    uut.Zlowout=0;uut.PCin=0;uut.Read=0;uut.MDRin=0;
    // T2
    uut.MDRout=1;uut.IRin=1;
    #150;
    $display("Putting %b from MDR to IR",uut.bus);
    uut.MDRout=0;uut.IRin=0;
    // T3
    uut.Gra=1;uut.Rin=1;uut.INout=1;
    #100;
    $display("reading %d on Input Port",uut.bus);
    uut.Gra=0;uut.Rin=0;uut.INout=0;

    $finish;
end

endmodule
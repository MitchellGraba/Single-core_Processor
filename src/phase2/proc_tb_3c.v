`include "src/proc.v"

module proc_tb();

reg clk;

proc uut(
    .clk(clk)
);

initial begin   
    clk = 0;  
    forever #50 clk = ~clk;  
end

wire signed [17:0] immediate = -5;
wire signed [31:0] signedbus = uut.bus;

wire [31:0] r0 = uut.r_direct[0];
wire [31:0] r1 = uut.r_direct[1];
wire [31:0] r2 = uut.r_direct[2];
wire [31:0] PC = uut.PC.data;
wire [31:0] IR = uut.IR.data;
wire [31:0] MAR = uut.MAR.data;
wire [31:0] MDR = uut.MDR.my_register.data;

initial begin
    // wait for other modules to initialize
    #2;
    // Setup address in register
    // give PC some non zero value
    uut.PC.data=7;
    // Instruction (opcode,ra,rb,rc, dontcare)
    uut.proc_ram.my_memory[7] = { 5'd2, 4'd2, 4'd1, 1'd0, immediate };
    uut.proc_ram.my_memory[8] = { 5'd2, 4'd2, 4'd1, 1'd0, 18'd26 };
    uut.proc_ram.my_memory[9] = { 5'd2, 4'd2, 4'd1, 1'd0, 18'd26 };

    $dumpfile("wave/3c.vcd");
    // general proc vars
    $dumpvars(1,
        uut.PCout,uut.MARin,uut.IncPC,uut.Zin,uut.Zlowout,uut.MDRout,uut.IRin,
        uut.Gra,uut.Grb,uut.Grc,
        uut.Read,uut.MDRin,
        uut.BAout,uut.Yin,uut.MARin,uut.bus,
        uut.Rin,uut.Rout,
        PC,IR,
        r0,r1,r2
    );
     $dumpvars(1,
        uut.Cout,
        uut.ADD,
        uut.AND,
        uut.OR,
        MAR,
        MDR
    );
    
    $display("TEST FOR 3C (addi R2,R1,-5)");
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
    uut.Grb=1;uut.Rout=1;uut.Yin=1;
    #300;
    $display("value from register is %d",signedbus);
    $display("selecting register %d",uut.select_and_encoder.rnum);
    uut.Grb=0;uut.Rout=0;uut.Yin=0;
    // T4
    uut.Cout=1;uut.ADD=1;uut.Zin=1;
    #300;
    $display("immediate sign extended is %d",signedbus);
    uut.Cout=0;uut.ADD=0;uut.Zin=0;
    // T5
    uut.Zlowout=1;uut.Gra=1;uut.Rin=1;
    #300;
    $display("writing %d into R1",signedbus);
    uut.Zlowout=0;uut.Gra=0;uut.Rin=0;
    $display();

    $display("TEST FOR 3C (andi R2,R1,26)");
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
    uut.Grb=1;uut.Rout=1;uut.Yin=1;
    #300;
    $display("value from register is %d",signedbus);
    $display("selecting register %d",uut.select_and_encoder.rnum);
    uut.Grb=0;uut.Rout=0;uut.Yin=0;
    // T4
    uut.Cout=1;uut.AND=1;uut.Zin=1;
    #300;
    $display("immediate sign extended is %d",signedbus);
    uut.Cout=0;uut.AND=0;uut.Zin=0;
    // T5
    uut.Zlowout=1;uut.Gra=1;uut.Rin=1;
    #300;
    $display("writing %d into R1",signedbus);
    uut.Zlowout=0;uut.Gra=0;uut.Rin=0;
    $display();

    $display("TEST FOR 3C (ori R2,R1,26)");
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
    uut.Grb=1;uut.Rout=1;uut.Yin=1;
    #300;
    $display("value from register is %d",signedbus);
    $display("selecting register %d",uut.select_and_encoder.rnum);
    uut.Grb=0;uut.Rout=0;uut.Yin=0;
    // T4
    uut.Cout=1;uut.OR=1;uut.Zin=1;
    #300;
    $display("immediate sign extended is %d",signedbus);
    uut.Cout=0;uut.OR=0;uut.Zin=0;
    // T5
    uut.Zlowout=1;uut.Gra=1;uut.Rin=1;
    #300;
    $display("writing %d into R1",signedbus);
    uut.Zlowout=0;uut.Gra=0;uut.Rin=0;
    $display();

    $finish;
end

endmodule
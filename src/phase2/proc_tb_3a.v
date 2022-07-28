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

wire [31:0] r0 = uut.r_direct[0];
wire [31:0] r1 = uut.r_direct[1];
wire [31:0] r2 = uut.r_direct[2];
wire [31:0] PC = uut.PC.data;
wire [31:0] IR = uut.IR.data;
wire [31:0] MAR = uut.MAR.data;
wire [31:0] MDR = uut.MDR.my_register.data;

initial begin
    // wait for other modules to initialize
    #1;
    // Setup address in register
    //uut.immediate_enable = 1;uut.immediate_data = 40;
    // give PC some non zero value
    uut.PC.data=7;
    // Instruction (opcode,ra,rb,rc, dontcare)
    uut.proc_ram.my_memory[7] = { 5'd0, 4'd1, 4'd0, 4'd0, 15'd85 };
    uut.proc_ram.my_memory[8] = { 5'd0, 4'd2, 4'd1, 4'd0, 15'd35 };
    uut.proc_ram.my_memory[9] = { 5'd0, 4'd1, 4'd0, 4'd0, 15'd85 };
    uut.proc_ram.my_memory[10] = { 5'd0, 4'd2, 4'd1, 4'd0, 15'd35 };
    // Data to load
    // register has default val 103 + offset of 10 from immediae
    uut.proc_ram.my_memory[461] = 53;
    // 461 just based on whatever R1 is + 35
    uut.proc_ram.my_memory[426] = 35;
    
    $dumpfile("wave/3a.vcd");
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
    // vars for 3a specifically
    $dumpvars(1,
        uut.Cout,
        uut.ADD,
        MAR,
        MDR
    );

    $display("%b",uut.r_direct[0]);
    
    $display("TEST FOR 3A (ld R1,$85)");
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
    uut.Grb=1;uut.BAout=1;uut.Yin=1;
    #150;
    $display("using register %d",uut.select_and_encoder.rnum);
    $display("select vec is %b",uut.r_out_vec);
    $display("value %d is going in Y",uut.bus);
    uut.Grb=0;uut.BAout=0;uut.Yin=0;
    // T4
    uut.Cout=1;uut.ADD=1;uut.Zin=1;
    #150;
    $display("immediate offset is %d",uut.bus);
    uut.Cout=0;uut.ADD=0;uut.Zin=0;
    // T5
    uut.Zlowout=1;uut.MARin=1;
    #150;
    $display("Memory address for load: %d",uut.bus);
    uut.Zlowout=0;uut.MARin=0;
    // T6
    uut.Read=1;uut.MDRin=1;
    #150;
    $display("Reading %d from memory",uut.MDR_direct);
    uut.Read=0;uut.MDRin=0;
    // T7
    uut.MDRout=1;uut.Gra=1;uut.Rin=1;
    #150;
    uut.MDRout=0;uut.Gra=0;uut.Rin=0;
    #150;
    uut.Rout=1;uut.Gra=1;
    #150;
    $display("loaded value %d from memory into register 3",uut.bus);
    uut.Rout=0;uut.Gra=0;
    $display();

    $display("TEST FOR 3A (ld r2,$35(R1)");
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
    uut.Grb=1;uut.BAout=1;uut.Yin=1;
    #150;
    $display("using register %d",uut.select_and_encoder.rnum);
    $display("select vec is %b",uut.r_out_vec);
    $display("value %d is going in Y",uut.bus);
    uut.Grb=0;uut.BAout=0;uut.Yin=0;
    // T4
    uut.Cout=1;uut.ADD=1;uut.Zin=1;
    #150;
    $display("immediate offset is %d",uut.bus);
    uut.Cout=0;uut.ADD=0;uut.Zin=0;
    // T5
    uut.Zlowout=1;uut.MARin=1;
    #150;
    $display("Memory address for load: %d",uut.bus);
    uut.Zlowout=0;uut.MARin=0;
    // T6
    uut.Read=1;uut.MDRin=1;
    #150;
    $display("Reading %d from memory",uut.MDR_direct);
    uut.Read=0;uut.MDRin=0;
    // T7
    uut.MDRout=1;uut.Gra=1;uut.Rin=1;
    #150;
    uut.MDRout=0;uut.Gra=0;uut.Rin=0;
    #150;
    uut.Rout=1;uut.Gra=1;
    #150;
    $display("loaded value %d from memory into register 3",uut.bus);
    uut.Rout=0;uut.Gra=0;
    $display();

    $display("TEST FOR 3A (ldi r1,$85)");

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
    uut.Grb=1;uut.BAout=1;uut.Yin=1;
    #150;
    uut.Grb=0;uut.BAout=0;uut.Yin=0;
    // T4
    uut.Cout=1;uut.ADD=1;uut.Zin=1;
    #150;
    uut.Cout=0;uut.ADD=0;uut.Zin=0;

    // T5
    uut.Zlowout=1;uut.Gra=1;uut.Rin=1;
    #150;
    $display("writing %d into register",uut.bus);
    uut.Zlowout=0;uut.Gra=0;uut.Rin=0;

    #150;
    uut.Rout=1;uut.Gra=1;
    #150;
    $display("loaded value %d from immediate into register 3",uut.bus);
    uut.Rout=0;uut.Gra=0;
    $display();

    $display("TEST FOR 3A (ldi r2,$35(R1))");

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
    uut.Grb=1;uut.BAout=1;uut.Yin=1;
    #150;
    uut.Grb=0;uut.BAout=0;uut.Yin=0;
    // T4
    uut.Cout=1;uut.ADD=1;uut.Zin=1;
    #150;
    uut.Cout=0;uut.ADD=0;uut.Zin=0;

    // T5
    uut.Zlowout=1;uut.Gra=1;uut.Rin=1;
    #150;
    $display("writing %d into register",uut.bus);
    uut.Zlowout=0;uut.Gra=0;uut.Rin=0;

    #150;
    uut.Rout=1;uut.Gra=1;
    #150;
    $display("loaded value %d from immediate into register 3",uut.bus);
    uut.Rout=0;uut.Gra=0;

    $finish;
end

endmodule
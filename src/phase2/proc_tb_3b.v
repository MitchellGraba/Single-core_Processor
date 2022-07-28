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
    #2;
    // Setup address in register
    // give PC some non zero value
    uut.PC.data=7;
    // Instruction (opcode,ra,rb,rc, dontcare)
    uut.proc_ram.my_memory[7] = { 5'd2, 4'd1, 4'd0, 4'd0, 15'd90 };
    uut.proc_ram.my_memory[8] = { 5'd2, 4'd1, 4'd1, 4'd0, 15'd90 };

    $dumpfile("wave/3b.vcd");
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
    
    $display("TEST FOR 3B (st $90,R1)");
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
    $display("using register for offset %d",uut.select_and_encoder.rnum);
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
    $display("Memory address for store: %d",uut.bus);
    uut.Zlowout=0;uut.MARin=0;
    // T6
    uut.Write=1;uut.Gra=1;uut.Rout=1;uut.MDRin=1;
    #150;
    $display("Writing %d to memory",uut.bus);
    uut.Write=0;uut.Gra=0;uut.Rout=0;uut.MDRin=0;
    $display();

    $display("mem value at 90 is %d",uut.proc_ram.my_memory[90]);
    $display();

    $display("TEST FOR 3B (st $90(R1),R1)");
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
    $display("using register for offset %d",uut.select_and_encoder.rnum);
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
    $display("Memory address for store: %d",uut.bus);
    uut.Zlowout=0;uut.MARin=0;

    // T6
    uut.Write=1;uut.Gra=1;uut.Rout=1;uut.MDRin=1;
    #250;
    $display("Writing %d to memory",uut.bus);
    uut.Write=0;uut.Gra=0;uut.Rout=0;uut.MDRin=0;
    $display();

    $display("mem value at 191 is %d",uut.proc_ram.my_memory[191]);

    $finish;
end

endmodule
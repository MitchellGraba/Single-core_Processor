`include "src/proc3.v"

module control_unit_tb();

reg clk;

proc uut(
    .clk(clk)
);

initial begin  
    #100;
    clk = 0;  
    $display("Starting up processor");
    forever #50 clk = ~clk;  
end

initial begin
    #1;
    $display("Initializing memory");
    $display("LOAD");
    // ld into r1 from offset 85
    uut.proc_ram.my_memory[0] = { 5'd0, 4'd1, 4'd0, 4'd0, 15'd85};
    // halt (in a bunch of locations to cover branch tests
    uut.proc_ram.my_memory[1] = {5'd26, 4'd0, 4'd0, 4'd0, 15'd0};
    uut.proc_ram.my_memory[36] = {5'd26, 4'd0, 4'd0, 4'd0, 15'd0};
    uut.proc_ram.my_memory[102] = {5'd26, 4'd0, 4'd0, 4'd0, 15'd0};
    #10000;
    $display("ld into r1 from offset 85");
    $display("expected: 426");
    $display("r1 is %d",uut.r_direct[1]);
    $display();

    $display("LOAD IMMEDIATE");
    // ldi into r1 from r2+30
    uut.proc_ram.my_memory[0] = { 5'd1, 4'd1, 4'd2, 4'd0, 15'd30};
    // reset PC back
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #10000;
    // expected: 132
    $display("ldi into r1 from r2+30");
    $display("expected: 132");
    $display("r1 is %d",uut.r_direct[1]);
    $display();

    $display("STORE");
    // st
    uut.proc_ram.my_memory[0] = { 5'd2, 4'd1,4'd0,4'd0,15'd90};
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #10000;
    $display("st r1 into 90");
    $display("expected: 132");
    $display("mem 90 is %d",uut.proc_ram.my_memory[90]);
    $display();

    $display("ADD");
    // ADD
    uut.proc_ram.my_memory[0] = { 5'd3, 4'd1,4'd2,4'd3,15'd00};
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #10000;
    $display("add r2 and r3 into r1");
    $display("expected: 205");
    $display("r1 is %d",uut.r_direct[1]);
    $display();

    $display("ADDI");
    // ADDI
    uut.proc_ram.my_memory[0] = { 5'd11, 4'd1,4'd2,4'd0,15'd10};
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #10000;
    $display("add r2 + 10 into r1");
    $display("expected: 112");
    $display("r1 is %d",uut.r_direct[1]);
    $display();

    $display("MUL");
    // MUL
    uut.proc_ram.my_memory[0] = { 5'd14, 4'd2,4'd3,4'd0,15'd00};
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #100000;
    $display("mul r2 by r3");
    $display("expected: 10506");
    $display("LO is %d",uut.LO.data);
    $display();

    $display("BRANCH");
    uut.proc_ram.my_memory[0] = { 5'd18, 4'd1, 2'b00, 2'b01, 1'd0, 18'd35 };
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #100000;
    $display("branch +35 if r1!=0");
    $display("expected: PC=36");
    $display("PC is %d",uut.PC.data);
    $display();

    $display("NEG");
    uut.proc_ram.my_memory[0] = { 5'd17, 4'd1, 4'd2, 4'd0,15'd00 };
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #100000;
    $display("NEG r2 into r1");
    $display("expected: 4294967193");
    $display("R1 is %d",uut.r_direct[1]);
    $display();

    $display("JR");
    uut.proc_ram.my_memory[0] = { 5'd19, 4'd2, 4'd0, 4'd0,15'd00 };
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #100000;
    $display("JAR r2");
    $display("expected: PC=102");
    $display("PC is %d",uut.PC.data);
    $display("R15 is %d",uut.r_direct[15]);
    $display();

    $display("JAL");
    uut.proc_ram.my_memory[0] = { 5'd20, 4'd2, 4'd0, 4'd0,15'd00 };
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #100000;
    $display("JAL r2");
    $display("expected: PC=102 (displays as 103 because gets halfway through halt instruction)");
    $display("PC is %d",uut.PC.data);
    $display("R15 is %d",uut.r_direct[15]);
    $display();

    $display("MFLO");
    uut.proc_ram.my_memory[0] = { 5'd24, 4'd1, 4'd0, 4'd0,15'd00 };
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #100000;
    $display("MFLO r1");
    $display("expected: PC=10506");
    $display("R1 is %d",uut.r_direct[1]);
    $display();

    $display("NOP");
    uut.proc_ram.my_memory[0] = { 5'd25, 4'd1, 4'd0, 4'd0,15'd00 };
    uut.PC.data = 0;
    uut.T=0;
    uut.i=0;
    #100000;
    $display("NOP");
    $display();

    $finish;
end

endmodule
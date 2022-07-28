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
    // wait for ram to set defulat values before overriding
    // tproc_hese come from the instructions in phase3_inst.txt
    // ORG 0
    uut.proc_ram.my_memory[0 ] = 159383687;
    uut.proc_ram.my_memory[1 ] = 160956417;
    uut.proc_ram.my_memory[2 ] = 16777333;
    uut.proc_ram.my_memory[3 ] = 152567806;
    uut.proc_ram.my_memory[4 ] = 9437188;
    uut.proc_ram.my_memory[5 ] = 134217729;
    uut.proc_ram.my_memory[6 ] = 159383667;
    uut.proc_ram.my_memory[7 ] = 2442657795;
    uut.proc_ram.my_memory[8 ] = 160956421;
    uut.proc_ram.my_memory[9 ] = 60817405;
    uut.proc_ram.my_memory[10] =  3355443200;
    uut.proc_ram.my_memory[11] =  2475687938;
    uut.proc_ram.my_memory[12] =  168296454;
    uut.proc_ram.my_memory[13] =  161480706;
    uut.proc_ram.my_memory[14] =  428965888;
    uut.proc_ram.my_memory[15] =  1538785283;
    uut.proc_ram.my_memory[16] =  2209873920;
    uut.proc_ram.my_memory[17] =  2344091648;
    uut.proc_ram.my_memory[18] =  1673003023;
    uut.proc_ram.my_memory[19] =  1804075011;
    uut.proc_ram.my_memory[20] =  689438720;
    uut.proc_ram.my_memory[21] =  285212760;
    uut.proc_ram.my_memory[22] =  948436992;
    uut.proc_ram.my_memory[23] =  1091567616;
    uut.proc_ram.my_memory[24] =  1360527360;
    uut.proc_ram.my_memory[25] =  1217429504;
    uut.proc_ram.my_memory[26] =  285737063;
    uut.proc_ram.my_memory[27] =  563183616;
    uut.proc_ram.my_memory[28] =  814743552;
    uut.proc_ram.my_memory[29] =  167772165;
    uut.proc_ram.my_memory[30] =  176160797;
    uut.proc_ram.my_memory[31] =  1923088384;
    uut.proc_ram.my_memory[32] =  3145728000;
    uut.proc_ram.my_memory[33] =  3271557120;
    uut.proc_ram.my_memory[34] =  2057306112;
    uut.proc_ram.my_memory[35] =  220200960;
    uut.proc_ram.my_memory[36] =  229113858;
    uut.proc_ram.my_memory[37] =  238026752;
    uut.proc_ram.my_memory[38] =  246939648;
    uut.proc_ram.my_memory[39] =  2785017856;
    uut.proc_ram.my_memory[40] =  3489660928;
    

    // ORG $91
    uut.proc_ram.my_memory[145] = 483786752;
    uut.proc_ram.my_memory[146] = 610172928;
    uut.proc_ram.my_memory[147] = 617349120;
    uut.proc_ram.my_memory[148] = 2675965952;

    // memory values as specified
    uut.proc_ram.my_memory['h75] = 'h56;
    uut.proc_ram.my_memory['h58] = 'h34;

    // leave processor to do its thing
    #10000000;

    $display("Total cycles: %d",uut.total_cycles);
    $display("Total instructions: %d",uut.total_instructions);

    $finish;
end

endmodule
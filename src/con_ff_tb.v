`include "src/con_ff.v"

module con_ff_tb();

reg [31:0] IR;
reg signed [31:0] bus;
wire do_branch;

con_ff uut(
    .IR(IR),
    .bus(bus),
    .do_branch(do_branch)
);

initial begin
    bus = 0;
    IR = 0;
    #1;
    $monitor("IR[22:19]=%d, bus=%d | do_branch=%b",IR[22:19],bus,do_branch);

    IR[22:19] = 0;
    $display("Testing eq 0");
    bus = 0;#1;
    bus = 7;#1;

    IR[22:19] = 1;
    $display("Testing neq 0");
    bus = 0;#1;
    bus = 7;#1;

    IR[22:19] = 2;
    $display("Testing gtr 0");
    bus = 4;#1;
    bus = -4;#1;

    IR[22:19] = 3;
    $display("Testing less 0");
    bus = 4;#1;
    bus = -4;#1;

end

endmodule
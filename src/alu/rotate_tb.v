`include "src/alu/rotateright.v"
`include "src/alu/rotateleft.v"

module rotate_tb();

reg [31:0] A = 1;
reg [5:0] B = 3;
reg clock = 0;
reg start = 0;
wire [31:0] C_Left,C_Right;

rotateright uut_right(A,B,clock,start,C_Right);
rotateleft uut_left(A,B,clock,start,C_Left);

initial begin   
    clock = 0;  
    forever #50 clock = ~clock;  
end 

initial begin
    $display("setting A=1");
    $monitor("A=%b, B=%d | C_Right=%b, C_Left=%b",A,B,C_Right,C_Left);
    start=1;
    #100;
    start=0;
    #1000;
    $display("setting A=2^31");
    A = 2**31;
    start=1;
    #100;
    start=0;
    #1000;
    $finish;
end

endmodule
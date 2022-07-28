`include "src/alu/shiftright.v"
`include "src/alu/shiftleft.v"

module shift_tb();

reg [31:0] A = 1024+2048;
reg [5:0] B = 3;
reg clock = 0;
reg start = 0;
wire [31:0] C_Left,C_Right;

shiftright uut_right(A,B,clock,start,C_Right);
shiftleft uut_left(A,B,clock,start,C_Left);

initial begin   
    clock = 0;  
    forever #50 clock = ~clock;  
end 

initial begin
    $monitor("A=%d, B=%d | C_Right=%d, C_Left=%d",A,B,C_Right,C_Left);
    start=1;
    #100;
    start=0;
    #1000;
    $finish;
end

endmodule
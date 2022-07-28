`include "src/alu/alu.v"

module alu_tb();

reg signed [31:0] A,B;
reg clk,start;
wire signed [63:0] C;
wire signed [31:0] C32 = C[31:0];
wire signed [31:0] C32_Upper = C[63:32];
reg ADD,AND,OR,MUL,SUB,DIV,NEG,NOT,SHR,SHL,ROR,ROL;

alu uut(
    .A(A),.B(B),
    .clk(clk),
    .start(start),
    .C(C),
    .ADD(ADD),
    .AND(AND),
    .OR(OR),
    .MUL(MUL),
    .SUB(SUB),
    .DIV(DIV),
    .NEG(NEG),
    .NOT(NOT),
    .SHR(SHR),
    .SHL(SHL),
    .ROR(ROR),
    .ROL(ROL)
);

initial begin   
    clk = 0;  
    forever #50 clk = ~clk;  
end

initial begin
    $display("ALU testbench");
    $monitor("A=%d,B=%d | C_Full=%d; C_Lower=%d; C_Upper=%d",A,B,C,C32,C32_Upper);
    $display("Testing AND");
    start=0;
    OR=0;ADD=0;AND=0;MUL=0;SUB=0;DIV=0;NEG=0;NOT=0;SHL=0;SHR=0;ROR=0;ROL=0;
    A=5;B=2;
    AND=1;
    #100;

    $display("Testing ADD");
    ADD=1;AND=0;
    #100;

    $display("Testing OR");
    ADD=0;OR=1;
    #100;

    $display("Testing MUL");
    OR=0;MUL=1;start=1;#100;start=0;
    #10000;

    $display("Testing SUB");
    MUL=0;SUB=1;#100;

    $display("Testing DIV");
    SUB=0;DIV=1;#10000;

    $display("Testing NOT");
    DIV=0;NOT=1;#10000;

    A=0;#100;
    A=5;#100;

    $display("Testing NEG");
    NOT=0;
    NEG=1;#100;
    A=0;#100;
    NEG=0;

    $display("Testing SHR");
    SHR=1;start=1;#100;start=0;#1000;SHR=0;
    $display("Testing SHL");
    SHL=1;start=1;#100;start=0;#1000;SHL=0;
    $display("Testing ROR");
    ROR=1;start=1;#100;start=0;#1000;ROR=0;
    $display("Testing ROL");
    ROL=1;start=1;#100;start=0;#1000;ROL=0;

    $finish;
end

endmodule
`include "src/register.v"
`include "src/alu/alu.v"
`include "src/memdataregister.v"
`include "src/register64.v"
`include "src/tristatebuffer.v"
`include "src/decode/selectAndEncodeOverall.v"
`include "src/ram.v"
`include "src/con_ff.v"

module proc(
    input wire clk,
    output wire [31:0] OutPort,
    input wire [31:0] InPort,
    input wire InStrobe
);

reg reset = 0;

reg Gra=0,Grb=0,Grc=0;
reg BAout=0,Cout=0;
reg Rin=0,Rout=0;
reg Yin=0,Yout=0;
reg Zlowout=0,Zhighout=0;
reg PCin=0,PCout=0;
reg Zin=0;
reg MDRin=0,MDRout=0;
reg IRin=0;
reg LOin=0,LOout=0;
reg HIin=0,HIout=0;
reg Write=0,Read=0;
reg ADD=0,SUB=0,MUL=0,DIV=0,SHR=0,SHL=0,ROR=0,ROL=0,AND=0,OR=0,NEG=0,NOT=0,IncPC=0;
reg [31:0] immediate_data = 0;
reg immediate_enable = 0;
reg MARin=0,MARout=0;
reg CONin=0;
reg OUTin=0;
reg INout=0;

wire [31:0] Mdatain;
wire [31:0] bus;

wire [31:0] OUT_direct;
register OUT(reset,clk,OUTin,1'b1,bus,OUT_direct);
assign OutPort = OUT_direct;

register IN(reset,clk,InStrobe,INout,InPort,bus);

wire [31:0] CON_direct;
register CON(reset,clk,CONin,1'b1,bus,CON_direct);

reg Branch=0;
wire do_branch;

reg start = 0;

tristatebuffer immediate_buff(immediate_enable,immediate_data,bus);
register PC(reset,clk,PCin|(Branch&do_branch),PCout,bus,bus);
wire [31:0] IR_direct;
register IR(reset,clk,IRin,1'b1,bus,IR_direct);
wire [31:0] MAR_direct;
register MAR(reset,clk,MARin,1'b1,bus,MAR_direct);


con_ff proc_con_ff(
    .IR(IR_direct),
    .bus(CON_direct),
    .do_branch(do_branch)
);
wire [31:0] MDR_direct;
memdataregister MDR(reset,clk, MDRin, 1'b1, bus, MDR_direct, Mdatain, Read);
tristatebuffer MDR_buff(MDRout,MDR_direct,bus);

wire [63:0] ALU_Z;

register64 Z(reset,clk,Zin,Zlowout,Zhighout,ALU_Z,bus);

wire [31:0] RY_Q;
register Y(reset,clk,Yin,1'b1,bus,RY_Q);
register LO(reset,clk,LOin,LOout,bus,bus);
register HI(reset,clk,HIin,HIout,bus,bus);

tristatebuffer Cout_buff(Cout,{ {14{IR_direct[17]}},IR_direct[17:0]},bus);

wire [15:0] r_out_vec;
wire [15:0] r_in_vec;

wire [32:0] r_direct [15:0];

genvar index;
generate
    for (index=0;index<16;index = index+1) begin : r_programmable
        register reg_gen(reset,clk,r_in_vec[index],r_out_vec[index],bus,bus);
        initial begin 
            #1;reg_gen.data = index==0 ? 0 : 100+index;
        end
        assign r_direct[index] = reg_gen.data;
    end
endgenerate

alu alu(
    .A(RY_Q),
    .B(bus),
    .C(ALU_Z),

    .ADD(ADD),
    .SUB(SUB),
    .MUL(MUL),
    .DIV(DIV),
    .SHR(SHR),
    .SHL(SHL),
    .ROR(ROR),
    .ROL(ROL),
    .AND(AND),
    .OR(OR),
    .NEG(NEG),
    .NOT(NOT),

    .INC(IncPC),

    .clk(clk),
    .start(start)
);

selectAndEncodeOverall select_and_encoder(
    .Gra(Gra),
    .Grb(Grb),
    .Grc(Grc),
    .IR(IR_direct),
    .r_in_vec(r_in_vec),
    .r_out_vec(r_out_vec),
    .r_in_enable(Rin),
    .r_out_enable(Rout),
    .BA_out(BAout)
);

ram proc_ram(
    .clk(clk),
    .addr_in(MAR_direct),
    .data_in(MDR_direct),
    .write_enable(Write),
    .data_out(Mdatain)
);

// reg [31:0] T=0;

// always @(posedge clk) begin
//     if (T==0) begin
//         PCout=1;MARin=1;IncPC=1;Zin=1;
//     end
//     if (T==1) begin
//         Zlowout=1;PCin=1;Read=1;
//     end
//     if (T==2) begin
//         MDRout=1;IRin=1;
//     end

// end

endmodule
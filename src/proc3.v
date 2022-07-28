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

reg [15:0] select_vec_override = 0;
selectAndEncodeOverall select_and_encoder(
    .Gra(Gra),
    .Grb(Grb),
    .Grc(Grc),
    .IR(IR_direct),
    .r_in_vec(r_in_vec),
    .r_out_vec(r_out_vec),
    .r_in_enable(Rin),
    .r_out_enable(Rout),
    .BA_out(BAout),
    .select_vec_override(select_vec_override)
);

ram proc_ram(
    .clk(clk),
    .addr_in(MAR_direct),
    .data_in(MDR_direct),
    .write_enable(Write),
    .data_out(Mdatain)
);

reg [31:0] T=0;
reg [31:0] i = 0;

wire [4:0] opcode = IR_direct[31:31-4];
reg [31:0] total_cycles = 0;
reg [31:0] total_instructions = 0;

always @(posedge clk) begin
    // all control signals 0 by default
    Gra=0;Grb=0;Grc=0;
    BAout=0;Cout=0;
    Rin=0;Rout=0;
    Yin=0;Yout=0;
    Zlowout=0;Zhighout=0;
    PCin=0;PCout=0;
    Zin=0;
    MDRin=0;MDRout=0;
    IRin=0;
    LOin=0;LOout=0;
    HIin=0;HIout=0;
    Write=0;Read=0;
    ADD=0;SUB=0;MUL=0;DIV=0;SHR=0;SHL=0;ROR=0;ROL=0;AND=0;OR=0;NEG=0;NOT=0;IncPC=0;
    MARin=0;MARout=0;
    CONin=0;
    OUTin=0;
    INout=0;
    start=0;
    Branch=0;
    immediate_enable=0;
    select_vec_override=0;

    if (T==0) begin
        PCout=1;MARin=1;IncPC=1;Zin=1;
        if (i==3) begin 

            // $display("MAR is %d",MAR_direct);
            T=1;i=-1; 
        end
    end
    else if (T==1) begin 
        PCin=1;Zlowout=1;Read=1;MDRin=1;
        if (i==3) begin
            // $display("PC is %d",PC.data);
            // $display("MDR is %d",MDR_direct);
             T=2;i=-1;
        end
    end
    else if (T==2) begin
        MDRout=1;IRin=1;
        if (i==3) begin
            T=3;i=-1; 
            $display(
                "IR=%b, PC(next)=%d, R0=%d, R1=%d, R2=%d, R3=%d, R4=%d, R5=%d, R6=%d, R7=%d, R10=%d, R11=%d, R12=%d, R13=%d, HI=%d, LO=%d",
                IR.data,PC.data,
                r_direct[0],
                r_direct[1],r_direct[2],r_direct[3],r_direct[4],r_direct[5],r_direct[6],r_direct[7],
                r_direct[10],r_direct[11],r_direct[12],r_direct[13],
                HI.data,LO.data
            );
            total_instructions = total_instructions + 1;

            // $display("IR is %d",IR.data);
        end
    end

    // IF for each instruction
    // ld
    else if (opcode==0) begin
        if (T==3) begin
            if (IR_direct[22:19]==0) begin
                immediate_enable=1;immediate_data=0;
            end
            else begin
                Grb=1;BAout=1;
            end
            Yin=1;
            if (i==3) begin 
                // $display("Reading %d as rb",bus);
                T=4;i=-1; 
            end
        end
        else if (T==4) begin
            Cout=1;ADD=1;Zin=1;
            if (i==10) begin 
                // $display("Reading %d as immediate",bus);
                T=5;i=-1; 
            end
        end
        else if (T==5) begin
            Zlowout=1;MARin=1;
            if (i==4) begin 
                // $display("MAR is %d",MAR.data);
                T=6;i=-1; 
            end
        end
        else if (T==6) begin
            Read=1;MDRin=1;
            if (i==10) begin T=7;i=-1; end
        end
        else if (T==7) begin
            MDRout=1;Gra=1;Rin=1;
            // rest back
            if (i==10) begin T=0;i=-1; end
        end
    end
    // ldi (just like ld without the last part)`
    else if (opcode==1) begin
        if (T==3) begin
            if (IR_direct[22:19]==0) begin
                immediate_enable=1;immediate_data=0;
            end
            else begin
                Grb=1;BAout=1;
            end
            Yin=1;
            if (i==3) begin 
                // $display("Reading %d as rb",bus);
                T=4;i=-1; 
            end
        end
        else if (T==4) begin
            Cout=1;ADD=1;Zin=1;
            if (i==10) begin 
                T=5;i=-1; 
            end
        end
        else if (T==5) begin
            Zlowout=1;Rin=1;Gra=1;
            if (i==4) begin 
                // $display("Writing %d back to register",bus);
                T=0;i=-1; 
            end
        end
    end
    // st
    else if (opcode==2) begin
        if (T==3) begin    
            Grb=1;BAout=1;Yin=1;
            if (i==3) begin
                T=4;i=-1;
            end
        end
        else if (T==4) begin
            Cout=1;ADD=1;Zin=1;
            if (i==3) begin
                T=5;i=-1;
            end
        end
        else if (T==5) begin
            Zlowout=1;MARin=1;
            if (i==3) begin
                T=6;i=-1;
            end
        end
        else if (T==6) begin
            Write=1;Gra=1;Rout=1;MDRin=1;
            if (i==3) begin
                T=0;i=-1;
            end 
        end
    end
    // ra,rb,rc ALU op
    else if (opcode>=3 && opcode<=10) begin
        if (T==3) begin
            Grb=1;Rout=1;Yin=1;
            if (i==3) begin
                T=4;i=-1;
            end
        end
        else if (T==4) begin
            if (i<=3) start=1;
            Grc=1;Rout=1;Zin=1;
            if (opcode==3) ADD=1;
            if (opcode==4) SUB=1;
            if (opcode==5) SHR=1;
            if (opcode==6) SHL=1;
            if (opcode==7) ROR=1;
            if (opcode==8) ROL=1;
            if (opcode==9) AND=1;
            if (opcode==10) OR=1;
            if (i==40) begin
                T=5;i=-1;
            end
        end
        else if (T==5) begin
            Zlowout=1;Gra=1;Rin=1;
            if (i==3) begin
                T=0;i=-1;
            end
        end
    end
    // immediate ALU op
    else if (opcode>=11 && opcode<=13) begin
        if (T==3) begin
            Grb=1;Rout=1;Yin=1;
            if (i==3) begin
                T=4;i=-1;
            end
        end
        else if (T==4) begin
            Cout=1;Zin=1;
            if (opcode==11) ADD=1;
            if (opcode==12) AND=1;
            if (opcode==13) OR=1;

            if (i==3) begin
                T=5;i=-1;
            end
        end
        else if (T==5) begin
            Zlowout=1;Gra=1;Rin=1;
            if (i==3) begin
                T=0;i=-1;
            end
        end
    end
    // HI LO alu op
    else if (opcode==14 || opcode==15) begin
        if (T==3) begin
            Gra=1;Rout=1;Yin=1;
            if (i==3) begin
                T=4;i=-1;
            end
        end
        else if (T==4) begin
            if (i<=3) start=1;

            Grb=1;Rout=1;Zin=1;
            if (opcode==14) MUL=1;
            if (opcode==15) DIV=1;
            if (i==40) begin
                T=5;i=-1;
            end
        end
        else if (T==5) begin
            Zlowout=1;LOin=1;
            if (i==3) begin
                T=6;i=-1;
            end 
        end
        else if (T==6) begin
            Zhighout=1;HIin=1;
            if (i==3) begin
                T=0;i=-1;
            end
        end
    end
    // NEG NOT
    else if (opcode==16 || opcode==17) begin
        if (T==3) begin
            Grb=1;Rout=1;Zin=1;
            if (opcode==16) NEG=1;
            if (opcode==17) NOT=1;

            if (i==3) begin
                T=4;i=-1;
            end
        end
        else if (T==4) begin
            Gra=1;Rin=1;Zlowout=1;
            if (i==3) begin
                T=0;i=-1;
            end
        end
    end
    // branch
    else if (opcode==18) begin
        if (T==3) begin
            Gra=1;Rout=1;CONin=1;
            if (i==3) begin
                T=4;i=-1;
            end
        end
        else if (T==4) begin
            PCout=1;Yin=1;
            if (i==3) begin
                T=5;i=-1;
            end
        end
        else if (T==5) begin
            Cout=1;ADD=1;Zin=1;
            if (i==3) begin
                T=6;i=-1;
            end
        end
        else if (T==6) begin
            Zlowout=1;Branch=1;
            if (i==3) begin
                T=0;i=-1;
            end
        end
    end
    // jr
    else if (opcode==19) begin
        if (T==3) begin
            PCin=1;Gra=1;Rout=1;
            if (i==3) begin
                T=0;i=-1;
            end 
        end
    end
    // jal
    else if (opcode==20) begin
        // store PC for next instruction in R15
        if (T==3) begin
            PCout=1;Rin=1;select_vec_override[15]=1;
            if (i==3) begin
                T=4;i=-1;
            end
        end
        else if (T==4) begin
            PCin=1;Gra=1;Rout=1;
            if (i==3) begin
                T=0;i=-1;
            end 
        end
    end
    // mfhi mflo
    else if (opcode==23 || opcode==24) begin
        if (T==3) begin
            if (opcode==23) HIout=1;
            if (opcode==24) LOout=1;
            Gra=1;Rin=1;
            if (i==3) begin
                $display("FINISHED MFHI OR MFLO");
                $display("value is %d",bus);
                T=0;i=-1;
            end
        end
    end
    // nop
    else if (opcode==25) begin
        if (i==3) begin
            T=0;i=-1;
        end
    end
    else if (opcode==26) begin
        T=100;
    end

    i = i + 1;
    if (T<100) total_cycles = total_cycles + 1;

end

endmodule
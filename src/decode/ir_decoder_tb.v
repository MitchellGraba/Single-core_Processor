`include "src/decode/ir_decoder.v"

module ir_decoder_tb();

reg [31:0] ir_val;
reg Gra,Grb,Grc;
wire [3:0] rnum;

ir_decoder uut(
    .ir_val(ir_val),
    .Gra(Gra),
    .Grb(Grb),
    .Grc(Grc),
    .rnum(rnum)
);

initial begin
    Gra=0;Grb=0;Grc=0;
    ir_val = 0;
    ir_val[26:23] = 5;
    ir_val[22:19] = 6;
    ir_val[18:15] = 7;
    
    Gra=1;
    #1;
    $display("rnum is %d",rnum);
    Gra=0;

    Grb=1;
    #1;
    $display("rnum is %d",rnum);
    Grb=0;

    Grc=1;
    #1;
    $display("rnum is %d",rnum);
    Grc=0;
end

endmodule
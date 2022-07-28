`include "src/decode/ir_decoder.v"
`include "src/decode/decoder4to16.v"
`include "src/decode/selectAndEncode.v"

module selectAndEncode_tb();

reg [31:0] ir_val;
reg Gra,Grb,Grc;

wire [3:0] rnum;
wire [15:0] r_select_vec;

reg r_in_enable, r_out_enable, BA_out;
wire [15:0] r_out;
wire [15:0] r_in;

ir_decoder uut(
    .ir_val(ir_val),
    .Gra(Gra),
    .Grb(Grb),
    .Grc(Grc),
    .rnum(rnum)
);

decoder4to16 decoder4to16_uut(
.rnum(rnum),
.r_select_vec(r_select_vec)
);

selectAndEncode selectAndEncode(
.r_select_vec(r_select_vec),
.r_in_enable(r_in_enable),
.r_out_enable(r_out_enable),
.BA_out(BA_out),
.r_out(r_out),
.r_in(r_in)
);

initial begin
    Gra=0;Grb=0;Grc=0;
    ir_val = 0;
    ir_val[26:23] = 5;
    ir_val[22:19] = 6;
    ir_val[18:15] = 7;

    r_in_enable = 0; r_out_enable = 0; BA_out = 0;

    
    Gra=1; r_in_enable = 1;
    #1;
    $display("r_in is %b",r_in);
    $display("r_out is %b",r_out);
    Gra=0;
    r_in_enable = 0;

    Grb=1;
    r_out_enable = 1;
    #1;
    $display("r_in is %b",r_in);
    $display("r_out is %b",r_out);
    Grb=0; r_out_enable = 0;

    Grc=1; BA_out = 1;
    #1;
    $display("r_in is %b",r_in);
    $display("r_out is %b",r_out);
    Grc=0;
end

endmodule

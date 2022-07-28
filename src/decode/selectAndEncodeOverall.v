`include "src/decode/ir_decoder.v"
`include "src/decode/decoder4to16.v"
`include "src/decode/selectAndEncode.v"

module selectAndEncodeOverall(
    input wire Gra,Grb,Grc,
    input wire [31:0] IR,
    output wire [15:0] r_in_vec,r_out_vec,
    input wire r_in_enable,r_out_enable,
    input wire BA_out,
    input wire [15:0] select_vec_override
);

wire [3:0] rnum;
wire [15:0] r_select_vec;

ir_decoder uut(
    .ir_val(IR),
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
    .r_select_vec(r_select_vec|select_vec_override),
    .r_in_enable(r_in_enable),
    .r_out_enable(r_out_enable),
    .BA_out(BA_out),
    .r_out(r_out_vec),
    .r_in(r_in_vec)
);

endmodule
module ir_decoder(
    input wire [31:0] ir_val,
    input wire Gra,Grb,Grc,
    output wire [3:0] rnum
);

assign rnum = 
    (Gra ? ir_val[26:23] : 0) |
    (Grb ? ir_val[22:19] : 0) |
    (Grc ? ir_val[18:15] : 0)
;

endmodule
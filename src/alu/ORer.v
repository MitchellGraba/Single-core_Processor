module ORer(rx,ry,rz);

input [31:0] rx,ry;
output [31:0] rz;
assign rz = rx|ry;

endmodule

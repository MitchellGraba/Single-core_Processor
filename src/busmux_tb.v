`timescale 1ms/1ms
`include "src/busmux.v"

module busmux_tb();

reg [4:0] select;
reg [31:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,
	r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,
	r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31;
reg clk;

wire [31:0] busmuxout;

busmux mybusmux(clk,select,busmuxout,r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,
	r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,
	r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31 );

initial begin
	$monitor("r1=%b, r2=%b, select=%b, out=%b",r1,r2,select,busmuxout);
	$dumpfile("bus.vcd");
	$dumpvars(0,busmux_tb);
	clk=0;r1=1;r2=3;r3=3;r7=400;r19=64000;

	select=1;clk=1; #10;clk=0;
	if (busmuxout!=1) $display("ERROR");
	select=7;clk=1;#10;clk=0;
	if (busmuxout!=400) $display("ERROR");
	select=19;clk=1;#10;clk=0;
	if (busmuxout!=64000) $display("ERROR");
end

endmodule

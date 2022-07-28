module busmux(clk,select,busmuxout,r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,
	r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,
	r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31);

input [31:0] r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,
	r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,
	r21,r22,r23,r24,r25,r26,r27,r28,r29,r30,r31;
input [4:0] select;
output reg [31:0] busmuxout;
input clk;

always @(posedge clk) 
begin
    case (select)
        0: busmuxout<=r0;
        1: busmuxout<=r1;
        2: busmuxout<=r2;
        3: busmuxout<=r3;
        4: busmuxout<=r4;
        5: busmuxout<=r5;
        6: busmuxout<=r6;
        7: busmuxout<=r7;
        8: busmuxout<=r8;
        9: busmuxout<=r9;
        10: busmuxout<=r10;
        11: busmuxout<=r11;
        12: busmuxout<=r12;
        13: busmuxout<=r13;
        14: busmuxout<=r14;
        15: busmuxout<=r15;
        16: busmuxout<=r16;
        17: busmuxout<=r17;
        18: busmuxout<=r18;
        19: busmuxout<=r19;
        20: busmuxout<=r20;
        21: busmuxout<=r21;
        22: busmuxout<=r22;
        23: busmuxout<=r23;
        24: busmuxout<=r24;
        25: busmuxout<=r25;
        26: busmuxout<=r26;
        27: busmuxout<=r27;
        28: busmuxout<=r28;
        29: busmuxout<=r29;
        30: busmuxout<=r30;
        31: busmuxout<=r31;
    endcase
end

endmodule

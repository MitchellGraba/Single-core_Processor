module boothmult(
    input wire signed [31:0] M,Q,
    input clk,
    input start,

    output wire [63:0] out,
    output wire done
);

// output plus the booth bit
reg [64:0] booth;
// output doesn't need booth bit
assign out = booth[64:1];

// 9 bit step for now, can decrease later
// needs to count to 31 or 32 not sure which    
reg [8:0] step;
assign done = step[5];

wire signed [31:0] upper;
assign upper = booth[64:33];

wire signed [31:0] sum,diff;
assign sum = upper + M;
assign diff = upper - M;

wire skip3 = ((booth[2:0]==0)|(booth[2:0]==7))&(step<=(31-3));
wire skip4 = ((booth[3:0]==0)|(booth[3:0]==15))&(step<=(31-4));
wire skip5 = ((booth[4:0]==0)|(booth[4:0]==31))&(step<=(31-5));

always @(posedge clk) begin
    // clear low to begin operation
    if (start) begin 
        // reset step
        step<=0;
        // write 0s to upper bits
        booth[64:32]<=0;
        // write multiplier to lower bits
        booth[32:1]<=Q;
        // write booth bit to 0
        booth[0]<=0;
    end
    else if (clk) if (!done) begin
        if (skip5) begin
            booth[64-4:0]<=booth[64:4];
            step<=step+4;
        end
        else if (skip4) begin
            booth[64-3:0]<=booth[64:3];
            step<=step+3;
        end
        else if (skip3) begin
            booth[64-2:0]<=booth[64:2];
            step<=step+2;
        end
        // look at last 2 bits of booth
        else begin
            case(booth[1:0])
                2'b01: begin
                    booth[64]<=sum[31];
                    booth[63:32]<=sum;
                    booth[31:0]<=booth[32:1];
                end
                2'b10: begin
                    booth[64]<=diff[31];
                    booth[63:32]<=diff;
                    booth[31:0]<=booth[32:1];
                end
                default: begin
                    booth[63:0]<=booth[64:1];
                end
            endcase
            step<=step+1;
        end
    end
end

endmodule
module shiftright(
    input [31:0] A,
    input [5:0] B,
    input clk,
    input start,
    output reg [31:0] C
);

reg [5:0] count;

always @(posedge clk) begin
    if (start) begin
        C = A;
        count = B;
    end
    else if (count!=0) begin
        count = count-1;
        C[30:0] = C[31:1];
    end
end

endmodule
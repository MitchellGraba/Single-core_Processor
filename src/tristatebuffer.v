module tristatebuffer(
    input enable,
    input [31:0] data,
    output [31:0] bus
);

// initial begin
//     $monitor("enable=%d,data=%d,bus=%d",enable,data,bus);
// end

assign bus = enable ? data : 32'bzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz;

endmodule
module division(  
   input      clk,  
   input      reset,  
   input      start,  
   input [31:0]  A,  //Dividend
   input [31:0]  B,  //Divisor
   output [31:0]  D,  //Quotient 
   output [31:0]  R,  //Remainder
   output     ok ,   // =1 when ready to get the result   
   output err  
   );  
   reg       active;   // True if the divider is running  
   reg [4:0]    cycle;   // Number of cycles to go  
   reg [31:0]   result;   // Begin with A, end with D  
   reg [31:0]   denom;   // B  
   reg [31:0]   work;    // Running Remainder 
   
   wire [32:0]   sub = { work[30:0], result[31] } - denom;  // subtracting the shifted value of A from the divisor
   assign err = !B;  //if B is all 1's you have entered the DANGERZONE

   assign D = result;  
   assign R = work;  
   assign ok = ~active;
   
   // The state machine  
   always @(posedge clk,posedge reset) begin  
     if (reset) begin  
       active <= 0;  
       cycle <= 0;  
       result <= 0;  
       denom <= 0;  
       work <= 0;  
     end  
     else if(start) begin  
      // Initialization for divide 
         cycle <= 5'd31;  
         result <= A;  
         denom <= B;  
         work <= 32'b0;  
         active <= 1;  
      end
      else if (active) begin  
         // Run an iteration of the divide.  
         if (sub[32] == 0) begin  
           work <= sub[31:0];               // sets A to it's subtracted value
           result <= {result[30:0], 1'b1};  //shifts Q reg place 1
         end  
         else begin  
           work <= {work[30:0], result[31]};  //else just shift
           result <= {result[30:0], 1'b0};    //place 0 in result (shifted) 
         end  
         if (cycle == 0) begin  
           active <= 0;  
         end  
         cycle <= cycle - 5'd1;  
       end  
     end  
 endmodule 
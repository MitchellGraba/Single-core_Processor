`include "src/alu/division.v"

 module division_tb;  
      // Inputs  
      reg clock;  
      reg reset;  
      reg start;  
      reg [31:0] A;  
      reg [31:0] B;  
      // Outputs  
      wire [31:0] D;  
      wire [31:0] R;  
      wire ok;  
      wire err;  
      // Instantiate the Unit Under Test (UUT)  
      division uut (  
           .clk(clock),   
           .start(start),  
           .reset(reset),  
           .A(A),   
           .B(B),   
           .D(D),   
           .R(R),   
           .ok(ok),  
           .err(err)  
      );  
      initial begin   
            clock = 0;  
            forever #50 clock = ~clock;  
      end  
      initial begin  
           // Initialize Inputs  
         
           reset=1; #100;
           start = 0;  
           A = 32'd1023;  
           B = 32'd50;

           $display("dividing 1023 by 50");
            
           // Wait 100 ns for global reset to finish  
           #1000;  
           $monitor("OK = %b   D = %d   R = %d", ok, D, R);
          //if(ok == 1) $display("D = %d   R = %d", D, R);
           reset=0;  
           start = 1;   
           #51;
           start=0;
           #5000;  
           $finish; 
           
      end  
      
 endmodule  
`timescale 1ns/1ns
module counter_Testbench();
  
  reg clk, Cen, Crst;
  wire Cout;
  mod3counter test(clk, Cen, Crst, Cout);
  
  always repeat(100) #10 clk = ~clk;
  initial begin
    clk = 0;
    Crst = 1;
    #40 Cen = 1;
    Crst = 0;
    #60 $stop;
  end
  
endmodule

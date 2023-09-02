`timescale 1ns/1ns
module EXP_tb();
  
reg clk, rst, start;
reg [15:0] x;

wire done;
wire [1:0] intpart;
wire [15:0] fracpart;
  
exponential uut (clk, rst, start, x, done, intpart, fracpart);
always #10 clk=~clk;
initial begin
clk=0;
rst=0;
start=0;
x=16'b1000000000000000;
#200 start = 1;
#40 start = 0;
#2000 x=16'b1100000000000000;
#200 start = 1;
#40 start = 0;
#2000 x=16'b1111000000000000;
#200 start = 1;
#40 start = 0;

#2000 $stop;
end

		   
endmodule

`timescale 1ns/ 1ns

module Exponential_Accelerator_TestBench();

reg clk, reset, Start, ReadSwitch;
wire Done;
wire [17 : 0]exp_result, data;
wire [2:0] ps;
wire [7:0] count;
wire Cout;

ExpWrapped Exponential_Accelerator(Done, clk, reset, Start, ReadSwitch,Cout,count, data, exp_result,ps);

always #50 clk = ~clk;
initial begin
ReadSwitch = 0;
clk = 0; reset = 0; Start = 0;
#100 reset = 1;
#100 Start = 1;
#100 Start = 0;
#200000 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 ReadSwitch = 1;
#100 ReadSwitch = 0;
#100 $stop;
end

endmodule
`timescale 1ns/ 1ns

module DDS_TestBench();

reg clk, reset;
reg  [2 : 0]func, Phase_cntrl;
wire in;
wire [7 : 0]Generated_Waveform,w1,w2,DFF;

DDS dds(in, clk, DFF, reset,Phase_cntrl,Generated_Waveform,func, w1, w2);

always #20 clk = ~clk;
initial begin
clk = 0; reset = 0; func = 3'b011; Phase_cntrl = 3'b001;
#60 reset = 1;
#2000000 $stop;
end

endmodule

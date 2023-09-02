`timescale 1ns/ 1ns

module Function_Generator_TestBench();

reg  clk, reset, DN, Preset, CLR, Phase_cntrl;
reg  [2 : 0]func;
reg [1:0] AMP_sel;
reg [3 : 0]Freq_select;
wire [7 : 0]Generated_Waveform; 

Function_Generator function_generator(Generated_Waveform,	AMP_sel,
	func,
	clk,
	CLR,
	Freq_select[3],
	Freq_select[2],
	Freq_select[1],
	Freq_select[0],
	reset,
	Phase_cntrl);
 

always #20 clk = ~clk;
initial begin
clk = 0; reset = 0; func = 3'b011; Phase_cntrl = 1; Freq_select = 4'b1000; CLR = 0; Preset = 1; DN = 1;
AMP_sel=2'b10;
#60 reset = 1; CLR = 1;
#8000000 $stop;
end

endmodule

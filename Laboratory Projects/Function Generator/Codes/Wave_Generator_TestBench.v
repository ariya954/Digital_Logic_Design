`timescale 1ns/1ns

module DAC_TestBench();

reg clk;
reg  [2 : 0]func;
wire [7 : 0]Generated_Waveform, Digital_To_Analog_Converted_Signal;
DAC dac(clk, Generated_Waveform, Digital_To_Analog_Converted_Signal);
WaveForm_Generator_Processor waveform_generator_processor(clk, func, Generated_Waveform);

always #2 clk = ~clk;
initial begin
clk = 0; func = 3'b000;

#2000000 $stop;
end

endmodule

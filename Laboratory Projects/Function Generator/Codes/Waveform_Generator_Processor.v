`timescale 1ns/1ns

module WaveForm_Generator_Processor(input clk, input [2 : 0]func, output [7 : 0]Generated_Waveform);

reg counter;
reg [7 : 0]up_count, wave_data;
initial begin
wave_data = 8'b0;
up_count = 8'b0;
counter = 1;
end

always @(posedge clk)begin
    up_count = up_count + 1;
    if(func == 3'b011)begin
      if(counter == 1)
        wave_data = wave_data + 1; 
      else
        wave_data = wave_data - 1;
    end
    if(func == 3'b000)begin
      if(counter == 1)      
        if(wave_data >= 0)
          wave_data = -1 * (wave_data + 1); 
        else
          wave_data = -1 * (wave_data - 1);
      else
        if(wave_data >= 0)
          wave_data = -1 * (wave_data - 1); 
        else
          wave_data = -1 * (wave_data + 1); 
    end
    if(up_count == 127)begin
      if(func == 3'b001)
        wave_data = (wave_data == 8'b00000001) ? 8'b0 : 8'b00000001;
      if(func == 3'b011 || func == 3'b000)
        counter = (counter) ? 0 : 1;
      up_count = 0;
    end
end

assign Generated_Waveform = wave_data;

endmodule
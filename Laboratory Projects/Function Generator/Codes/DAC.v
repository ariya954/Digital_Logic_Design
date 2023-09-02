`timescale 1ns/1ns

module DAC(input clk, input [7 : 0]data, output [7 : 0]Digital_To_Analog_Converted_Signal);

reg pwm;
reg [7 : 0]up_count;
initial begin
pwm = 0;
up_count = 8'b0;
end

always @(posedge clk)begin
    up_count = up_count + 1;
    if(up_count == 128)begin
      pwm = ~pwm;
      up_count = 0;
    end
end

assign Digital_To_Analog_Converted_Signal = data * pwm;

endmodule

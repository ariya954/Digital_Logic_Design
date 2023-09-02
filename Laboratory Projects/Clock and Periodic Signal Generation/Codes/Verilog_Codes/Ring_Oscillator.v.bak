`timescale 1 ns/ 1 ns

module Ring_Oscillator #(parameter number_of_inverters = 5, parameter delay_of_an_inverter = 21)(en, ring_oscillator_output);

input en;
output ring_oscillator_output;

wire [number_of_inverters : 0]wires_between_inverters;
assign wires_between_inverters[0] = en ? wires_between_inverters[number_of_inverters] : 0;

genvar i;
generate
for(i = 0; i < number_of_inverters; i = i + 1)begin
  not #(delay_of_an_inverter)(wires_between_inverters[i + 1], wires_between_inverters[i]);
end
endgenerate

assign ring_oscillator_output = wires_between_inverters[number_of_inverters];

endmodule


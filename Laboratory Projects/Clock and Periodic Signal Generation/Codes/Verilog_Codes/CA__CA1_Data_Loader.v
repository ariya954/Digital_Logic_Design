`timescale 1ns/1ns

module Register(input clk, reset, load, input [19 : 0] D, output reg [19 : 0]Q);

always @(posedge clk, posedge reset)begin
   if(reset)
      Q <= 20'b0;
   else begin
      if(load)
         Q <= D;
   end
end

endmodule

module Register_40_bit(input clk, reset, load, input [39 : 0] D, output reg [39 : 0]Q);

always @(posedge clk, posedge reset)begin
   if(reset)
      Q <= 20'b0;
   else begin
      if(load)
         Q <= D;
   end
end

endmodule

module eight_bit_Decoder(input [7 : 0]_input, output reg[149 : 0]decoded_output);

reg [7 : 0]i, j;
always @(_input)begin
  for(i = 0; i < 150; i = i + 1)begin
    decoded_output[i] = 1'b0;
  end
  decoded_output[_input] = 1'b1;
end

endmodule

module Data_Loader_DataPath(input clk, reset, reset_x_avg, load_x_avg, reset_y_avg, load_y_avg, select, input [19 : 0]x_Bus, y_Bus, input [7 : 0]output_select, register_load_select, output [19 : 0]x_out, y_out);

wire [39 : 0] x_avg, y_avg;
wire [19 : 0] x [149 : 0];
wire [19 : 0] y [149 : 0];
wire [149 : 0]load;

eight_bit_Decoder Decoder(register_load_select, load);
genvar k;
generate
for(k = 0; k < 150; k = k + 1) 
 begin
   Register xx(clk, reset, load[k], x_Bus, x[k]); 
   Register yy(clk, reset, load[k], y_Bus, y[k]); 
 end 
endgenerate
Register_40_bit x_average(clk, reset_x_avg, load_x_avg, x[output_select] + x_avg, x_avg);
Register_40_bit y_average(clk, reset_y_avg, load_y_avg, y[output_select] + y_avg, y_avg);

assign x_out = select ? (x_avg / 150) : x[output_select];
assign y_out = select ? (y_avg / 150) : y[output_select];

endmodule

module Data_Loader_CU(input start, clk, reset, output reg[7 : 0]register_load_select, output_select, output reg reset_x_avg, reset_y_avg, load_x_avg, load_y_avg, select, enable_coefficient_calculator_module);

wire co_of_counter_of_Decoder_input, co_of_counter_of_Mux_select;
reg[2 : 0] ns, ps;
parameter[2 : 0] Idle = 3'b000, load = 3'b001, Inc_load = 3'b010, Init_avg = 3'b011, averaging = 3'b100, Inc_avg = 3'b101, send_avg = 3'b110, send_data = 3'b111;
always @(start, ps, co_of_counter_of_Decoder_input, co_of_counter_of_Mux_select) begin
   case(ps) 
     Idle:  begin ns = start ? load : Idle; enable_coefficient_calculator_module = 0; end
     load:  begin ns = Inc_load; register_load_select = register_load_select + 1; end
     Inc_load: begin ns = co_of_counter_of_Decoder_input ? Init_avg : load; register_load_select = register_load_select + 1; end
     Init_avg: begin ns = averaging; reset_x_avg = 1; reset_y_avg = 1; end
     averaging: begin ns = Inc_avg;  reset_x_avg = 0; reset_y_avg = 0; load_x_avg = 1; load_y_avg = 1; output_select = output_select + 1; end
     Inc_avg: begin ns = co_of_counter_of_Mux_select ? send_avg : averaging; output_select = output_select + 1; enable_coefficient_calculator_module = co_of_counter_of_Mux_select ? 1 : 0; end
     send_avg: begin ns = send_data; select = 1; output_select = 0; end
     send_data: begin ns = co_of_counter_of_Mux_select ? Idle : send_data; select = 0; end
     default: begin ns = Idle; register_load_select = 8'b0; output_select = 8'b0; end
   endcase
end

always @(posedge clk, posedge reset) begin
   if(reset)
     ps <= 0;
   else begin
     ps <= ns;       
    if(ps == send_data)
      output_select = output_select + 1;
   end
end

assign co_of_counter_of_Decoder_input = (register_load_select >= 150) ? 1 : 0;
assign co_of_counter_of_Mux_select = (output_select >= 150) ? 1 : 0;
assign load_x_avg = (output_select >= 150) ? 0 : load_x_avg;
assign load_y_avg = (output_select >= 150) ? 0 : load_y_avg;

endmodule

module Data_Loader(input start, clk, reset, input [19 : 0]x_Bus, y_Bus, output [19 : 0]x_out, y_out, output enable_coefficient_calculator_module);

wire [7 : 0]register_load_select, output_select;
wire reset_x_avg, reset_y_avg, load_x_avg, load_y_avg, select;
Data_Loader_DataPath Data_Path(clk, reset, reset_x_avg, load_x_avg, reset_y_avg, load_y_avg, select, x_Bus, y_Bus, output_select, register_load_select, x_out, y_out);
Data_Loader_CU CU(start, clk, reset, register_load_select, output_select, reset_x_avg, reset_y_avg, load_x_avg, load_y_avg, select, enable_coefficient_calculator_module);

endmodule
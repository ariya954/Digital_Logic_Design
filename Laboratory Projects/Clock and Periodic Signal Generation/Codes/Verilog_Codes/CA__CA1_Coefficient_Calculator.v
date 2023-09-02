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

module Coefficient_Calculator_DataPath(input clk, reset_avg, reset_SS, load_avg, load_SS, input [19 : 0]x_Bus, y_Bus, output [19 : 0]b_0, b_1);

wire [39 : 0] SS_XX, SS_XY;
wire [19 : 0] x_avg, y_avg;

Register_40_bit SSXY(clk, reset_SS, load_SS, (x_Bus - x_avg) * (y_Bus - y_avg) + SS_XY, SS_XY);
Register_40_bit SSXX(clk, reset_SS, load_SS, (x_Bus - x_avg) * (x_Bus - x_avg) + SS_XX, SS_XX);
Register x_average(clk, reset_avg, load_avg, x_Bus, x_avg);
Register y_average(clk, reset_avg, load_avg, y_Bus, y_avg);

assign b_0 = y_avg - (b_1 * x_avg);
assign b_1 = SS_XY / SS_XX;

endmodule

module Coefficient_Calculator_CU(input en, clk, reset, output reg load_avg, load_SS, reset_SS, enable_error_checker_module);

wire co_of_counter;
reg [7 : 0]counter;
reg [2 : 0] ns, ps;
parameter[2 : 0] Idle = 3'b000, load_averages = 3'b001, Init_SS_registers = 3'b010, calculate_coefficients = 3'b011, update_registers = 3'b100;
always @(en, ps, co_of_counter) begin
   case(ps) 
     Idle:  begin ns = en ? load_averages : Idle; counter = 8'b0; enable_error_checker_module = 0; end
     load_averages:  begin ns = Init_SS_registers; load_avg = 1; enable_error_checker_module = 1; end
     Init_SS_registers: begin ns = calculate_coefficients; reset_SS = 1; load_avg = 0; end
     calculate_coefficients: begin ns = update_registers; load_SS = 1; reset_SS = 0; counter = counter + 1; end
     update_registers: begin ns = co_of_counter ? Idle : calculate_coefficients; counter = counter + 1; end
     default: begin ns = Idle; end
   endcase
end

always @(posedge clk, posedge reset) begin
   if(reset)
     ps <= 0;
   else
     ps <= ns; 
end

assign co_of_counter = (counter >= 150) ? 1 : 0;
assign load_SS = (counter >= 150) ? 0 : load_SS;

endmodule

module Coefficient_Calculator(input en, clk, reset, input [19 : 0]x_Bus, y_Bus, output [19 : 0]b_0, b_1, output enable_error_checker_module);

wire load_avg, load_SS, reset_SS;
Coefficient_Calculator_DataPath Data_Path(clk, reset, reset_SS, load_avg, load_SS, x_Bus, y_Bus, b_0, b_1);
Coefficient_Calculator_CU CU(en, clk, reset, load_avg, load_SS, reset_SS, enable_error_checker_module);

endmodule
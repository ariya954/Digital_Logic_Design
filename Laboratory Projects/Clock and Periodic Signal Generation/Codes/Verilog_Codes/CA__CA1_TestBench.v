`timescale 1ns/1ns

module Linear_Regression_Calculator_Test_Bench();

reg start, clk, reset;
reg  [19 : 0]x_Bus, y_Bus;
wire [19 : 0]x, y, b_0, b_1, error;
wire enable_coefficient_calculator_module, enable_error_checker_module;

integer input_x, input_y, scan_file;

Data_Loader data_loader(start, clk, reset, x_Bus, y_Bus, x, y, enable_coefficient_calculator_module);
Coefficient_Calculator coefficient_calculator(enable_coefficient_calculator_module, clk, reset, x, y, b_0, b_1, enable_error_checker_module);
Error_Checker error_checker(enable_error_checker_module, clk, reset, b_0, b_1, x, y, error);

always #100 clk = ~clk;
initial begin

clk = 0; reset = 0; start = 0;
#400 start = 1;

input_x = $fopen("x_value.txt", "r");
input_y = $fopen("y_value.txt", "r");
while(!$feof(input_x))begin
  scan_file = $fscanf(input_x, "%b.", x_Bus[19 : 10]);
  scan_file = $fscanf(input_x, "%b\n", x_Bus[9 : 0]);
  scan_file = $fscanf(input_y, "%b.", y_Bus[19 : 10]);
  scan_file = $fscanf(input_y, "%b\n", y_Bus[9 : 0]); 
  #200;
end
#700000 $stop;

end

endmodule

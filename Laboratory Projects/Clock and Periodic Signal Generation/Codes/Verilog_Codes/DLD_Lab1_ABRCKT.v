`timescale 1ns/1ns

module Register_8_bit(input clk, load_en, input [7 : 0] D, output reg [7 : 0]Q);

always @(posedge clk)begin

    if(load_en)
       Q <= D;
end

endmodule

module BRG_Counter(input BRGCLK, cnt_rst, cnt_en, output reg [7 : 0]count);

always @(posedge BRGCLK, posedge cnt_rst)begin
   if(cnt_rst)
      count <= 8'b0;
   else begin
      if(cnt_en)
         count <= cnt_en + 1;
   end
end

endmodule

module ABRCKT_DataPath(input BRGCLK, ld_en, cnt_en, cnt_rst, output [7 : 0]frequency_divider_input);

wire [7 : 0] count;
Register_8_bit BRG_Reg(BRGCLK, ld_en, count, frequency_divider_input);
BRG_Counter(BRGCLK, cnt_rst, cnt_en, count);

endmodule

module ABRCKT_CU(input ABAUD, UxRX, BRGCLK, output reg UxRXIF, cnt_rst, cnt_en, ld_en);

reg [2 : 0]edges;
wire co_of_counter_of_edges;
reg[1 : 0] ns, ps;
parameter[2 : 0] Idle = 2'b00, looking_for_start_bit = 2'b01, counting_edges = 2'b01, send_BRG_reg_value_to_frequency_divider = 2'b11;
always @(ABAUD, UxRX, ps, co_of_counter_of_edges) begin
   case(ps) 
     Idle:  begin ns = ABAUD ? looking_for_start_bit : Idle; ld_en = 0; UxRXIF = 0; edges = 3'b0; end
     looking_for_start_bit:  begin ns = UxRX ? looking_for_start_bit : counting_edges; cnt_rst = 1; end
     counting_edges: begin ns = co_of_counter_of_edges ? send_BRG_reg_value_to_frequency_divider : counting_edges; cnt_en = 1; cnt_rst = 0; edges = UxRX ? edges : edges + 1; end
     send_BRG_reg_value_to_frequency_divider: begin ns = Idle; ld_en = 1; UxRXIF = 1; end
     default: begin ns = Idle; end
   endcase
end

always @(posedge BRGCLK) begin

     ps <= ns;

end

assign co_of_counter_of_edges = (edges >= 5) ? 1 : 0;

endmodule

module ABRCKT(input ABAUD, UxRX, BRGCLK, output [7 : 0]frequency_divider_input, output UxRXIF);

wire cnt_rst, cnt_en, ld_en;
ABRCKT_DataPath Data_Path(BRGCLK, ld_en, cnt_en, cnt_rst, frequency_divider_input);
ABRCKT_CU CU(ABAUD, UxRX, BRGCLK, UxRXIF, cnt_rst, cnt_en, ld_en);

endmodule



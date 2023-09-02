module AMP_SELECTOR(input [1:0] division, input [7:0] signal, output [7:0] out);

assign out = (division == 2'b00) ? signal :
             (division == 2'b01) ? signal >> 1 :
				 (division == 2'b10) ? signal >> 2 :
             (division == 2'b11) ? signal >> 3 :
				 8'bz;
endmodule
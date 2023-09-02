module counter10(input clk, Cen, Crst, output [7:0] address, output Cout);
  reg [3:0] count;
  always @(posedge clk, posedge Crst) begin
      if (Crst) count = 4'b0;
		else begin 
		if (Cen) begin count <= count + 1;
				if (Cout) count <= 0;
			end
		end
	end
  assign Cout = (count == 4'd9) ? 1 : 0;
  assign address = {4'b0, count};
endmodule
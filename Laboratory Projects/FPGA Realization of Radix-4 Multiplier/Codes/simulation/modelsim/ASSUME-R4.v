`timescale 1ns/1ns
module ASSUME_R4_DP(input [7:0] in, input clk, rst, ldx, ldA, ldR, MSBrst, inSrcx, inSrcA, Xsrc, output [31:0] result);
  //defining our registers and their load and reset inputs
  reg [16:0] Xreg;
  reg [15:0] Areg, ResMSB;
  wire [16:0] Xrin;
  wire [15:0] Arin, Resrin;
  always @(posedge clk, posedge MSBrst) begin
    if (MSBrst) ResMSB<=16'b0;
	 else begin
			 if(rst) begin
				Xreg <= 0;
				Areg <= 0;
				ResMSB <= 0;
			 end
			 if(ldx) 
				Xreg <= Xrin;
			 if(ldR) 
				ResMSB <= Resrin;
			 if(ldA) 
				Areg <= Arin;
		end
  end
  //defining the multiplexers that select our registers inputs
  wire [16:0] Xin;
  wire [15:0] sum, PP;
  wire [2:0] R4ENC;
  wire [14:0] SXR;
  assign SXR = (Xreg >> 2);
  assign Xin = inSrcx ? {in, Xreg[8:0]} : {8'b0, in, 1'b0};
  assign Arin = inSrcA ? {in, Areg[7:0]} : {Areg[15:8], in};
  assign Xrin = Xsrc? Xin : {sum[1:0], SXR};
  assign  PP = R4ENC == 3'b000 ? -Areg
              :R4ENC == 3'b001 ? -(Areg <<< 1)
              :R4ENC == 3'b010 ?   Areg
              :R4ENC == 3'b011 ? (Areg <<< 1)
              :R4ENC == 3'b100 ? 16'b0 
              : 16'bx;
  //defining the LUT as an array (which determines the select of our PP MUX
  
  wire [2:0] LUT[0:7];
  assign LUT [0] = 3'd4;
  assign LUT [1] = 3'd2;
  assign LUT [2] = 3'd2;
  assign LUT [3] = 3'd3;
  assign LUT [4] = 3'd1;
  assign LUT [5] = 3'd0;
  assign LUT [6] = 3'd0;
  assign LUT [7] = 3'd4; 
  assign R4ENC = LUT[Xreg[2:0]];
  // defining our adder result 
assign sum=PP+ResMSB;
  //sign extention 
assign Resrin = {sum[15], sum[15], sum[15:2]};
assign result = {ResMSB,Xreg[16:1]};
endmodule

module counter8(input clk, Cen, Crst, output Cout);
  reg [3:0] count;
  always @(posedge clk, posedge Crst) begin
      if (Crst) count=4'b0;
		else begin 
		if (Cout) count = 0;
		if (Cen) count = count+1;
		end
	end
  assign Cout = count[2]&count[1]&count[0];
endmodule

module ASSUME_R4_CU(input clk, rst, start, getA, getX, output reg ldx, ldA, ldR, MSBrst, inSrcx, inSrcA, Xsrc, ready);
  parameter [3:0] Idle = 4'd1, wait0 = 4'd2, LSBA = 4'd3, wait1 = 4'd4, MSBA = 4'd5, wait2 = 4'd6, LSBX = 4'd7,
                  wait3 = 4'd8, MSBX = 4'd9, wait4=4'd10, calc = 4'd11, done = 4'd0;


  reg Cen, Crst;
  wire cout;

  counter8 counter (clk, Cen, Crst, cout);          
  reg [3:0] ps, ns;
  always @(start, getA, getX, cout, ps) begin
    case(ps)
      Idle : ns = start ? Idle : wait0;
      wait0 : ns = getA ? LSBA : wait0;
      LSBA : ns = getA ? LSBA : wait1;
      wait1 : ns = getA ? MSBA : wait1;
      MSBA : ns = getA ? MSBA : wait2;
      wait2 : ns = getX ? LSBX : wait2;
      LSBX : ns = getX ? LSBX : wait3;
      wait3 : ns = getX ? MSBX : wait3;
      MSBX : ns = getX ? MSBX : wait4;
      wait4 : ns = calc;  
      calc : ns = cout ? done : calc;
      done : ns = start ? Idle : done;
      default: ns=done;
    endcase
  end
  
  always @(ps) begin
    {ldx, ldA, ldR, inSrcx, inSrcA, Xsrc, ready, MSBrst,Crst} = 9'b0;
    case(ps)
      Idle : begin MSBrst = 1'b1; Crst = 1'b1; end
      LSBA : begin ldA=1'b1; end
      MSBA : begin inSrcA=1'b1; end 
      wait1 : begin ldA=1'b1; end
      wait2 : begin ldA=1'b1; inSrcA=1'b1; end 
      LSBX : begin ldx=1'b1; Xsrc=1'b1; end
      wait3 : begin ldx=1'b1; Xsrc=1'b1; end
      MSBX : begin inSrcx=1'b1; end
      wait4 : begin ldx=1'b1; Xsrc=1'b1; inSrcx=1'b1; end            
      calc : begin ldR=1'b1; ldx=1'b1; Cen=1'b1; end
      done : ready = 1'b1;
      default :  {ldx, ldA, ldR, inSrcx, inSrcA, Xsrc, ready, MSBrst,Crst} = 9'b0;
    endcase
  end
  always @(posedge clk, posedge rst) begin
     if(rst) ps<=done;
    else ps<=ns;
   end
   
endmodule

module ASSUME_R4(input clk, rst, start, getA, getX, input [7:0] in, output [31:0] result , output ready);
wire ldx, ldA, ldR, MSBrst, inSrcx, inSrcA, Xsrc;

ASSUME_R4_DP datapath (in, clk, rst, ldx, ldA, ldR, MSBrst, inSrcx, inSrcA, Xsrc, result);
ASSUME_R4_CU controlunit(clk, rst, start, getA, getX, ldx, ldA, ldR, MSBrst, inSrcx, inSrcA, Xsrc, ready);

endmodule
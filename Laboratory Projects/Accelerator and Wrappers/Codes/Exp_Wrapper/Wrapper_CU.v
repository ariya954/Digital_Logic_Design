module Wrapper_CU(input clk, rst, Start, empty, eng_done , cout, ReadSwitch, output reg inc_counter, eng_start, rst_count, rd_req, Done, output reg [2:0]ps);
  parameter [2:0] Idle = 3'd0, Init = 3'd1, StartComp = 3'd2, WaitComp = 3'd3, WaitWrite = 3'd4, WaitSw1 = 3'd5, ReadReq = 3'd6,
                  WaitSw0 = 3'd7;

  reg [2:0] ns;
  always @(Start, eng_done, cout, ReadSwitch, ps,empty) begin
    case(ps)
      Idle : ns = Start ? Init : Idle;
      Init : ns = Start ? Init : StartComp;
      StartComp : ns = WaitComp;
      WaitComp : ns = eng_done ? WaitWrite : WaitComp;
      WaitWrite : ns = cout ? WaitSw1 : StartComp;
      WaitSw1 : ns = (empty==1)  ? 	Idle :
						(ReadSwitch==1)? 	ReadReq:
												WaitSw1;
												
      ReadReq : ns = WaitSw0;
      WaitSw0 : ns = ReadSwitch ? WaitSw0 : WaitSw1;
      default: ns=Idle;
    endcase
 end
 
  always @(ps) begin
    {inc_counter, rst_count, rd_req, Done} = 4'b0;
    case(ps)
      Idle : Done=1;
      Init : rst_count=1;
      StartComp : eng_start=1;
      WaitWrite : inc_counter=1;												
      ReadReq : rd_req=1;
      default : {inc_counter, rst_count, rd_req, Done} = 4'b0;

    endcase
  end
  always @(posedge clk, posedge rst) begin
     if(rst) ps<=Idle;
    else ps<=ns;
   end
endmodule
   
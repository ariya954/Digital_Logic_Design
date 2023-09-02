library verilog;
use verilog.vl_types.all;
entity counter8 is
    port(
        clk             : in     vl_logic;
        Cen             : in     vl_logic;
        Crst            : in     vl_logic;
        Cout            : out    vl_logic
    );
end counter8;

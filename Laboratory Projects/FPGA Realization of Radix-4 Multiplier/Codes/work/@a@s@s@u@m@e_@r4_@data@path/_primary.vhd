library verilog;
use verilog.vl_types.all;
entity ASSUME_R4_DataPath is
    port(
        \in\            : in     vl_logic_vector(7 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        ldx             : in     vl_logic;
        ldA             : in     vl_logic;
        ldR             : in     vl_logic;
        inSrcx          : in     vl_logic;
        inSrcA          : in     vl_logic;
        Xsrc            : in     vl_logic;
        result          : out    vl_logic_vector(15 downto 0)
    );
end ASSUME_R4_DataPath;

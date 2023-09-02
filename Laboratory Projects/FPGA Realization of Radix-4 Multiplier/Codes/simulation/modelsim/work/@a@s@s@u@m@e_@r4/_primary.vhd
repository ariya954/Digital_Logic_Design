library verilog;
use verilog.vl_types.all;
entity ASSUME_R4 is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        getA            : in     vl_logic;
        getX            : in     vl_logic;
        \in\            : in     vl_logic_vector(7 downto 0);
        displ           : out    vl_logic_vector(6 downto 0);
        disp2           : out    vl_logic_vector(6 downto 0);
        disp3           : out    vl_logic_vector(6 downto 0);
        disp4           : out    vl_logic_vector(6 downto 0);
        ready           : out    vl_logic
    );
end ASSUME_R4;

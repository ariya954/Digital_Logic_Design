library verilog;
use verilog.vl_types.all;
entity ASSUME_R4_CU is
    generic(
        Idle            : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi1);
        wait0           : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi0);
        LSBA            : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi1, Hi1);
        wait1           : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi0);
        MSBA            : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi0, Hi1);
        wait2           : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi0);
        LSBX            : vl_logic_vector(3 downto 0) := (Hi0, Hi1, Hi1, Hi1);
        wait3           : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi0, Hi0);
        MSBX            : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi0, Hi1);
        wait4           : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi1, Hi0);
        calc            : vl_logic_vector(3 downto 0) := (Hi1, Hi0, Hi1, Hi1);
        done            : vl_logic_vector(3 downto 0) := (Hi0, Hi0, Hi0, Hi0)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        start           : in     vl_logic;
        getA            : in     vl_logic;
        getX            : in     vl_logic;
        ldx             : out    vl_logic;
        ldA             : out    vl_logic;
        ldR             : out    vl_logic;
        MSBrst          : out    vl_logic;
        inSrcx          : out    vl_logic;
        inSrcA          : out    vl_logic;
        Xsrc            : out    vl_logic;
        ready           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of Idle : constant is 2;
    attribute mti_svvh_generic_type of wait0 : constant is 2;
    attribute mti_svvh_generic_type of LSBA : constant is 2;
    attribute mti_svvh_generic_type of wait1 : constant is 2;
    attribute mti_svvh_generic_type of MSBA : constant is 2;
    attribute mti_svvh_generic_type of wait2 : constant is 2;
    attribute mti_svvh_generic_type of LSBX : constant is 2;
    attribute mti_svvh_generic_type of wait3 : constant is 2;
    attribute mti_svvh_generic_type of MSBX : constant is 2;
    attribute mti_svvh_generic_type of wait4 : constant is 2;
    attribute mti_svvh_generic_type of calc : constant is 2;
    attribute mti_svvh_generic_type of done : constant is 2;
end ASSUME_R4_CU;

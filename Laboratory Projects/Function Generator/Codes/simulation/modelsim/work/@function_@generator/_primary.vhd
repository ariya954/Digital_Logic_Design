library verilog;
use verilog.vl_types.all;
entity Function_Generator is
    port(
        generated_Wave_form: out    vl_logic_vector(7 downto 0);
        AMP_sel         : in     vl_logic_vector(1 downto 0);
        func            : in     vl_logic_vector(2 downto 0);
        ring_oscillator : in     vl_logic;
        CLR             : in     vl_logic;
        Freq_select3    : in     vl_logic;
        Freq_select2    : in     vl_logic;
        Freq_select1    : in     vl_logic;
        Freq_select0    : in     vl_logic;
        reset           : in     vl_logic;
        Phase_cntrl     : in     vl_logic
    );
end Function_Generator;

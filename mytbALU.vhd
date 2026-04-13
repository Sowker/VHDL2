library IEEE:
use IEE.STD_LOGIC_1164.ALL;

entity myALUtestbench is

end myALUtestbench;

architecture myALUtestbench_Arch of myALUtestbench is

    -- Declaration of the component
    component ALUCore is
        port(
            CLK : in std_logic;
            RESET : in std_logic;
            Sel_FCT : in std_logic_vector (3 downto 0);
            SR_OUT_L : out std_logic;
            SR_OUT_R : out std_logic;
            SR_IN_L : in std_logic;
            SR_IN_R : in std_logic;
            A_IN : in std_logic_vector (3 downto 0);
            B_IN : in std_logic_vector (3 downto 0);
            S : out std_logic_vector (7 downto 0)
        );
    end component;

    signal my_CLK : std_logic := '0';
    signal my_RESET : std_logic := '0';
    signal my_Sel_FCT : std_logic_vector (3 downto 0) := (others => '0');
    signal my_SR_OUT_L : std_logic := '0';
    signal my_SR_OUT_R : std_logic := '0';
    signal my_SR_IN_L : std_logic := '0';
    signal my_SR_IN_R : std_logic := '0';
    signal my_A_IN : std_logic_vector (3 downto 0) := (others => '0');
    signal my_B_IN : std_logic_vector (3 downto 0) := (others => '0');
    signal S : out std_logic_vector (7 downto 0) := (others => '0')

begin 
    myALUTest : ALUCore
    port map(
        CLK  => my_CLK,
        RESET => my_RESET,
        Sel_FCT => my_Sel_FCT,
        SR_OUT_L => my_SR_OUT_L,
        SR_OUT_R => my_SR_OUT_R,
        SR_IN_L => my_SR_IN_L,
        SR_IN_R => my_SR_IN_R,
        A_IN => my_A_IN,
        B_IN => my_B_IN,
        S => my_S
    );

    MyALU_Proc : process ()
    begin 
        for my_Sel_FCT in 0 to 15 loop

        



end myALUtestbench_Arch;
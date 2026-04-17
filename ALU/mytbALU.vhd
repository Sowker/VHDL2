library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL; 

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

    -- Internal signals initialization
    signal my_CLK : std_logic := '0';
    signal my_RESET : std_logic := '0';
    signal my_Sel_FCT : std_logic_vector (3 downto 0) := (others => '0');
    signal my_SR_OUT_L : std_logic := '0';
    signal my_SR_OUT_R : std_logic := '0';
    signal my_SR_IN_L : std_logic := '0';
    signal my_SR_IN_R : std_logic := '0';
    signal my_A_IN : std_logic_vector (3 downto 0) := (others => '0');
    signal my_B_IN : std_logic_vector (3 downto 0) := (others => '0');
    signal my_S : std_logic_vector (7 downto 0) := (others => '0'); -- Removed 'out' direction

    -- Constant for clock period
    constant CLK_PERIOD : time := 10 ns;

begin 
    -- Device Under Test (DUT) Instantiation
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

    -- Clock Generation Process
    Clk_Proc : process
    begin
        my_CLK <= '0';
        wait for CLK_PERIOD / 2;
        my_CLK <= '1';
        wait for CLK_PERIOD / 2;
    end process;

    -- Stimulus Process
    MyALU_Proc : process
    begin 
        -- 1. Apply Reset
        my_RESET <= '1';
        wait for CLK_PERIOD * 2;
        my_RESET <= '0';
        wait for CLK_PERIOD * 2;

        -- 2. Setup standard test data for A and B
        my_A_IN <= "1010"; -- Example decimal 10
        my_B_IN <= "0101"; -- Example decimal 5
        my_SR_IN_L <= '1';
        my_SR_IN_R <= '0';

        -- 3. Loop through every function code
        for i in 0 to 15 loop
            -- Cast the integer loop counter to a 4-bit std_logic_vector
            my_Sel_FCT <= std_logic_vector(to_unsigned(i, 4));
            
            -- Wait a few clock cycles to observe the output
            wait for CLK_PERIOD * 2;
        end loop;

        -- End simulation sequence
        wait; 
    end process;

end myALUtestbench_Arch;
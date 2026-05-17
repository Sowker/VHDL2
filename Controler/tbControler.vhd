library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ControlerCore is
-- Testbench entities have no ports
end tb_ControlerCore;

architecture behavior of tb_ControlerCore is

    -- Component Declaration for the Device Under Test (DUT)
    component ControlerCore
    Port (
        CLK   : in std_logic;
        BTN   : in std_logic_vector (3 downto 0);
        SW    : in std_logic_vector (3 downto 2);
        LED   : out std_logic_vector (3 downto 0);
        LED_R : out std_logic; 
        LED_G : out std_logic;
        LED_B : out std_logic
    );
    end component;

    -- Inputs
    signal CLK : std_logic := '0';
    signal BTN : std_logic_vector(3 downto 0) := (others => '0');
    signal SW  : std_logic_vector(3 downto 2) := "00";

    -- Outputs
    signal LED   : std_logic_vector(3 downto 0);
    signal LED_R : std_logic;
    signal LED_G : std_logic;
    signal LED_B : std_logic;

    -- Clock period definitions
    constant CLK_period : time := 10 ns;

begin

    -- Instantiate the Device Under Test (DUT)
    uut: ControlerCore PORT MAP (
        CLK   => CLK,
        BTN   => BTN,
        SW    => SW,
        LED   => LED,
        LED_R => LED_R,
        LED_G => LED_G,
        LED_B => LED_B
    );

    -- Clock process definition
    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin		
        -- 1. System Reset & Settle Time
        wait for 100 ns;	

        -- 2. Start the Game (IDLE "00" -> NEW_ROUND "01")
        BTN(3) <= '1';
        wait for CLK_period * 2;
        BTN(3) <= '0';
        
        -- Wait for LFSR and State Machine to process
        -- Since clock is divided by 5, we wait longer to ensure it shifts
        wait for CLK_period * 15;

        -- 3. Simulate Gameplay in WAIT_RESPONSE ("10")
        SW <= "10"; -- Set difficulty
        
        -- Try pressing a button to trigger a VALID_HIT and return to "01"
        -- (Pressing Green as a guess)
        BTN(1) <= '1';
        wait for CLK_period * 5;
        BTN(1) <= '0';
        
        wait for CLK_period * 20;

        -- Try pressing another button just in case the first wasn't the correct color
        BTN(2) <= '1';
        wait for CLK_period * 5;
        BTN(2) <= '0';
        
        wait for CLK_period * 20;

        BTN(0) <= '1';
        wait for CLK_period * 5;
        BTN(0) <= '0';

        -- Let the simulation run to observe loops or timeouts
        wait for 1000 ns;
        
        -- Reset game from END_GAME ("11") -> IDLE ("00")
        BTN(3) <= '1';
        wait for CLK_period * 2;
        BTN(3) <= '0';

        wait;
    end process;

end behavior;
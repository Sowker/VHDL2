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

    -- Clock period definition (10 ns = 100 MHz)
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

    -- Clock process definitions
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
        -- 1. Initial State
        -- Hold the initial state for 100 ns to let the simulator settle.
        wait for 100 ns;	
        
        -- System is currently in IDLE ("00"). LED(3) should be high.
        wait for CLK_period * 10;

        -- 2. Start the Game
        -- Press START (BTN(3)) to transition to NEW_ROUND ("01")
        BTN(3) <= '1';
        wait for CLK_period * 2;
        BTN(3) <= '0';
        
        -- Wait for LFSR to generate a random value and transition to WAIT_RESPONSE ("10")
        wait for CLK_period * 20;

        -- 3. Simulate Gameplay
        -- Set difficulty level on switches
        SW <= "10"; 
        
        -- Simulate a user pressing a color button (e.g., Green: BTN(1))
        BTN(1) <= '1';
        wait for CLK_period * 2;
        BTN(1) <= '0';
        
        -- Wait a bit before next hit
        wait for CLK_period * 20;

        -- Simulate a user pressing another color button (e.g., Red: BTN(2))
        BTN(2) <= '1';
        wait for CLK_period * 2;
        BTN(2) <= '0';
        
        -- 4. Simulate Timeout / Game Over
        -- Wait a long time to allow the 'MinuteurCore' to reach its limit 
        -- and force the state machine into END_GAME ("11")
        wait for 1500 ns;
        
        -- 5. Reset the Game
        -- Press START (BTN(3)) again to return to IDLE ("00") from END_GAME
        BTN(3) <= '1';
        wait for CLK_period * 2;
        BTN(3) <= '0';

        -- End the simulation sequence
        wait;
    end process;

end behavior;
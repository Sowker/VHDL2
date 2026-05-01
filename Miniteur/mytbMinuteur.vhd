library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_MinuteurCore is
-- A testbench entity is always empty because it has no external inputs or outputs
end tb_MinuteurCore;

architecture behavior of tb_MinuteurCore is 

    -- 1. Component Declaration for the Unit Under Test (UUT)
    component MinuteurCore
    port(
         RESET    : in  std_logic;
         START    : in  std_logic;
         SW_LEVEL : in  std_logic_vector(3 downto 2);
         CLK      : in  std_logic;
         S        : out std_logic
        );
    end component;
    
    -- 2. Internal Signals to connect to the UUT
    -- Inputs initialized to '0'
    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal start    : std_logic := '0';
    signal sw_level : std_logic_vector(3 downto 2) := "00";

    -- Output
    signal s : std_logic;

    -- 3. Clock period definition (100 MHz = 10 ns period)
    constant clk_period : time := 10 ns;

begin

    -- 4. Instantiate the Unit Under Test (UUT)
    uut: MinuteurCore 
        port map (
          RESET    => reset,
          START    => start,
          SW_LEVEL => sw_level,
          CLK      => clk,
          S        => s
        );

    -- 5. Clock generation process
    -- This runs continuously in the background, toggling the clock every 5 ns
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 6. Stimulus process (The actual test script)
    stim_proc: process
    begin		
        -- Step A: Hold reset state for 100 ns to initialize the system
        reset <= '1';
        wait for 100 ns;	
        reset <= '0';
        
        -- Wait a few clock cycles before doing anything
        wait for clk_period*10;

        -- Step B: Set difficulty to "11" (Shortest time: 0.5 seconds)
        sw_level <= "11";
        wait for clk_period*2;

        -- Step C: Pulse the START signal for exactly one clock cycle
        start <= '1';
        wait for clk_period;
        start <= '0';

        -- Step D: Wait for the timer to finish
        -- Note: If you shrunk your counters to small numbers for testing, 
        -- change this wait time to something like "wait for 500 ns;"
        wait for 500.1 ms; 
        
        -- Step E: Stop the simulation
        std.env.stop;
        
    end process;

end behavior;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_LogiGameCore is
-- Empty entity for testbench
end tb_LogiGameCore;

architecture behavior of tb_LogiGameCore is 

    -- Component Declaration
    component LogiGameCore
    port(
         CLK       : in  std_logic;
         RESET     : in  std_logic;
         ENABLE    : in  std_logic;
         VALID_HIT : in  std_logic;
         SCORE     : out std_logic_vector(3 downto 0);
         GAME_OVER : out std_logic
        );
    end component;
    
    -- Internal Signals
    signal clk       : std_logic := '0';
    signal reset     : std_logic := '0';
    signal enable    : std_logic := '0';
    signal valid_hit : std_logic := '0';
    
    signal score     : std_logic_vector(3 downto 0);
    signal game_over : std_logic;

    -- Clock period definition (100 MHz = 10 ns)
    constant clk_period : time := 10 ns;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: LogiGameCore 
        port map (
          CLK       => clk,
          RESET     => reset,
          ENABLE    => enable,
          VALID_HIT => valid_hit,
          SCORE     => score,
          GAME_OVER => game_over
        );

    -- Clock generation process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Stimulus process (The Test Script)
    stim_proc: process
    begin		
        -- Step A: System Reset
        reset <= '1';
        enable <= '0';
        valid_hit <= '0';
        wait for 50 ns;	
        reset <= '0';
        wait for clk_period * 2;

        -----------------------------------------------------------
        -- TEST 1: A correct button press
        -----------------------------------------------------------
        valid_hit <= '1';
        enable <= '1'; -- Tell the counter to evaluate
        wait for clk_period; 
        enable <= '0'; -- Turn off evaluation
        valid_hit <= '0';
        
        -- The score should now be 1, and game_over should be 0.
        wait for clk_period * 5; 

        -----------------------------------------------------------
        -- TEST 2: A missed button press (Wrong answer or timeout)
        -----------------------------------------------------------
        valid_hit <= '0'; -- Wrong answer!
        enable <= '1';    -- Evaluate!
        wait for clk_period;
        enable <= '0';
        
        -- The game_over signal should now be locked at 1.
        wait for clk_period * 5;
        
        -----------------------------------------------------------
        -- TEST 3: Testing the Win Condition (Score = 15)
        -----------------------------------------------------------
        -- First, reset the game
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';
        wait for clk_period * 2;
        
        -- Loop 15 times to simulate 15 perfect hits in a row
        for i in 1 to 15 loop
            valid_hit <= '1';
            enable <= '1';
            wait for clk_period;
            enable <= '0';
            valid_hit <= '0';
            wait for clk_period * 2; -- wait between hits
        end loop;
        
        -- At this point, the score should be 15 ("1111") and Game Over should be 1.
        -- Let's try to score a 16th point to prove it ignores it.
        valid_hit <= '1';
        enable <= '1';
        wait for clk_period;
        enable <= '0';
        valid_hit <= '0';

        -- End the simulation
        wait for clk_period * 10;
        std.env.stop;
        
    end process;

end behavior;
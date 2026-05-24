library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_LFSRCore is
-- Empty entity for testbench
end tb_LFSRCore;

architecture behavior of tb_LFSRCore is 

    -- 1. Component Declaration for the Unit Under Test (UUT)
    component LFSRCore
    port(
         CLK    : in  std_logic;
         RESET  : in  std_logic;
         ENABLE : in  std_logic;
         RND    : out std_logic_vector(3 downto 0)
        );
    end component;
    
    -- 2. Internal Signals
    signal clk    : std_logic := '0';
    signal reset  : std_logic := '0';
    signal enable : std_logic := '0';
    signal rnd    : std_logic_vector(3 downto 0);

    -- 3. Clock period definition (100 MHz = 10 ns)
    constant clk_period : time := 10 ns;

begin

    -- 4. Instantiate the Unit Under Test (UUT)
    uut: LFSRCore 
        port map (
          CLK    => clk,
          RESET  => reset,
          ENABLE => enable,
          RND    => rnd
        );

    -- 5. Clock generation process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 6. Stimulus process (The test script)
    stim_proc: process
    begin		
        -- Step A: Assert reset (Initialize)
        reset <= '1';
        enable <= '0';
        wait for 100 ns;	
        
        -- Step B: De-assert reset 
        -- At this point, RND should output your starting value "1011"
        reset <= '0';
        wait for clk_period * 2;
        
        -- Step C: Turn on the ENABLE signal
        -- We will let it run for 20 clock cycles. 
        -- Since there are 15 unique states, you should see it complete a 
        -- full cycle and start repeating the same numbers again.
        enable <= '1';
        wait for clk_period * 20; 
        
        -- Step D: Turn off the ENABLE signal
        -- RND should freeze on its current value and stop shifting
        enable <= '0';
        wait for clk_period * 5;
        
        -- Step E: Stop the simulation
        std.env.stop;
        
    end process;

end behavior;
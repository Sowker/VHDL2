library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_MEM_CACHE is
-- A testbench entity is always empty
end tb_MEM_CACHE;

architecture behavior of tb_MEM_CACHE is

    -- 1. Component Declaration for the Unit Under Test (UUT)
    component MEM_CACHE
    Port (
        CLK     : in  std_logic;
        Entry   : in  std_logic_vector (127 downto 0);
        Sortie  : out std_logic_vector (127 downto 0);
        Sel_FCT : in  std_logic_vector (3 downto 0)
    );
    end component;

    -- 2. Testbench Signals
    signal CLK     : std_logic := '0';
    signal Entry   : std_logic_vector (127 downto 0) := (others => '0');
    signal Sel_FCT : std_logic_vector (3 downto 0) := (others => '0');
    
    -- Output signal doesn't need initialization
    signal Sortie  : std_logic_vector (127 downto 0);

    -- Clock period definition
    constant CLK_period : time := 10 ns;

begin

    -- 3. Instantiate the Unit Under Test (UUT)
    uut: MEM_CACHE PORT MAP (
        CLK     => CLK,
        Entry   => Entry,
        Sortie  => Sortie,
        Sel_FCT => Sel_FCT
    );

    -- 4. Clock Generation Process
    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    -- 5. Stimulus Process (Applying test cases)
    stim_proc: process
    begin
        -- Initial wait state
        wait for CLK_period * 2;

        -- TEST CASE 1: Write Operation
        -- Condition: Sel_FCT starts with "011" (e.g., "0110")
        -- We will load a recognizable 128-bit hex pattern
        Entry   <= x"DEADBEEFCAFEBABE1234567890ABCDEF"; 
        Sel_FCT <= "0110";
        wait for CLK_period;
        
        -- TEST CASE 2: Hold State
        -- Condition: Change the input, but set Sel_FCT to "0000"
        -- The cache should NOT overwrite the stored data, and Sortie shouldn't update yet
        Entry   <= x"11111111111111111111111111111111";
        Sel_FCT <= "0000";
        wait for CLK_period * 2;

        -- TEST CASE 3: Read Operation
        -- Condition: Sel_FCT MSB is '1' (e.g., "1000")
        -- The Sortie output should now display the DEADBEEF... pattern
        Sel_FCT <= "1000";
        wait for CLK_period * 2;
        
        -- TEST CASE 4: Write Operation with alternate Sel_FCT
        -- Condition: "0111" also satisfies the "011" condition
        Entry   <= x"FFFFFFFFFFFFFFFF0000000000000000";
        Sel_FCT <= "0111";
        wait for CLK_period;
        
        -- TEST CASE 5: Read Operation with alternate Sel_FCT
        -- Condition: "1111" satisfies MSB = '1'
        -- The Sortie output should now update to the FFFFFFFF... pattern
        Sel_FCT <= "1111"; 
        wait for CLK_period * 2;
        
        -- End of simulation
        wait;
    end process;

end behavior;
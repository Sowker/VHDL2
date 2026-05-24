library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_MinuteurCore is
-- Entité vide
end tb_MinuteurCore;

architecture behavior of tb_MinuteurCore is

    component MinuteurCore
    Port (
        RESET    : in std_logic;
        START    : in std_logic;
        SW_LEVEL : in std_logic_vector (3 downto 2);
        CLK      : in std_logic;
        S        : out std_logic
    );
    end component;

    signal CLK      : std_logic := '0';
    signal RESET    : std_logic := '0';
    signal START    : std_logic := '0';
    signal SW_LEVEL : std_logic_vector(3 downto 2) := "00";
    signal S        : std_logic;

    constant CLK_period : time := 10 ns;

begin

    uut: MinuteurCore PORT MAP (
        RESET    => RESET,
        START    => START,
        SW_LEVEL => SW_LEVEL,
        CLK      => CLK,
        S        => S
    );

    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    stim_proc: process
    begin
        -- 1. Initialisation
        RESET <= '1';
        wait for 30 ns;
        RESET <= '0';
        wait for 30 ns;

        -- Test 1 : Niveau "11" (5 cycles)
        SW_LEVEL <= "11";
        wait for CLK_period;
        START <= '1';
        wait for 5 * CLK_period; -- On attend le nombre exact de cycles
        wait for 2 * CLK_period; -- On attend 2 cycles de plus pour bien voir S rester à '1'
        START <= '0';            -- On relâche START, S doit repasser à '0'
        wait for 5 * CLK_period; 

        -- Test 2 : Niveau "10" (10 cycles)
        SW_LEVEL <= "10";
        wait for CLK_period;
        START <= '1';
        wait for 10 * CLK_period;
        wait for 2 * CLK_period;
        START <= '0';
        wait for 5 * CLK_period;

        -- Test 3 : Niveau "01" (20 cycles)
        SW_LEVEL <= "01";
        wait for CLK_period;
        START <= '1';
        wait for 20 * CLK_period;
        wait for 2 * CLK_period;
        START <= '0';
        wait for 5 * CLK_period;

        -- Test 4 : Niveau "00" (40 cycles)
        SW_LEVEL <= "00";
        wait for CLK_period;
        START <= '1';
        wait for 40 * CLK_period;
        wait for 2 * CLK_period;
        START <= '0';
        
        wait;
    end process;

end behavior;
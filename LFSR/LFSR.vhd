library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LFSRCore is 
    Port (
    CLK : in std_logic;
    RESET : in std_logic;
    ENABLE : in std_logic;
    RND : out std_logic_vector (3 downto 0)
    );
end LFSRCore;


architecture LFSRCore_Arch of LFSRCore is
    -- le LFSR est composé d'un diviseur de tension 
    -- D Flip FLop
    -- XOR opperation
    signal counter :integer range 0 to 5 := 0;  -- Here our signal is divised by 5 (maybe not good idk)
    signal FINALCLK : std_logic := '0';

begin
    MyDiviseurFreq_Proc : process(CLK)

    begin 
        if RESET = '1' then
            counter <= 0;
            FINALCLK <= '0';

        elsif rising_edge(CLK) then
            if counter = 5 then
                counter <= 0;
                FINALCLK <= not(FINALCLK);
            end if;
            counter <= counter + 1;
        end if;
    end;


    MyLFSRore_Proc : process (CLK, RESET, ENABLE)
    begin
        if RESET = '1' then
            RND <= "1010";
        elsif rising_edge(CLK) then
            if ENABLE = '1' then

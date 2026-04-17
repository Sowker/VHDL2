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

begin
    MyDiviseurFreq_Proc : process(CLK)
    variable : 
    begin 
        if rising_edge(CLK) then

    MyLFSRore_Proc : process (CLK, RESET, ENABLE)
    begin
        if RESET = '1' then
            RND <= "1010";
        elsif rising_edge(CLK) then
            if ENABLE = '1' then

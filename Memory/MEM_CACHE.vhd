library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MEM_CACHE is 
    Port (
        CLK : in  std_logic;
        Entry : in std_logic_vector (127 downto 0);
        Sel_FCT : in std_logic_vector (3 downto 0);
        Sortie : out std_logic_vector (127 downto 0)
    );
end MEM_CACHE;

architecture MEM_CACHE_Arch of MEM_CACHE is
    signal memory : std_logic_vector (127 downto 0):= (others => '0');  

begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if Sel_FCT(3 downto 1) = "011" then
                memory <= Entry;
            elsif Sel_FCT(3) = '1' then
                Sortie <= memory;
            end if;
        end if;
    end process;

end MEM_CACHE_Arch;
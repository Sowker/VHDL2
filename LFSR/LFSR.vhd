library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LFSRCore is 
    Port (
        CLK    : in  std_logic;
        RESET  : in  std_logic;
        ENABLE : in  std_logic;
        RND    : out std_logic_vector (3 downto 0)
    );
end LFSRCore;

architecture LFSRCore_Arch of LFSRCore is

    signal RNDinternal : std_logic_vector (3 downto 0) := "1011";

begin
    
    MyLFSRCore_Proc : process (CLK, RESET)
    begin
        if RESET = '1' then
            RNDinternal <= "1011"; -- Reset à "1011"
        elsif rising_edge(CLK) then
            if ENABLE = '1' then
                -- Décalage et calcul du nouveau bit (XOR entre bit 3 et bit 2)
                RNDinternal <= RNDinternal(2 downto 0) & (RNDinternal(3) xor RNDinternal(2));
            end if;
        end if;
    end process;

    RND <= RNDinternal;

end LFSRCore_Arch;
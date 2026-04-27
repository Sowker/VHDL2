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
    -- Le compteur va de 0 à 99999 (100 000 valeurs)
    signal counter     : integer range 0 to 99999 := 0;  
    signal FINALCLK    : std_logic := '0';
    
    -- Initialisation à "1010" comme demandé
    signal RNDinternal : std_logic_vector (3 downto 0) := "1010";
begin
    
    -- Processus 1 : Diviseur de Fréquence
    MyDiviseurFreq_Proc : process(CLK, RESET)
    begin 
        if RESET = '1' then
            counter <= 0;
            FINALCLK <= '0';
        elsif rising_edge(CLK) then
            if counter = 99999 then
                counter <= 0;
                FINALCLK <= not(FINALCLK);
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Processus 2 : Coeur du LFSR
    MyLFSRCore_Proc : process (FINALCLK, RESET)
    begin
        if RESET = '1' then
            RNDinternal <= "1010"; -- Reset à "1010"
        elsif rising_edge(FINALCLK) then
            if ENABLE = '1' then
                -- Décalage et calcul du nouveau bit (XOR entre bit 3 et bit 2)
                RNDinternal <= RNDinternal(2 downto 0) & (RNDinternal(3) xor RNDinternal(2));
            end if;
        end if;
    end process;

    RND <= RNDinternal;

end LFSRCore_Arch;
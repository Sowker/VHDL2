library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DiviseurCore is 
    Port (
        CLK : in  std_logic;
        RESET : in  std_logic;
        FINALCLK : out std_logic   
    );
end DiviseurCore;

architecture DiviseurCore_Arch of DiviseurCore is
    
    signal counter : integer range 0 to 99999 := 0;  
    signal finalclk_int : std_logic := '0'; 
    
begin
    
    MyDiviseurFreq_Proc : process(CLK, RESET)
    begin 
        if RESET = '1' then
            counter <= 0;
            finalclk_int <= '0';
        elsif rising_edge(CLK) then
            if counter = 99999 then
                counter <= 0;
                finalclk_int <= not(finalclk_int);
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    FINALCLK <= finalclk_int;

end DiviseurCore_Arch;
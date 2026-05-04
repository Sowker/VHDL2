library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MinuteurCore is 
    Port (
        RESET : in std_logic;
        START : in std_logic;
        SW_LEVEL : in std_logic_vector (3 downto 2);
        CLK : in std_logic;  -- 100MHz
        S : out std_logic -- booléan passe à '1' lorsque le délai programmé est atteint
    );
end MinuteurCore;

architecture MinuteurCore_Arch of MinuteurCore is
    signal counter : integer range 0 to 400000000 := 0;

begin
    MyTimeOut_Proc : process (CLK, RESET, START, SW_LEVEL)
    begin 
        if RESET = '1' then
            counter <= 0;
            S <= '0';
        elsif rising_edge(CLK) then
            if START = '1' then
                counter <= counter + 1;
                
                if SW_LEVEL = "00" then
                    if counter = 400000000 then
                        S <= '1';
                    end if;
                elsif SW_LEVEL = "01" then
                    if counter = 200000000 then
                        S <= '1';
                    end if;
                elsif SW_LEVEL = "10" then
                    if counter = 100000000 then
                        S <= '1';
                    end if;
                elsif SW_LEVEL = "11" then
                    if counter = 50000000 then
                        S <= '1';
                    end if;
                end if;
                
            else
                counter <= 0;
                S <= '0';
            end if;
        end if;
    end process;

end MinuteurCore_Arch;
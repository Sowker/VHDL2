library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LogiGameCore is 
    Port (
        CLK : in std_logic;
        RESET : in std_logic;
        ENABLE : in std_logic;
        VALID_HIT : in std_logic;
        SCORE : out std_logic_vector (3 downto 0);
        GAME_OVER : out std_logic
    );
end LogiGameCore;

architecture LogiGameCore_Arch of LogiGameCore is
    signal finish : std_logic := '0';
    signal score_reg : unsigned(3 downto 0) := "0000"; 

begin 
    Score_Proc : process (CLK, RESET)
    begin
        if RESET = '1' then
            score_reg <= "0000";
            finish <= '0';

        elsif rising_edge(CLK) then
            if finish = '0' then
                
                -- Only judge the player when ENABLE is pulsed because for the first
                -- rising edge if the player don't react it will goes false
                if ENABLE = '1' then 
                    if VALID_HIT = '1' then
                        if score_reg = 15 then 
                            finish <= '1';
                        else
                            score_reg <= score_reg + 1;
                        end if;
                    elsif VALID_HIT = '0' then
                        finish <= '1'; 
                    end if; 
                end if;   
            end if;
        end if;
    end process;

    SCORE <= std_logic_vector(score_reg);
    GAME_OVER <= finish;

end LogiGameCore_Arch;
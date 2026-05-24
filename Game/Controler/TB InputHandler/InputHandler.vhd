library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InputHandler is 
    Port (
        CLK       : in std_logic;
        RESET     : in std_logic;
        TIMEOUT   : in std_logic;
        LED_COLOR : in std_logic_vector (2 downto 0);
        BTN_R     : in std_logic;
        BTN_G     : in std_logic;
        BTN_B     : in std_logic;
        VALID_HIT : out std_logic := '0'
    );
end InputHandler;

architecture InputHandler_Arch of InputHandler is
    signal user_pressed : std_logic := '0';

begin
    Handle_proc : process (CLK)
    begin 
        if rising_edge(CLK) then
            if RESET = '1' then
                VALID_HIT <= '0';
                user_pressed <= '0';
            else
                if user_pressed = '0' and TIMEOUT = '0' then
                    
                    if BTN_R = '1' or BTN_G = '1' or BTN_B = '1' then
                        
                        user_pressed <= '1'; 
                        if LED_COLOR = "100" and BTN_R = '1' then
                            VALID_HIT <= '1';
                        elsif LED_COLOR = "010" and BTN_G = '1' then
                            VALID_HIT <= '1';
                        elsif LED_COLOR = "001" and BTN_B = '1' then
                            VALID_HIT <= '1';
                        else 
                            VALID_HIT <= '0';
                        end if;
                        
                    end if;
                    
                end if;
            end if;
        end if;
    end process;
end InputHandler_Arch;
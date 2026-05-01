library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ControlerCore is 
    Port (
        CLK : in std_logic;
        BTN : in std_logic_vector (3 downto 0);
        SW : in std_logic_vector (3 downto 2);
        LED : out std_logic_vector (3 downto 0);
        LED_R : out; -- LED
        LED_G : out;
        LED_B : out;
    );
end ControlerCore;

architecture ControlerCore_Arch of ControlerCore is

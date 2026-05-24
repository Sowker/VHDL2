library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Level_LogiGame is
    Port (
        CLK100MHZ : in  std_logic;
        btn       : in  std_logic_vector(3 downto 0);
        sw        : in  std_logic_vector(3 downto 0); -- Mis à 4 bits pour la carte ARTY
        led       : out std_logic_vector(3 downto 0);
        led3_r    : out std_logic;
        led3_g    : out std_logic;
        led3_b    : out std_logic
    );
end Top_Level_LogiGame;

architecture Structural of Top_Level_LogiGame is

    -- Déclaration EXACTE de ton entité présente dans Controler.vhd
    component ControlerCore
        Port (
            CLK   : in std_logic;
            BTN   : in std_logic_vector (3 downto 0);
            SW    : in std_logic_vector (3 downto 2);
            LED   : out std_logic_vector (3 downto 0);
            LED_R : out std_logic; 
            LED_G : out std_logic;
            LED_B : out std_logic
        );
    end component;

begin

    -- Câblage (Port Map) entre les broches de la carte et ton composant ControlerCore
    Inst_ControlerCore: ControlerCore port map (
        CLK   => CLK100MHZ,
        BTN   => btn,
        SW    => sw(3 downto 2), -- On connecte uniquement les switchs 2 et 3
        LED   => led,
        LED_R => led3_r,
        LED_G => led3_g,
        LED_B => led3_b
    );

end Structural;

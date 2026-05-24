library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ControlerCore is
-- Entité vide
end tb_ControlerCore;

architecture behavior of tb_ControlerCore is

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

    signal CLK : std_logic := '0';
    signal BTN : std_logic_vector(3 downto 0) := "0000";
    
    -- On force le niveau "11", ce qui correspond à tes 5 cycles
    signal SW  : std_logic_vector(3 downto 2) := "11"; 

    signal LED   : std_logic_vector(3 downto 0);
    signal LED_R : std_logic;
    signal LED_G : std_logic;
    signal LED_B : std_logic;

    constant CLK_period : time := 10 ns;

    procedure get_led_color(
        signal r : in std_logic;
        signal g : in std_logic;
        signal b : in std_logic;
        variable color_val : out std_logic_vector(2 downto 0)
    ) is
    begin
        color_val := r & g & b;
    end procedure;

begin

    uut: ControlerCore PORT MAP (
        CLK => CLK,
        BTN => BTN,
        SW => SW,
        LED => LED,
        LED_R => LED_R,
        LED_G => LED_G,
        LED_B => LED_B
    );

    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    stim_proc: process
        variable current_color : std_logic_vector(2 downto 0);
    begin
        wait for 50 ns;

        -- =========================================================
        -- SCÉNARIO 1 : Score de 3, puis erreur (mauvais bouton)
        -- =========================================================
        
        BTN(3) <= '1';
        wait for 20 ns;
        BTN(3) <= '0';
        
        for i in 1 to 3 loop
            wait until (LED_R = '1' or LED_G = '1' or LED_B = '1');
            wait for 2 * CLK_period; 
            
            get_led_color(LED_R, LED_G, LED_B, current_color);
            
            if current_color = "100" then BTN(2) <= '1';
            elsif current_color = "010" then BTN(1) <= '1';
            elsif current_color = "001" then BTN(0) <= '1';
            end if;
            
            wait for 2 * CLK_period;
            BTN(2) <= '0'; BTN(1) <= '0'; BTN(0) <= '0';
        end loop;

        -- 4ème round : Le joueur appuie sur le mauvais bouton
        wait until (LED_R = '1' or LED_G = '1' or LED_B = '1');
        wait for 2 * CLK_period;
        
        get_led_color(LED_R, LED_G, LED_B, current_color);
        
        if current_color = "100" then
            BTN(1) <= '1'; -- Erreur volontaire
        else
            BTN(2) <= '1'; -- Erreur volontaire
        end if;
        
        wait for 2 * CLK_period;
        BTN(2) <= '0'; BTN(1) <= '0'; BTN(0) <= '0';
        
        -- Le jeu est maintenant verrouillé en END_GAME
        wait for 50 ns;

        -- =========================================================
        -- SCÉNARIO 2 : Relance, Score de 5, puis Timeout
        -- =========================================================

        -- Reset du jeu vers IDLE
        BTN(3) <= '1';
        wait for 20 ns;
        BTN(3) <= '0';
        wait for 20 ns;
        
        -- Lancement d'une nouvelle partie
        BTN(3) <= '1';
        wait for 20 ns;
        BTN(3) <= '0';

        -- 5 bonnes réponses
        for i in 1 to 5 loop
            wait until (LED_R = '1' or LED_G = '1' or LED_B = '1');
            wait for 2 * CLK_period;
            
            get_led_color(LED_R, LED_G, LED_B, current_color);
            
            if current_color = "100" then BTN(2) <= '1';
            elsif current_color = "010" then BTN(1) <= '1';
            elsif current_color = "001" then BTN(0) <= '1';
            end if;
            
            wait for 2 * CLK_period;
            BTN(2) <= '0'; BTN(1) <= '0'; BTN(0) <= '0';
        end loop;

        -- 6ème round : On teste ton timeout de 5 cycles !
        wait until (LED_R = '1' or LED_G = '1' or LED_B = '1');
        
        -- On ne presse aucun bouton.
        -- On attend 7 cycles (les 5 cycles de ton minuteur + 2 cycles de marge 
        -- pour laisser l'automate transiter vers END_GAME).
        wait for 7 * CLK_period; 
        
        -- La simulation reste un peu pour observer le résultat final
        wait for 50 ns;
        
        wait;
    end process;

end behavior;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_InputHandler is
-- Entité vide pour un testbench
end tb_InputHandler;

architecture behavior of tb_InputHandler is

    -- Déclaration du composant à tester (UUT)
    component InputHandler
    Port (
        CLK       : in std_logic;
        RESET     : in std_logic;
        TIMEOUT   : in std_logic;
        LED_COLOR : in std_logic_vector (2 downto 0);
        BTN_R     : in std_logic;
        BTN_G     : in std_logic;
        BTN_B     : in std_logic;
        VALID_HIT : out std_logic
    );
    end component;

    -- Signaux d'entrée
    signal CLK       : std_logic := '0';
    signal RESET     : std_logic := '0';
    signal TIMEOUT   : std_logic := '0';
    signal LED_COLOR : std_logic_vector(2 downto 0) := "000";
    signal BTN_R     : std_logic := '0';
    signal BTN_G     : std_logic := '0';
    signal BTN_B     : std_logic := '0';

    -- Signaux de sortie
    signal VALID_HIT : std_logic;

    -- Définition de la période d'horloge (100 MHz)
    constant CLK_period : time := 10 ns;

begin

    -- Instanciation du composant (UUT)
    uut: InputHandler PORT MAP (
        CLK => CLK,
        RESET => RESET,
        TIMEOUT => TIMEOUT,
        LED_COLOR => LED_COLOR,
        BTN_R => BTN_R,
        BTN_G => BTN_G,
        BTN_B => BTN_B,
        VALID_HIT => VALID_HIT
    );

    -- Processus de génération de l'horloge
    CLK_process :process
    begin
        CLK <= '0';
        wait for CLK_period/2;
        CLK <= '1';
        wait for CLK_period/2;
    end process;

    -- Processus de simulation (Stimuli)
    stim_proc: process
    begin
        -- Initialisation et Reset global
        RESET <= '1';
        wait for 20 ns;
        RESET <= '0';
        wait for 20 ns;

        -- Test 1 : Bonne réponse (Bouton Rouge / LED Rouge)
        LED_COLOR <= "100";
        BTN_R <= '1';
        wait for CLK_period;
        BTN_R <= '0';
        wait for 40 ns;

        -- Reset du module pour le prochain test
        RESET <= '1'; wait for CLK_period; RESET <= '0';

        -- Test 2 : Mauvaise réponse (Bouton Vert / LED Rouge)
        LED_COLOR <= "100";
        BTN_G <= '1';
        wait for CLK_period;
        BTN_G <= '0';
        wait for 40 ns;

        -- Reset
        RESET <= '1'; wait for CLK_period; RESET <= '0';

        -- Test 3 : Bonne réponse (Bouton Bleu / LED Bleue)
        LED_COLOR <= "001";
        BTN_B <= '1';
        wait for CLK_period;
        BTN_B <= '0';
        wait for 40 ns;

        -- Reset
        RESET <= '1'; wait for CLK_period; RESET <= '0';

        -- Test 4 : Timeout (Le joueur appuie trop tard)
        LED_COLOR <= "010";
        TIMEOUT <= '1'; -- Le temps est écoulé
        wait for CLK_period;
        BTN_G <= '1';   -- Le joueur appuie sur le bon bouton (Vert)
        wait for CLK_period;
        BTN_G <= '0';
        TIMEOUT <= '0';
        wait for 40 ns;

        -- Reset
        RESET <= '1'; wait for CLK_period; RESET <= '0';

        -- Test 5 : Vérification du blocage anti-triche (Mauvais bouton puis bon bouton)
        LED_COLOR <= "010";
        BTN_R <= '1';   -- Mauvais bouton (Rouge)
        wait for CLK_period;
        BTN_R <= '0';
        BTN_G <= '1';   -- Bon bouton (Vert), mais le module doit l'ignorer
        wait for CLK_period;
        BTN_G <= '0';
        
        -- Fin de la simulation
        wait;
    end process;

end behavior;
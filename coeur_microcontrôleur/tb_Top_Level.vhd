library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Top_Level is
-- Un testbench n'a pas de ports
end tb_Top_Level;

architecture behavior of tb_Top_Level is

    -- 1. Déclaration du composant principal (Top Level)
    component Top_Level
        Port (
            CLK         : in  std_logic;
            RESET       : in  std_logic;
            A_IN        : in  std_logic_vector(3 downto 0);
            B_IN        : in  std_logic_vector(3 downto 0);
            BTN_1       : in  std_logic;
            BTN_2       : in  std_logic;
            BTN_3       : in  std_logic;
            SR_OUT_L    : out std_logic;
            SR_OUT_R    : out std_logic;
            RES_OUT     : out std_logic_vector(7 downto 0);
            DONE        : out std_logic 
        );
    end component;

    -- 2. Signaux d'entrée générés par le testbench
    signal tb_CLK   : std_logic := '0';
    signal tb_RESET : std_logic := '0';
    signal tb_A_IN  : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_B_IN  : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_BTN_1 : std_logic := '0';
    signal tb_BTN_2 : std_logic := '0';
    signal tb_BTN_3 : std_logic := '0';

    -- 3. Signaux de sortie observés
    signal tb_SR_OUT_L : std_logic;
    signal tb_SR_OUT_R : std_logic;
    signal tb_RES_OUT  : std_logic_vector(7 downto 0);
    signal tb_DONE     : std_logic;

    -- Période de l'horloge correspondant à la carte ARTY (100 MHz -> 10 ns)
    constant CLK_PERIOD : time := 10 ns; 

begin

    -- Instanciation du Top Level
    uut: Top_Level port map (
        CLK      => tb_CLK,
        RESET    => tb_RESET,
        A_IN     => tb_A_IN,
        B_IN     => tb_B_IN,
        BTN_1    => tb_BTN_1,
        BTN_2    => tb_BTN_2,
        BTN_3    => tb_BTN_3,
        SR_OUT_L => tb_SR_OUT_L,
        SR_OUT_R => tb_SR_OUT_R,
        RES_OUT  => tb_RES_OUT,
        DONE     => tb_DONE
    );

    -- Processus de génération de l'horloge
    clk_proc: process
    begin
        tb_CLK <= '0';
        wait for CLK_PERIOD/2;
        tb_CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- Processus de génération des stimulus (simulation des actions utilisateur)
    stim_proc: process
    begin
        -- Initialisation système (Reset global)
        tb_RESET <= '1';
        wait for CLK_PERIOD * 5;
        tb_RESET <= '0';
        wait for CLK_PERIOD * 5;

        -- =========================================================
        -- TEST 1 : Lancement de l'Automate 1 (Multiplication A * B)
        -- =========================================================
        tb_A_IN <= "0011"; -- 3 en décimal
        tb_B_IN <= "0100"; -- 4 en décimal
        wait for CLK_PERIOD;
        
        -- Simulation de l'appui sur le bouton 1
        tb_BTN_1 <= '1'; 
        wait for CLK_PERIOD * 2;
        tb_BTN_1 <= '0';
        
        -- On attend de manière dynamique que le processeur finisse (Automate 1 -> 4 cycles)
        wait until tb_DONE = '1';
        wait for CLK_PERIOD * 10; 
        -- Résultat attendu sur tb_RES_OUT : 12 ("00001100")

        -- Reset avant le prochain test (simule le bouton btn(0) de la carte)
        tb_RESET <= '1';
        wait for CLK_PERIOD * 5;
        tb_RESET <= '0';
        wait for CLK_PERIOD * 5;

        -- =========================================================
        -- TEST 2 : Lancement de l'Automate 2 ((A + B) XNOR A)
        -- =========================================================
        tb_A_IN <= "0101"; -- 5
        tb_B_IN <= "0011"; -- 3
        wait for CLK_PERIOD;
        
        -- Simulation de l'appui sur le bouton 2
        tb_BTN_2 <= '1'; 
        wait for CLK_PERIOD * 2;
        tb_BTN_2 <= '0';
        
        -- On attend la fin de l'Automate 2 (8 cycles)
        wait until tb_DONE = '1';
        wait for CLK_PERIOD * 10;
        -- Calcul : A+B = 8 ("1000"). A = 5 ("0101"). 
        -- 1000 XNOR 0101 -> NOT(1000 XOR 0101) = NOT(1101) = "0010" (2 en décimal)
        -- Résultat attendu sur tb_RES_OUT : "00000010"

        -- Reset avant le prochain test
        tb_RESET <= '1';
        wait for CLK_PERIOD * 5;
        tb_RESET <= '0';
        wait for CLK_PERIOD * 5;

        -- =========================================================
        -- TEST 3 : Lancement de l'Automate 3 (A0.B1 + A1.B0)
        -- =========================================================
        tb_A_IN <= "0011"; -- A0 = 1, A1 = 1
        tb_B_IN <= "0010"; -- B0 = 0, B1 = 1
        -- Formule : (1 AND 1) OR (1 AND 0) = 1 OR 0 = 1
        wait for CLK_PERIOD;
        
        -- Simulation de l'appui sur le bouton 3
        tb_BTN_3 <= '1'; 
        wait for CLK_PERIOD * 2;
        tb_BTN_3 <= '0';
        
        -- On attend la fin de l'Automate 3 (Complexe, plus de 15 cycles)
        wait until tb_DONE = '1';
        wait for CLK_PERIOD * 10;
        -- Résultat attendu sur tb_RES_OUT : "00000001"

        -- Fin de la simulation
        wait;
    end process;

end behavior;
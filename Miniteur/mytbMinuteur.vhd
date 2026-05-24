library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_MinuteurCore is
-- Entité vide pour le testbench
end tb_MinuteurCore;

architecture behavior of tb_MinuteurCore is

    -- Déclaration de ton composant (UUT - Unit Under Test)
    component MinuteurCore
    Port (
        RESET    : in std_logic;
        START    : in std_logic;
        SW_LEVEL : in std_logic_vector (3 downto 2);
        CLK      : in std_logic;
        S        : out std_logic
    );
    end component;

    -- Signaux d'entrée pour piloter l'UUT
    signal CLK      : std_logic := '0';
    signal RESET    : std_logic := '0';
    signal START    : std_logic := '0';
    signal SW_LEVEL : std_logic_vector(3 downto 2) := "00";

    -- Signal de sortie pour observer l'UUT
    signal S        : std_logic;

    -- Période de l'horloge à 100 MHz (10 ns)
    constant CLK_period : time := 10 ns;

begin

    -- Instanciation de ton composant
    uut: MinuteurCore PORT MAP (
        RESET    => RESET,
        START    => START,
        SW_LEVEL => SW_LEVEL,
        CLK      => CLK,
        S        => S
    );

    -- Processus de génération de l'horloge (100 MHz)
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
        -- 1. Phase d'initialisation et Reset
        RESET <= '1';
        wait for 50 ns;
        RESET <= '0';
        wait for 50 ns;

        -- 2. Test avec le niveau de difficulté "11" (50 000 000 cycles)
        SW_LEVEL <= "11";
        wait for CLK_period;
        
        -- Démarrage du minuteur
        -- Remarque : Ton code exige que START reste à '1' pour continuer à compter.
        START <= '1';
        
        -- Attente de la fin du décompte. 
        -- 50 000 000 cycles * 10 ns = 500 ms.
        wait for 500 ms; 
        
        -- Laisse un peu de marge pour observer le signal S passer à '1'
        wait for 100 ns;

        -- Relâchement de START (ton code va remettre le compteur et S à 0)
        START <= '0';
        wait for 100 ns;

        -- 3. Reset du système avant un éventuel autre test
        RESET <= '1';
        wait for 50 ns;
        RESET <= '0';
        wait for 50 ns;

        -- Fin de la simulation
        wait;
    end process;

end behavior;
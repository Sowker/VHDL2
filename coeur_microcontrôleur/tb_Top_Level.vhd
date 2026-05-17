library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Top_Level is
-- Un testbench est toujours vide
end tb_Top_Level;

architecture Behavioral of tb_Top_Level is

    -- 1. Déclaration du Top_Level (Unité Sous Test)
    component Top_Level
        Port (
            CLK         : in  std_logic;
            RESET       : in  std_logic;
            A_IN        : in  std_logic_vector(3 downto 0);
            B_IN        : in  std_logic_vector(3 downto 0);
            RES_OUT     : out std_logic_vector(7 downto 0);
            DONE        : out std_logic
        );
    end component;

    -- 2. Signaux internes
    signal clk     : std_logic := '0';
    signal reset   : std_logic := '0';
    signal a_in    : std_logic_vector(3 downto 0) := "0000";
    signal b_in    : std_logic_vector(3 downto 0) := "0000";
    signal res_out : std_logic_vector(7 downto 0);
    signal done    : std_logic;

    -- Période de 10 ns = 100 MHz (Fréquence de la carte ARTY)
    constant clk_period : time := 10 ns;

begin

    -- 3. Instanciation
    UUT: Top_Level port map (
        CLK     => clk,
        RESET   => reset,
        A_IN    => a_in,
        B_IN    => b_in,
        RES_OUT => res_out,
        DONE    => done
    );

    -- 4. Générateur d'horloge infini
    clk_process : process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- 5. Scénario de test
    stim_proc: process
    begin
        report "=== DEBUT DE LA SIMULATION DU MICROCONTROLEUR ===" severity note;

        -- INITIALISATION ET RESET
        -- On fixe les valeurs de test : A = 6 et B = 3
        a_in <= "1111"; -- 6 en décimal
        b_in <= "1111"; -- 3 en décimal
        
        -- On applique le Reset pour vider les caches et mettre le PC à 0
        reset <= '1';
        wait for clk_period * 2;
        reset <= '0';
        
        -- À partir de cet instant exact, le Reset est relâché.
        -- Le PC de la ROM commence à s'incrémenter à chaque cycle d'horloge
        -- et va lire les instructions de 0 jusqu'à 127 automatiquement.

        -- ========================================================
        -- TEST AUTOMATE 1 : Multiplication (A * B)
        -- Instructions ROM : 0 à 3 (prend 4 cycles d'horloge)
        -- Calcul attendu : 6 * 3 = 18 
        -- En binaire : 18 = 0001 0010
        -- ========================================================
        -- TEST AUTOMATE 1
        wait for clk_period * 6; -- On attend d'être en plein dans la pause !
        report ">> AUTOMATE 1 TERMINE. Observez RES_OUT : il doit valoir 18 (00010010)" severity note;
        
        -- TEST AUTOMATE 2
        wait for clk_period * 12; -- On attend la pause de l'automate 2
        report ">> AUTOMATE 2 TERMINE. Observez RES_OUT : il doit valoir 0 (00000000)" severity note;

        -- TEST AUTOMATE 3
        wait for clk_period * 22; -- On attend la fin de l'automate 3
        report ">> AUTOMATE 3 TERMINE. Observez RES_OUT : il doit valoir 1 (00000001)" severity note;

        -- ========================================================
        -- FIN DES INSTRUCTIONS UTILES
        -- ========================================================
        -- Le reste de la ROM (25 à 127) contient des "nop" et SEL_OUT = "00".
        -- La sortie RES_OUT doit donc s'éteindre et repasser à 0.
        wait for clk_period * 5;
        report ">> PASSAGE EN ZONE VIDE (NOP). RES_OUT doit etre retourne a 0." severity note;
        
        report "=== FIN DE LA SIMULATION ===" severity note;
        
        -- Stoppe la simulation
        wait;
    end process;

end Behavioral;
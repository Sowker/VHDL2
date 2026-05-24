library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_LFSR_MCU is
-- Un testbench n'a pas de port
end tb_LFSR_MCU;

architecture behavior of tb_LFSR_MCU is

    -- Déclaration du composant à tester (Notre nouveau Wrapper LFSR)
    component LFSR_MCU
        Port (
            CLK    : in  std_logic;
            RESET  : in  std_logic;
            ENABLE : in  std_logic;
            RND    : out std_logic_vector (3 downto 0)
        );
    end component;

    -- Signaux internes
    signal tb_clk   : std_logic := '0';
    signal tb_reset : std_logic := '0';
    signal tb_en    : std_logic := '0';
    signal tb_rnd   : std_logic_vector(3 downto 0);

    -- Horloge à 100MHz (comme sur la carte ARTY)
    constant clk_period : time := 10 ns;

begin

    -- Instanciation du LFSR_MCU
    uut: LFSR_MCU port map (
        CLK    => tb_clk,
        RESET  => tb_reset,
        ENABLE => tb_en,
        RND    => tb_rnd
    );

    -- Processus de génération de l'horloge
    clk_process :process
    begin
        tb_clk <= '0';
        wait for clk_period/2;
        tb_clk <= '1';
        wait for clk_period/2;
    end process;

    -- Processus de test
    stim_proc: process
    begin
        -- 1. Initialisation et Reset
        tb_reset <= '1';
        wait for 30 ns;
        tb_reset <= '0';
        wait for 30 ns;
        -- À ce stade, tb_rnd doit être à "1011" (Valeur par défaut)

        -- 2. Demande du 1er nombre aléatoire
        tb_en <= '1';
        wait for clk_period; -- On simule l'impulsion de 1 cycle envoyée par le jeu
        tb_en <= '0';
        -- On attend que le MCU finisse son calcul (9 cycles d'horloge = 90 ns)
        wait for 150 ns; 
        -- Résultat attendu : 1011 -> XOR(1,0)=1 -> 0111 (7)

        -- 3. Demande du 2ème nombre aléatoire
        tb_en <= '1';
        wait for clk_period;
        tb_en <= '0';
        wait for 150 ns;
        -- Résultat attendu : 0111 -> XOR(0,1)=1 -> 1111 (F)

        -- 4. Demande du 3ème nombre aléatoire
        tb_en <= '1';
        wait for clk_period;
        tb_en <= '0';
        wait for 150 ns;
        -- Résultat attendu : 1111 -> XOR(1,1)=0 -> 1110 (E)

        -- 5. Demande du 4ème nombre aléatoire
        tb_en <= '1';
        wait for clk_period;
        tb_en <= '0';
        wait for 150 ns;
        -- Résultat attendu : 1110 (E) -> XOR(1,1)=0 -> 1100 (C)

        -- Fin de simulation
        wait;
    end process;

end behavior;
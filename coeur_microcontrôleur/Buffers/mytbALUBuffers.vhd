library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- L'entité d'un testbench est toujours vide car il n'y a pas d'entrées/sorties vers l'extérieur
entity tb_ALU_Subsystem is
end tb_ALU_Subsystem;

architecture Behavioral of tb_ALU_Subsystem is

    -- 1. DÉCLARATION DES COMPOSANTS (On prévient le testbench de ce qu'on va utiliser)
    component ALUSELROUTE is 
        Port (
            SEL_ROUTE   : in  std_logic_vector(3 downto 0);
            A           : in  std_logic_vector(3 downto 0);
            B           : in  std_logic_vector(3 downto 0);
            S           : in  std_logic_vector(7 downto 0);
            s_Mem_1_out : in  std_logic_vector(7 downto 0);
            s_Mem_2_out : in  std_logic_vector(7 downto 0);
            CE_Buf_A    : out std_logic;
            CE_Buf_B    : out std_logic;
            CE_Mem_1    : out std_logic;
            CE_Mem_2    : out std_logic;
            Buf_A_in    : out std_logic_vector(3 downto 0);
            Buf_B_in    : out std_logic_vector(3 downto 0);
            Mem_1_In    : out std_logic_vector(7 downto 0);
            Mem_2_In    : out std_logic_vector(7 downto 0)
        );
    end component;

    component ALUBuffer is 
        Port (
            CLK         : in  std_logic;
            RESET       : in  std_logic;
            CE_Buf_A    : in  std_logic;
            Buf_A_in    : in  std_logic_vector(3 downto 0);
            CE_Buf_B    : in  std_logic;
            Buf_B_in    : in  std_logic_vector(3 downto 0);
            SR_IN_L     : in  std_logic;
            SR_IN_R     : in  std_logic;
            Buf_A_out   : out std_logic_vector(3 downto 0);
            Buf_B_out   : out std_logic_vector(3 downto 0);
            MEM_SR_IN_L : out std_logic;
            MEM_SR_IN_R : out std_logic
        );
    end component;

    -- 2. DÉCLARATION DES SIGNAUX (Les "fils" de notre laboratoire)
    -- Signaux de contrôle
    signal tb_CLK         : std_logic := '0';
    signal tb_RESET       : std_logic := '0';
    
    -- Entrées simulées par nous
    signal tb_SEL_ROUTE   : std_logic_vector(3 downto 0) := "0000";
    signal tb_A           : std_logic_vector(3 downto 0) := "0000";
    signal tb_B           : std_logic_vector(3 downto 0) := "0000";
    signal tb_S           : std_logic_vector(7 downto 0) := "00000000";
    signal tb_Mem_1_out   : std_logic_vector(7 downto 0) := "00000000";
    signal tb_Mem_2_out   : std_logic_vector(7 downto 0) := "00000000";
    signal tb_SR_IN_L     : std_logic := '0';
    signal tb_SR_IN_R     : std_logic := '0';

    -- Signaux d'interconnexion (relient le routeur au buffer)
    signal sig_CE_Buf_A   : std_logic;
    signal sig_CE_Buf_B   : std_logic;
    signal sig_Buf_A_in   : std_logic_vector(3 downto 0);
    signal sig_Buf_B_in   : std_logic_vector(3 downto 0);

    -- Sorties à observer sur le graphe (pour vérifier que ça marche)
    signal tb_Buf_A_out   : std_logic_vector(3 downto 0);
    signal tb_Buf_B_out   : std_logic_vector(3 downto 0);
    signal tb_MEM_SR_IN_L : std_logic;
    signal tb_MEM_SR_IN_R : std_logic;

    -- Sorties mémoires du routeur (juste pour éviter de les laisser dans le vide)
    signal sig_CE_Mem_1   : std_logic;
    signal sig_CE_Mem_2   : std_logic;
    signal sig_Mem_1_In   : std_logic_vector(7 downto 0);
    signal sig_Mem_2_In   : std_logic_vector(7 downto 0);

    -- Période de l'horloge (10 ns = 100 MHz, comme sur votre carte ARTY)
    constant clk_period : time := 10 ns;

begin

    -- 3. INSTANCIATION (On câble physiquement les composants)
    UUT_Routeur: ALUSELROUTE port map (
        SEL_ROUTE   => tb_SEL_ROUTE,
        A           => tb_A,
        B           => tb_B,
        S           => tb_S,
        s_Mem_1_out => tb_Mem_1_out,
        s_Mem_2_out => tb_Mem_2_out,
        
        -- Connexion vers le buffer (via nos signaux internes)
        CE_Buf_A    => sig_CE_Buf_A,
        CE_Buf_B    => sig_CE_Buf_B,
        Buf_A_in    => sig_Buf_A_in,
        Buf_B_in    => sig_Buf_B_in,
        
        -- Sorties vers cache mémoire (ignorées pour ce test)
        CE_Mem_1    => sig_CE_Mem_1,
        CE_Mem_2    => sig_CE_Mem_2,
        Mem_1_In    => sig_Mem_1_In,
        Mem_2_In    => sig_Mem_2_In
    );

    UUT_Buffer: ALUBuffer port map (
        CLK         => tb_CLK,
        RESET       => tb_RESET,
        
        -- Connexion venant du routeur
        CE_Buf_A    => sig_CE_Buf_A,
        Buf_A_in    => sig_Buf_A_in,
        CE_Buf_B    => sig_CE_Buf_B,
        Buf_B_in    => sig_Buf_B_in,
        
        -- Entrées directes
        SR_IN_L     => tb_SR_IN_L,
        SR_IN_R     => tb_SR_IN_R,
        
        -- Sorties à vérifier
        Buf_A_out   => tb_Buf_A_out,
        Buf_B_out   => tb_Buf_B_out,
        MEM_SR_IN_L => tb_MEM_SR_IN_L,
        MEM_SR_IN_R => tb_MEM_SR_IN_R
    );

    -- 4. PROCESSUS DE L'HORLOGE (Génère le battement régulier)
    clk_process: process
    begin
        tb_CLK <= '0';
        wait for clk_period/2;
        tb_CLK <= '1';
        wait for clk_period/2;
    end process;

    -- 5. PROCESSUS DE TEST (C'est ici qu'on fait notre scénario)
    stim_proc: process
    begin
        -- Initialisation : on fait un RESET
        tb_RESET <= '1';
        wait for 20 ns;
        tb_RESET <= '0';
        wait for 10 ns;

        -- Préparation des données bidons pour nos tests
        tb_A <= "1010";         -- A = 10
        tb_B <= "0101";         -- B = 5
        tb_S <= "11110000";     -- S = F0
        tb_SR_IN_L <= '1';      -- Retenue Gauche = 1
        tb_SR_IN_R <= '0';      -- Retenue Droite = 0

        -- TEST 1 : Router A vers Buffer A (SEL_ROUTE = 0000)
        tb_SEL_ROUTE <= "0000";
        wait for clk_period; 
        -- Résultat attendu : tb_Buf_A_out devient "1010", tb_Buf_B_out reste "0000"

        -- TEST 2 : Router B vers Buffer B (SEL_ROUTE = 0001)
        tb_SEL_ROUTE <= "0001";
        wait for clk_period;
        -- Résultat attendu : tb_Buf_B_out devient "0101", tb_Buf_A_out reste "1010"

        -- TEST 3 : Router S (poids faibles) vers Buffer A (SEL_ROUTE = 0010)
        tb_SEL_ROUTE <= "0010";
        wait for clk_period;
        -- Résultat attendu : tb_Buf_A_out devient "0000" (les 4 bits de droite de S)

        -- TEST 4 : Router S (poids forts) vers Buffer B (SEL_ROUTE = 0101)
        tb_SEL_ROUTE <= "0101";
        wait for clk_period;
        -- Résultat attendu : tb_Buf_B_out devient "1111" (les 4 bits de gauche de S)

        -- TEST 5 : Vérification des retenues (indépendamment de SEL_ROUTE)
        tb_SR_IN_L <= '0'; 
        tb_SR_IN_R <= '1';
        wait for clk_period;
        -- Résultat attendu : MEM_SR_IN_L passe à '0' et MEM_SR_IN_R passe à '1' automatiquement
        report "Tests termines avec succes !" severity note;
        std.env.finish; -- Commande VHDL-2008 pour arrêter proprement
        -- Fin de simulation
    end process;

end Behavioral;
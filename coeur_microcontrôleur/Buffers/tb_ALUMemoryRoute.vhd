library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ALUMemoryRoute is
-- Un testbench n'a pas de ports
end tb_ALUMemoryRoute;

architecture behavior of tb_ALUMemoryRoute is

    -- 1. Déclaration des composants
    component ALUSELROUTE
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

    component ALUBuffer
        Port (
            CLK         : in  std_logic;
            RESET       : in  std_logic;
            CE_Buf_A    : in  std_logic;
            Buf_A_in    : in  std_logic_vector(3 downto 0);
            CE_Buf_B    : in  std_logic;
            Buf_B_in    : in  std_logic_vector(3 downto 0);
            CE_Mem_1    : in  std_logic;
            Mem_1_In    : in  std_logic_vector(7 downto 0);
            CE_Mem_2    : in  std_logic;
            Mem_2_In    : in  std_logic_vector(7 downto 0);
            SR_IN_L     : in  std_logic;
            SR_IN_R     : in  std_logic;
            Buf_A_out   : out std_logic_vector(3 downto 0);
            Buf_B_out   : out std_logic_vector(3 downto 0);
            Mem_1_out   : out std_logic_vector(7 downto 0);
            Mem_2_out   : out std_logic_vector(7 downto 0);
            MEM_SR_IN_L : out std_logic;
            MEM_SR_IN_R : out std_logic
        );
    end component;

    -- 2. Déclaration des signaux du Testbench
    -- Signaux d'horloge et de reset
    signal tb_CLK   : std_logic := '0';
    signal tb_RESET : std_logic := '0';
    constant CLK_PERIOD : time := 10 ns;

    -- Signaux d'entrée générés par le testbench
    signal tb_SEL_ROUTE : std_logic_vector(3 downto 0) := "0000";
    signal tb_A         : std_logic_vector(3 downto 0) := "0000";
    signal tb_B         : std_logic_vector(3 downto 0) := "0000";
    signal tb_S         : std_logic_vector(7 downto 0) := "00000000";
    signal tb_SR_IN_L   : std_logic := '0';
    signal tb_SR_IN_R   : std_logic := '0';

    -- Signaux d'interconnexion entre ALUSELROUTE et ALUBuffer
    signal sig_CE_Buf_A, sig_CE_Buf_B, sig_CE_Mem_1, sig_CE_Mem_2 : std_logic;
    signal sig_Buf_A_in, sig_Buf_B_in : std_logic_vector(3 downto 0);
    signal sig_Mem_1_In, sig_Mem_2_In : std_logic_vector(7 downto 0);

    -- Signaux de sortie des buffers (rebouclés vers le routeur et observables)
    signal tb_Buf_A_out, tb_Buf_B_out : std_logic_vector(3 downto 0);
    signal tb_Mem_1_out, tb_Mem_2_out : std_logic_vector(7 downto 0);
    signal tb_MEM_SR_IN_L, tb_MEM_SR_IN_R : std_logic;

begin

    -- 3. Instanciations
    Inst_ALUSELROUTE: ALUSELROUTE port map (
        SEL_ROUTE   => tb_SEL_ROUTE,
        A           => tb_A,
        B           => tb_B,
        S           => tb_S,
        s_Mem_1_out => tb_Mem_1_out,
        s_Mem_2_out => tb_Mem_2_out,
        CE_Buf_A    => sig_CE_Buf_A,
        CE_Buf_B    => sig_CE_Buf_B,
        CE_Mem_1    => sig_CE_Mem_1,
        CE_Mem_2    => sig_CE_Mem_2,
        Buf_A_in    => sig_Buf_A_in,
        Buf_B_in    => sig_Buf_B_in,
        Mem_1_In    => sig_Mem_1_In,
        Mem_2_In    => sig_Mem_2_In
    );

    Inst_ALUBuffer: ALUBuffer port map (
        CLK         => tb_CLK,
        RESET       => tb_RESET,
        CE_Buf_A    => sig_CE_Buf_A,
        Buf_A_in    => sig_Buf_A_in,
        CE_Buf_B    => sig_CE_Buf_B,
        Buf_B_in    => sig_Buf_B_in,
        CE_Mem_1    => sig_CE_Mem_1,
        Mem_1_In    => sig_Mem_1_In,
        CE_Mem_2    => sig_CE_Mem_2,
        Mem_2_In    => sig_Mem_2_In,
        SR_IN_L     => tb_SR_IN_L,
        SR_IN_R     => tb_SR_IN_R,
        Buf_A_out   => tb_Buf_A_out,
        Buf_B_out   => tb_Buf_B_out,
        Mem_1_out   => tb_Mem_1_out,
        Mem_2_out   => tb_Mem_2_out,
        MEM_SR_IN_L => tb_MEM_SR_IN_L,
        MEM_SR_IN_R => tb_MEM_SR_IN_R
    );

    -- 4. Génération de l'horloge
    clk_process: process
    begin
        tb_CLK <= '0';
        wait for CLK_PERIOD/2;
        tb_CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;

    -- 5. Processus de stimulus
    stim_proc: process
    begin
        -- Phase d'initialisation et Reset
        tb_RESET <= '1';
        wait for CLK_PERIOD * 2;
        tb_RESET <= '0';
        
        -- Mise en place de données génériques sur les entrées
        tb_A <= "0101"; -- 5
        tb_B <= "1100"; -- C
        tb_S <= "11110000"; -- F0
        wait for CLK_PERIOD;

        -- Test 1 : SEL_ROUTE = "0000" (A_IN -> Buffer A)
        tb_SEL_ROUTE <= "0000";
        wait for CLK_PERIOD; 
        -- Résultat attendu : tb_Buf_A_out devient "0101", les autres ne bougent pas

        -- Test 2 : SEL_ROUTE = "0001" (B_IN -> Buffer B)
        tb_SEL_ROUTE <= "0001";
        wait for CLK_PERIOD;
        -- Résultat attendu : tb_Buf_B_out devient "1100"

        -- Test 3 : SEL_ROUTE = "0110" (S -> Mem_1 / Cache 1)
        tb_SEL_ROUTE <= "0110";
        wait for CLK_PERIOD;
        -- Résultat attendu : tb_Mem_1_out devient "11110000"

        -- Test 4 : SEL_ROUTE = "1001" (Mem_1 poids forts -> Buffer A)
        -- Le routeur doit extraire les bits 7 à 4 de s_Mem_1_out ("1111") et les mettre dans Buf_A
        tb_SEL_ROUTE <= "1001";
        wait for CLK_PERIOD;
        -- Résultat attendu : tb_Buf_A_out devient "1111"

        -- Test 5 : SEL_ROUTE = "0111" (S -> Mem_2 / Cache 2)
        tb_S <= "00001010"; -- Nouvelle valeur de S (0A)
        tb_SEL_ROUTE <= "0111";
        wait for CLK_PERIOD;
        -- Résultat attendu : tb_Mem_2_out devient "00001010"

        -- Fin de la simulation
        wait;
    end process;

end behavior;
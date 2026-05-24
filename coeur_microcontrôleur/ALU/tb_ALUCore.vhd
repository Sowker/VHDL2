library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_ALUCore is
-- Un testbench n'a pas de ports
end tb_ALUCore;

architecture behavior of tb_ALUCore is

    -- 1. Déclaration du composant à tester (Unit Under Test - UUT)
    component ALUCore
    Port (
        Sel_FCT  : in std_logic_vector (3 downto 0);
        SR_OUT_L : out std_logic;
        SR_OUT_R : out std_logic;
        SR_IN_L  : in std_logic;
        SR_IN_R  : in std_logic;
        A_IN     : in std_logic_vector (3 downto 0);
        B_IN     : in std_logic_vector (3 downto 0);
        S        : out std_logic_vector (7 downto 0)
    );
    end component;

    -- 2. Déclaration des signaux internes pour connecter le composant
    -- Signaux d'entrée (initialisés à 0)
    signal tb_Sel_FCT : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_SR_IN_L : std_logic := '0';
    signal tb_SR_IN_R : std_logic := '0';
    signal tb_A_IN    : std_logic_vector(3 downto 0) := (others => '0');
    signal tb_B_IN    : std_logic_vector(3 downto 0) := (others => '0');

    -- Signaux de sortie
    signal tb_SR_OUT_L : std_logic;
    signal tb_SR_OUT_R : std_logic;
    signal tb_S        : std_logic_vector(7 downto 0);

begin

    -- 3. Instanciation du composant (Mapping des ports aux signaux)
    uut: ALUCore port map (
        Sel_FCT  => tb_Sel_FCT,
        SR_OUT_L => tb_SR_OUT_L,
        SR_OUT_R => tb_SR_OUT_R,
        SR_IN_L  => tb_SR_IN_L,
        SR_IN_R  => tb_SR_IN_R,
        A_IN     => tb_A_IN,
        B_IN     => tb_B_IN,
        S        => tb_S
    );

    -- 4. Processus de génération des stimulus (Scénarios de test)
    stimulus_process: process
    begin
        -- Initialisation
        wait for 10 ns;
        
        -- ==========================================
        -- TESTS ARITHMÉTIQUES
        -- ==========================================
        -- Test 1: Addition A + B (Sel_FCT = "1001")
        tb_A_IN <= "0101"; -- 5 en décimal
        tb_B_IN <= "0011"; -- 3 en décimal
        tb_Sel_FCT <= "1001";
        wait for 10 ns; 
        -- Résultat attendu : tb_S = 0000 1000 (8 en décimal)
        
        -- Test 2: Addition avec retenue A + B + SR_IN_R (Sel_FCT = "1000")
        tb_A_IN <= "0110"; -- 6
        tb_B_IN <= "0010"; -- 2
        tb_SR_IN_R <= '1'; -- Retenue d'entrée activée
        tb_Sel_FCT <= "1000";
        wait for 10 ns; 
        -- Résultat attendu : tb_S = 0000 1001 (9 en décimal)
        
        -- Test 3: Soustraction A - B (Sel_FCT = "1010")
        tb_A_IN <= "0111"; -- 7
        tb_B_IN <= "0010"; -- 2
        tb_Sel_FCT <= "1010";
        wait for 10 ns;
        -- Résultat attendu : tb_S = 0000 0101 (5 en décimal)

        -- Test 4: Multiplication A * B (Sel_FCT = "1011")
        tb_A_IN <= "0011"; -- 3
        tb_B_IN <= "0100"; -- 4
        tb_Sel_FCT <= "1011";
        wait for 10 ns;
        -- Résultat attendu : tb_S = 0000 1100 (12 en décimal)

        -- ==========================================
        -- TESTS LOGIQUES
        -- ==========================================
        -- Test 5: ET Logique / AND (Sel_FCT = "0101")
        tb_A_IN <= "1100";
        tb_B_IN <= "1010";
        tb_Sel_FCT <= "0101";
        wait for 10 ns;
        -- Résultat attendu : tb_S = 0000 1000

        -- Test 6: OU Exclusif / XOR (Sel_FCT = "0111")
        tb_A_IN <= "1111";
        tb_B_IN <= "0101";
        tb_Sel_FCT <= "0111";
        wait for 10 ns;
        -- Résultat attendu : tb_S = 0000 1010
        
        -- Test 7: NOT A (Sel_FCT = "0010")
        tb_A_IN <= "0011";
        tb_Sel_FCT <= "0010";
        wait for 10 ns;
        -- Résultat attendu : tb_S = 0000 1100

        -- ==========================================
        -- TESTS DE DÉCALAGE (SHIFT)
        -- ==========================================
        -- Test 8: Décalage à gauche de A (Sel_FCT = "1101")
        tb_A_IN <= "1011"; 
        tb_SR_IN_R <= '1'; -- Le bit de retenue entrant qui sera poussé à droite
        tb_Sel_FCT <= "1101";
        wait for 10 ns;
        -- Résultat attendu : tb_S = 0000 0111, et tb_SR_OUT_L = '1' (car bit de poids fort de A_IN)

        -- Test 9: Décalage à droite de B (Sel_FCT = "1110")
        tb_B_IN <= "1101";
        tb_SR_IN_L <= '0'; -- Le bit entrant qui sera poussé à gauche
        tb_Sel_FCT <= "1110";
        wait for 10 ns;
        -- Résultat attendu : tb_S = 0000 0110, et tb_SR_OUT_R = '1' (car bit de poids faible de B_IN)

        -- ==========================================
        -- FIN DE LA SIMULATION
        -- ==========================================
        -- Remise à zéro (NOP)
        tb_Sel_FCT <= "0000";
        wait for 10 ns;

        -- Stoppe la simulation indéfiniment
        wait;
    end process;

end behavior;
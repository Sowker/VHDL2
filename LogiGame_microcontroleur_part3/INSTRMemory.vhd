library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRMemory is
    Port (
        CLK         : in  std_logic;
        RESET       : in  std_logic;
        BTN_1       : in  std_logic;
        BTN_2       : in  std_logic;
        BTN_3       : in  std_logic;
        
        SEL_ROUTE   : out std_logic_vector(3 downto 0);
        SEL_FCT     : out std_logic_vector(3 downto 0);
        SEL_OUT     : out std_logic_vector(1 downto 0)
    );
end INSTRMemory;

architecture Behavioral of INSTRMemory is

    type rom_type is array (0 to 127) of std_logic_vector(9 downto 0);
    
    constant instructions_rom : rom_type := (
        0 => "0000" & "0000" & "00", -- NOP de sécurité

        -- === AUTOMATE 1 (LFSR) : Calcul du prochain état pseudo-aléatoire ===
        1 => "0000" & "0000" & "00", -- Etape 1 : NOP (Nettoyage des retenues)
        2 => "0000" & "0000" & "00", -- Etape 2 : A_IN (Valeur LFSR actuelle) dans BufA
        3 => "0100" & "1100" & "00", -- Etape 3 : Shift Right Buf_A -> Buf_B
        4 => "0100" & "0111" & "00", -- Etape 4 : Buf_A XOR Buf_B -> Buf_B
        5 => "0100" & "1110" & "00", -- Etape 5 : Shift Right Buf_B -> Buf_B
        6 => "0100" & "1110" & "00", -- Etape 6 : Shift Right Buf_B -> Buf_B
        7 => "0100" & "1110" & "00", -- Etape 7 : Shift Right Buf_B (Le bit XOR tombe dans SR_OUT_R)
        8 => "0110" & "1101" & "00", -- Etape 8 : Shift Left Buf_A (aspire SR_IN_R) -> Cache 1
        9 => "0000" & "0000" & "01", -- Etape 9 : Affichage final (RES_OUT = Cache 1)
        
        others => "0000000001"
    );

    signal pc : integer range 0 to 127 := 0;

begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            pc <= 0;
        elsif falling_edge(CLK) then 
            
            -- 1. Le Wrapper lance le calcul via le BTN_1
            if BTN_1 = '1' then
                pc <= 1;  -- Départ Automate 1 (LFSR)
                
            -- 2. ETATS D'ARRET (HALT) : On bloque le processeur à la fin
            elsif pc = 0 then
                pc <= 0;  -- Arrêt au démarrage (attente)
            
            elsif pc = 9 then
                pc <= 9;  -- CORRECTION ICI : Arrêt à l'étape 9 (Fin du LFSR) !
                
            -- 3. Sinon, on avance d'une ligne
            elsif pc < 127 then
                pc <= pc + 1;
            else
                pc <= 127; -- Sécurité
            end if;
        end if;
    end process;

    SEL_ROUTE <= instructions_rom(pc)(9 downto 6);
    SEL_FCT   <= instructions_rom(pc)(5 downto 2);
    SEL_OUT   <= instructions_rom(pc)(1 downto 0);

end Behavioral;
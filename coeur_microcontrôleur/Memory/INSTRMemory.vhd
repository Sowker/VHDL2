library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRMemory is
    Port (
        CLK         : in  std_logic;
        RESET       : in  std_logic;
        -- Les boutons pour lancer les calculs
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

        -- === AUTOMATE 1 : Multiplication (A * B) ===
        1 => "0000" & "0000" & "00", -- Etape 1 : A_IN dans BufA
        2 => "0001" & "0000" & "00", -- Etape 2 : B_IN dans BufB
        3 => "0110" & "1011" & "00", -- Etape 3 : S = Buf_A * Buf_B -> Cache 1
        4 => "0000" & "0000" & "01", -- Etape 4 : Affichage Automate 1 (RES_OUT = Cache 1)

        -- === AUTOMATE 2 : (A + B) XNOR A ===
        5 => "0000" & "0000" & "00", -- Charger A_IN dans BufA
        6 => "0001" & "0000" & "00", -- Charger B_IN dans BufB
        7 => "0110" & "1001" & "00", -- S = A + B -> Cache 1
        8 => "1010" & "0000" & "00", -- Charger Cache 1 dans BufB
        9 => "0111" & "0111" & "00", -- S = BufA (A) XOR BufB (A+B) -> Cache 2
        10=> "1100" & "0000" & "00", -- Charger Cache 2 dans BufA
        11=> "0110" & "0010" & "00", -- S = NOT BufA -> Cache 1 (Résultat final)
        12=> "0000" & "0000" & "01", -- Affichage Automate 2

        -- === AUTOMATE 3 : (A0 AND B1) OR (A1 AND B0) ===
        13=> "0000" & "0000" & "00", 
        14=> "0001" & "0000" & "00", 
        15=> "0111" & "1110" & "00", 
        16=> "1110" & "0000" & "00", 
        17=> "0110" & "0101" & "00", 
        18=> "0111" & "1100" & "00", 
        19=> "1100" & "0000" & "00", 
        20=> "0001" & "0000" & "00", 
        21=> "0111" & "0101" & "00", 
        22=> "1000" & "0000" & "00", 
        23=> "1110" & "0000" & "00", 
        24=> "0110" & "0110" & "00", -- Résultat brut parasité

        -- Masquage (Génération du 0001)
        25=> "0010" & "0000" & "00", 
        26=> "0010" & "0010" & "00", 
        27=> "0010" & "1100" & "00", 
        28=> "0010" & "1100" & "00", 
        29=> "0010" & "1100" & "00", 

        -- Masquage (AND final)
        30=> "1010" & "0000" & "00", 
        31=> "0110" & "0101" & "00", 
        
        -- Affichage final Automate 3
        32=> "0000" & "0000" & "01",
        
        -- Maintien de l'affichage jusqu'à la fin
        others => "0000000001"
    );

    signal pc : integer range 0 to 127 := 0;

begin
    process(CLK, RESET)
    begin
        if RESET = '1' then
            pc <= 0;
        elsif falling_edge(CLK) then 
            -- 1. Les boutons forcent le saut vers le bon programme
            if BTN_1 = '1' then
                pc <= 1;  -- Départ Automate 1
            elsif BTN_2 = '1' then
                pc <= 5;  -- Départ Automate 2
            elsif BTN_3 = '1' then
                pc <= 13; -- Départ Automate 3
                
            -- 2. ETATS D'ARRET (HALT) : On bloque le processeur à la fin
            elsif pc = 0 then
                pc <= 0;  -- Arrêt au démarrage (attente)
            elsif pc = 4 then
                pc <= 4;  -- Arrêt à la fin de l'Automate 1
            elsif pc = 12 then
                pc <= 12; -- Arrêt à la fin de l'Automate 2
            elsif pc = 32 then
                pc <= 32; -- Arrêt à la fin de l'Automate 3
                
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
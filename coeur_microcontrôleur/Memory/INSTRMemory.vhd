library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity INSTRMemory is
    Port (
        CLK         : in  std_logic;
        RESET       : in  std_logic;
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

        -- PAUSE POUR AFFICHER LE RESULTAT 1
        4 => "0000" & "0000" & "01", -- Affichage (SEL_OUT = 01)
        5 => "0000" & "0000" & "01",
        6 => "0000" & "0000" & "01",
        7 => "0000" & "0000" & "01",
        8 => "0000" & "0000" & "01",

        -- === AUTOMATE 2 : (A + B) XNOR A ===
        9 => "0000" & "0000" & "00", -- Charger A_IN dans BufA
        10=> "0001" & "0000" & "00", -- Charger B_IN dans BufB
        11=> "0110" & "1001" & "00", -- S = A + B -> Cache 1
        12=> "1010" & "0000" & "00", -- Charger Cache 1 dans BufB
        13=> "0111" & "0111" & "00", -- S = BufA (A) XOR BufB (A+B) -> Cache 2
        14=> "1100" & "0000" & "00", -- Charger Cache 2 dans BufA
        15=> "0110" & "0010" & "00", -- S = NOT BufA -> Cache 1 (Résultat final)
        
        -- PAUSE POUR AFFICHER LE RESULTAT 2
        16=> "0000" & "0000" & "01",
        17=> "0000" & "0000" & "01",
        18=> "0000" & "0000" & "01",
        19=> "0000" & "0000" & "01",
        20=> "0000" & "0000" & "01",

        -- === AUTOMATE 3 : (A0 AND B1) OR (A1 AND B0) ===
        21=> "0000" & "0000" & "00", 
        22=> "0001" & "0000" & "00", 
        23=> "0111" & "1110" & "00", 
        24=> "1110" & "0000" & "00", 
        25=> "0110" & "0101" & "00", 
        26=> "0111" & "1100" & "00", 
        27=> "1100" & "0000" & "00", 
        28=> "0001" & "0000" & "00", 
        29=> "0111" & "0101" & "00", 
        30=> "1000" & "0000" & "00", 
        31=> "1110" & "0000" & "00", 
        32=> "0110" & "0110" & "00", -- Résultat brut parasité

        -- Masquage (Génération du 0001)
        33=> "0010" & "0000" & "00", 
        34=> "0010" & "0010" & "00", 
        35=> "0010" & "1100" & "00", 
        36=> "0010" & "1100" & "00", 
        37=> "0010" & "1100" & "00", 

        -- Masquage (AND final)
        38=> "1010" & "0000" & "00", 
        39=> "0110" & "0101" & "00", 
        
        -- Affichage final Automate 3
        40=> "0000" & "0000" & "01",
        
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
            if pc < 127 then
                pc <= pc + 1;
            else
                pc <= 0;
            end if;
        end if;
    end process;

    SEL_ROUTE <= instructions_rom(pc)(9 downto 6);
    SEL_FCT   <= instructions_rom(pc)(5 downto 2);
    SEL_OUT   <= instructions_rom(pc)(1 downto 0);

end Behavioral;